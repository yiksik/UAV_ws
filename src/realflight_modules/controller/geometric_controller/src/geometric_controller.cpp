//  July/2018, ETHZ, Jaeyoung Lim, jalim@student.ethz.ch

#include "geometric_controller/geometric_controller.h"

using namespace Eigen;
using namespace std;
// Constructor 构造函数
geometricCtrl::geometricCtrl(const ros::NodeHandle &nh,
                             const ros::NodeHandle &nh_private)
    : nh_(nh), nh_private_(nh_private), fail_detec_(false), ctrl_enable_(true),
      landing_commanded_(false), feedthrough_enable_(false),
      node_state(WAITING_FOR_HOME_POSE) {
  referenceSub_ =
      nh_.subscribe("reference/setpoint", 1, &geometricCtrl::targetCallback,            //航点设置，函数算加速度
                    this, ros::TransportHints().tcpNoDelay());
  flatreferenceSub_ = nh_.subscribe("reference/flatsetpoint", 1,
                                    &geometricCtrl::flattargetCallback, this,           //加速度控制
                                    ros::TransportHints().tcpNoDelay());

  // ttargetposeSub_ = nh_.subscribe("move_base_simple/goal", 1,
  //                             &geometricCtrl::ttargetposeCallback, this,
  //                             ros::TransportHints().tcpNoDelay());
  targetexistSub_ = nh_.subscribe("planning/target_exist", 1,
                              &geometricCtrl::targetexistCallback, this,
                              ros::TransportHints().tcpNoDelay());
  quadcmdSub_ =
      nh_.subscribe("planning/pos_cmd/none", 1, &geometricCtrl::quadmsgCallback,           //ego_planner输出控制命令                   /*重要指令*/
                    this, ros::TransportHints().tcpNoDelay());
  yawreferenceSub_ =
      nh_.subscribe("reference/yaw", 1, &geometricCtrl::yawtargetCallback, this,
                    ros::TransportHints().tcpNoDelay());
  multiDOFJointSub_ = nh_.subscribe("command/trajectory", 1,
                                    &geometricCtrl::multiDOFJointCallback, this,
                                    ros::TransportHints().tcpNoDelay());
  mavstateSub_ =
      nh_.subscribe("mavros/state", 1, &geometricCtrl::mavstateCallback, this,
                    ros::TransportHints().tcpNoDelay());
  mavposeSub_ = nh_.subscribe("mavros/local_position/pose", 1,
                              &geometricCtrl::mavposeCallback, this,
                              ros::TransportHints().tcpNoDelay());
             
  mavtwistSub_ = nh_.subscribe("mavros/local_position/velocity_local", 1,
                               &geometricCtrl::mavtwistCallback, this,
                               ros::TransportHints().tcpNoDelay());

  arucopose_ = nh_.subscribe("/aruco/cmd",1,
                              &geometricCtrl::arucoCallback, this,
                              ros::TransportHints().tcpNoDelay());
                              
  

  ctrltriggerServ_ = nh_.advertiseService(
      "tigger_rlcontroller", &geometricCtrl::ctrltriggerCallback, this);
  cmdloop_timer_ =
      nh_.createTimer(ros::Duration(0.01), &geometricCtrl::cmdloopCallback,
                      this); // Define timer for constant loop rate                  //创建命令定时器
  statusloop_timer_ =
      nh_.createTimer(ros::Duration(1), &geometricCtrl::statusloopCallback,
                      this); // Define timer for constant loop rate

  angularVelPub_ =
      nh_.advertise<mavros_msgs::AttitudeTarget>("command/bodyrate_command", 1);
  referencePosePub_ =
      nh_.advertise<geometry_msgs::PoseStamped>("reference/pose", 1);
  target_pose_pub_ = nh_.advertise<geometry_msgs::PoseStamped>(
      "mavros/setpoint_position/local", 10);                                        //位置点控制
  target_velocity_pub_ = nh_.advertise<geometry_msgs::TwistStamped>(
      "mavros/setpoint_velocity/cmd_vel", 1);                                       //速度控制
  posehistoryPub_ =
      nh_.advertise<nav_msgs::Path>("geometric_controller/path", 10);
  systemstatusPub_ = nh_.advertise<mavros_msgs::CompanionProcessStatus>(
      "mavros/companion_process/status", 1);
  arming_client_ =
      nh_.serviceClient<mavros_msgs::CommandBool>("mavros/cmd/arming");
  set_mode_client_ = nh_.serviceClient<mavros_msgs::SetMode>("mavros/set_mode");
  land_service_ =
      nh_.advertiseService("land", &geometricCtrl::landCallback, this);
  last_request_ = ros::Time::now();
  nh_private_.param<string>("mavname", mav_name_, "iris");
  nh_private_.param<int>("ctrl_mode", ctrl_mode_, ERROR_QUATERNION);
  nh_private_.param<bool>("enable_sim", sim_enable_, true);
  nh_private_.param<bool>("velocity_yaw", velocity_yaw_, false);
  nh_private_.param<double>("max_acc", max_fb_acc_, 9.0);
  nh_private_.param<double>("yaw_heading", mavYaw_, 0.0);
  nh_private_.param<double>("drag_dx", dx_, 0.0);
  nh_private_.param<double>("drag_dy", dy_, 0.0);
  nh_private_.param<double>("drag_dz", dz_, 0.0);
  nh_private_.param<double>("attctrl_constant", attctrl_tau_, 0.5);
  nh_private_.param<double>("normalizedthrust_constant", norm_thrust_const_,
                            0.070

  ); // 1 / max acceleration
  nh_private_.param<double>("normalizedthrust_offset", norm_thrust_offset_,
                            0.1); // 1 / max acceleration
  nh_private_.param<double>("Kp_x", Kpos_x_, 8.0);
  nh_private_.param<double>("Kp_y", Kpos_y_, 8.0);
  nh_private_.param<double>("Kp_z", Kpos_z_, 10.0);
  nh_private_.param<double>("Kv_x", Kvel_x_, 1.5);
  nh_private_.param<double>("Kv_y", Kvel_y_, 1.5);
  nh_private_.param<double>("Kv_z", Kvel_z_, 3.3);
  nh_private_.param<double>("Karuco_angle", Karuco_angle, 1);
  nh_private_.param<double>("Karuco_velx", Karuco_velx, 1);
  nh_private_.param<double>("Karuco_vely", Karuco_vely, 1);
  nh_private_.param<int>("posehistory_window", posehistory_window_, 200);
  nh_private_.param<double>("init_pos_x", initTargetPos_x_, 0.0);
  nh_private_.param<double>("init_pos_y", initTargetPos_y_, 0.0);
  nh_private_.param<double>("init_pos_z", initTargetPos_z_, 5.0);

  targetPos_ << initTargetPos_x_, initTargetPos_y_,
      initTargetPos_z_; // Initial Position
  targetVel_ << 0.0, 0.0, 0.0;
  mavPos_ << 0.0, 0.0, 0.0;
  mavVel_ << 0.0, 0.0, 0.0;
  g_ << 0.0, 0.0, -9.8;
  Kpos_ << -Kpos_x_, -Kpos_y_, -Kpos_z_;
  Kvel_ << -Kvel_x_, -Kvel_y_, -Kvel_z_;
  Karuco_<<Karuco_angle,Karuco_velx,Karuco_vely;

  D_ << dx_, dy_, dz_;

  tau << tau_x, tau_y, tau_z;
}
geometricCtrl::~geometricCtrl() {
  // Destructor
}

float geometricCtrl::satfunc(float data, float Max) {

  if (abs(data) > Max)
    return (data > 0) ? Max : -Max;
  else
    return data;
}

void geometricCtrl::arucoCallback(const std_msgs::Float32MultiArray &msg){
  aruco_cmd_ << msg.data.at(0),msg.data.at(1),msg.data.at(2);
  // std::cout<<"    aruco_cmd:" << aruco_cmd_<<endl;
  // std::cout<<"    Karuco_:" << Karuco_<<endl;
}



//把加速度算出来
void geometricCtrl::targetCallback(const geometry_msgs::TwistStamped &msg) {
  reference_request_last_ = reference_request_now_;
  targetPos_prev_ = targetPos_;
  targetVel_prev_ = targetVel_;

  reference_request_now_ = ros::Time::now();
  reference_request_dt_ =
      (reference_request_now_ - reference_request_last_).toSec();

  targetPos_ = toEigen(msg.twist.angular);
  targetVel_ = toEigen(msg.twist.linear);

  if (reference_request_dt_ > 0)
    targetAcc_ = (targetVel_ - targetVel_prev_) / reference_request_dt_;
  else
    targetAcc_ = Eigen::Vector3d::Zero();
}

//接受ego_planner发出的航迹，
void geometricCtrl::quadmsgCallback(
    const quadrotor_msgs::PositionCommand::ConstPtr &cmd) {
  node_state = MISSION_EXECUTION;
  reference_request_last_ = reference_request_now_;

  targetPos_prev_ = targetPos_;
  targetVel_prev_ = targetVel_;

  reference_request_now_ = ros::Time::now();
  cmdpos_time_last_ = reference_request_now_;

  reference_request_dt_ =
      (reference_request_now_ - reference_request_last_).toSec();

  targetPos_ =
      Eigen::Vector3d(cmd->position.x, cmd->position.y, cmd->position.z);
  targetVel_ =
      Eigen::Vector3d(cmd->velocity.x, cmd->velocity.y, cmd->velocity.z);
  targetAcc_ = Eigen::Vector3d(cmd->acceleration.x, cmd->acceleration.y,
                               cmd->acceleration.z);
  targetJerk_ = Eigen::Vector3d::Zero();  //jerk加速度的导数
  targetSnap_ = Eigen::Vector3d::Zero();
  mavYaw_ = double(cmd->yaw);
  // cmdBodyRate_[2] = cmd->yaw_dot;
}

void geometricCtrl::flattargetCallback(const controller_msgs::FlatTarget &msg) {
  node_state = MISSION_EXECUTION;                                               //任务执行
  reference_request_last_ = reference_request_now_;

  targetPos_prev_ = targetPos_;
  targetVel_prev_ = targetVel_;

  reference_request_now_ = ros::Time::now();
  reference_request_dt_ =
      (reference_request_now_ - reference_request_last_).toSec();

  targetPos_ = toEigen(msg.position);
  targetVel_ = toEigen(msg.velocity);

  // if (mavVel_.norm() > 1)
  // velocity_yaw_ = true;
  if (msg.type_mask == 1) {                                                   //type_mask控制掩码 8 4 2 1  4：都不用 2：只用加速度 1：用加速度和加速度一阶导数 其他：全用
    targetAcc_ = toEigen(msg.acceleration);
    targetJerk_ = toEigen(msg.jerk);
    targetSnap_ = Eigen::Vector3d::Zero();
  } else if (msg.type_mask == 2) {
    targetAcc_ = toEigen(msg.acceleration);
    targetJerk_ = Eigen::Vector3d::Zero();
    targetSnap_ = Eigen::Vector3d::Zero();
  } else if (msg.type_mask == 4) {
    targetAcc_ = Eigen::Vector3d::Zero();
    targetJerk_ = Eigen::Vector3d::Zero();
    targetSnap_ = Eigen::Vector3d::Zero();
  } else {
    targetAcc_ = toEigen(msg.acceleration);
    targetJerk_ = toEigen(msg.jerk);
    targetSnap_ = toEigen(msg.snap);
  }
}

void geometricCtrl::yawtargetCallback(const std_msgs::Float32 &msg) {         //偏航角旋转速度
  if (!velocity_yaw_)
    mavYaw_ = double(msg.data);
}

void geometricCtrl::multiDOFJointCallback(
    const trajectory_msgs::MultiDOFJointTrajectory &msg) {
  trajectory_msgs::MultiDOFJointTrajectoryPoint pt = msg.points[0];
  reference_request_last_ = reference_request_now_;

  targetPos_prev_ = targetPos_;
  targetVel_prev_ = targetVel_;

  reference_request_now_ = ros::Time::now();
  reference_request_dt_ =
      (reference_request_now_ - reference_request_last_).toSec();

  targetPos_ << pt.transforms[0].translation.x, pt.transforms[0].translation.y,
      pt.transforms[0].translation.z;
  targetVel_ << pt.velocities[0].linear.x, pt.velocities[0].linear.y,
      pt.velocities[0].linear.z;

  targetAcc_ << pt.accelerations[0].linear.x, pt.accelerations[0].linear.y,
      pt.accelerations[0].linear.z;
  targetJerk_ = Eigen::Vector3d::Zero();
  targetSnap_ = Eigen::Vector3d::Zero();

  if (!velocity_yaw_) {
    Eigen::Quaterniond q(
        pt.transforms[0].rotation.w, pt.transforms[0].rotation.x,
        pt.transforms[0].rotation.y, pt.transforms[0].rotation.z);
    Eigen::Vector3d rpy = Eigen::Matrix3d(q).eulerAngles(0, 1, 2); // RPY
    mavYaw_ = rpy(2);
  }
}



void geometricCtrl::ttargetposeCallback(const geometry_msgs::PoseStamped &msg) {

  target_mavPos_ = toEigen(msg.pose.position);

}

//接受规划器输出的路径，不存在路径就悬停
void geometricCtrl::targetexistCallback(const std_msgs::Bool &msg) {
  if((msg.data == 0) && (node_state != WAITING_FOR_HOME_POSE) && (node_state != TAKING_OFF)){
    cout << node_state <<endl;
    node_state = MISSION_HOLD;
    cout << "enter MISSION_HOLE" <<endl;
  }
  if(first_enter_hold){
    holdTargetPos_x_ = mavPos_(0);
    holdTargetPos_y_ = mavPos_(1);
    holdTargetPos_z_ = mavPos_(2);
    holdAtt_x = mavAtt_(1);
    holdAtt_y = mavAtt_(2);
    holdAtt_z = mavAtt_(3);
    holdAtt_w = mavAtt_(0);
    cout << "1" <<endl;
    first_enter_hold = false;
  }
}


void geometricCtrl::mavposeCallback(const geometry_msgs::PoseStamped &msg) {
  if (!received_home_pose) {
    received_home_pose = true;
    home_pose_ = msg.pose;
    ROS_INFO_STREAM("Home pose initialized to: " << home_pose_);
  }
  mavPos_ = toEigen(msg.pose.position);
  mavAtt_(0) = msg.pose.orientation.w;
  mavAtt_(1) = msg.pose.orientation.x;
  mavAtt_(2) = msg.pose.orientation.y;
  mavAtt_(3) = msg.pose.orientation.z;
}

void geometricCtrl::mavtwistCallback(const geometry_msgs::TwistStamped &msg) {
  mavVel_ = toEigen(msg.twist.linear);
  mavRate_ = toEigen(msg.twist.angular);
}

bool geometricCtrl::landCallback(std_srvs::SetBool::Request &request,
                                 std_srvs::SetBool::Response &response) {
  node_state = LANDING;//aruco_ctrl; 
}

void geometricCtrl::cmdloopCallback(const ros::TimerEvent &event) {                 //几何控制，状态机
  switch (node_state) {                                                             //
  case WAITING_FOR_HOME_POSE:
    waitForPredicate(&received_home_pose, "Waiting for home pose...");
    ROS_INFO("Got pose! Drone Ready to be armed.");
    // node_state = MISSION_EXECUTION;
    node_state = TAKING_OFF;
    break;

  case TAKING_OFF: {
    geometry_msgs::PoseStamped takingoff_msg;
    takingoff_msg.header.stamp = ros::Time::now();
    takingoff_msg.pose.position.x = initTargetPos_x_;
    takingoff_msg.pose.position.y = initTargetPos_y_;
    takingoff_msg.pose.position.z = initTargetPos_z_;
    takingoff_msg.pose.orientation.x = 0;
    takingoff_msg.pose.orientation.y = 0;
    takingoff_msg.pose.orientation.z = 0;
    takingoff_msg.pose.orientation.w = 1;
    target_pose_pub_.publish(takingoff_msg);
    ros::spinOnce();
    break;
  }

// cla_distance(const Eigen::Vector3d &target_pos)
  case MISSION_EXECUTION:
  {
    // dtttt = (ros::Time::now() - cmdpos_time_last_).toSec();

    // std::cout << "TIME  " << dtttt << std::endl;
    // // cla_distance(target_mavPos_);
    // //if (  cla_distance(targetPos_) || (      ( ros::Time::now() - cmdpos_time_last_).toSec() > 0.01 )     )
    // if (  cla_distance(targetPos_) )
    // {
    //   std::cout << "                                   changetoHOLD  " << dtttt << std::endl;
    //   node_state = MISSION_HOLD;
    //   holdTargetPos_x_ = mavPos_(0);
    //   holdTargetPos_y_ = mavPos_(1);
    //   holdTargetPos_z_ = mavPos_(2);
    //   ros::spinOnce();
    // }
    // else
    // {
    //   geometry_msgs::PoseStamped takingoff_msg;
    // takingoff_msg.header.stamp = ros::Time::now();
    // takingoff_msg.pose.position.x = targetPos_.x();
    // takingoff_msg.pose.position.y = targetPos_.y();
    // takingoff_msg.pose.position.z = targetPos_.z();
    //   target_pose_pub_.publish(takingoff_msg);
    
      std::cout << "                                   missionexection  " << dtttt << std::endl;
      first_enter_hold = true;
      if (!feedthrough_enable_)
      computeBodyRateCmd(cmdBodyRate_, targetPos_, targetVel_, targetAcc_);
      pubReferencePose(targetPos_, q_des);
      pubRateCommands(cmdBodyRate_);
      appendPoseHistory();
      pubPoseHistory();
      ros::spinOnce();
    //  }
    break;
  }

  case MISSION_HOLD: {
    std::cout << "                                   HOLDHOLDHOLD  " << dtttt << std::endl;
    geometry_msgs::PoseStamped takingoff_msg;

    takingoff_msg.header.stamp = ros::Time::now();
    takingoff_msg.pose.position.x = holdTargetPos_x_;
    takingoff_msg.pose.position.y = holdTargetPos_y_;
    takingoff_msg.pose.position.z = holdTargetPos_z_;
    takingoff_msg.pose.orientation.w = holdAtt_w;
    takingoff_msg.pose.orientation.x = holdAtt_x;
    takingoff_msg.pose.orientation.y = holdAtt_y;
    takingoff_msg.pose.orientation.z = holdAtt_z;
    target_pose_pub_.publish(takingoff_msg);
    ros::spinOnce();
    break;
  }
  case aruco_ctrl:{
    std::cout << "                                   aruco control now!  " << dtttt << std::endl;
    computeAruco_vel(aruco_cmd_);
    if (mavPos_(2) <= 0.3) {
    if (current_state_.mode != "AUTO.LAND") {
      offb_set_mode_.request.custom_mode = "AUTO.LAND";
      if (set_mode_client_.call(offb_set_mode_) &&
          offb_set_mode_.response.mode_sent) {
        ROS_INFO("AUTO.LAN enabled");
      }
      node_state = LANDED;
    }
  } 
    break;
  }
  case LANDING: {
    if (autoland())
      node_state = LANDED;
    ros::spinOnce();
    break;
  }
  case LANDED:
    ROS_INFO("Landed. Please set to position control and disarm.");
    cmdloop_timer_.stop();
    break;
  }
}
//高度低于0.3则自动下降
bool geometricCtrl::autoland() {
  geometry_msgs::PoseStamped landingmsg;
  if (mavPos_(2) <= 0.3) {
    if (current_state_.mode != "AUTO.LAND") {
      offb_set_mode_.request.custom_mode = "AUTO.LAND";
      if (set_mode_client_.call(offb_set_mode_) &&
          offb_set_mode_.response.mode_sent) {
        ROS_INFO("AUTO.LAN enabled");
        return true;
      }
    }
  } 
  else {
    landingmsg.header.stamp = ros::Time::now();
    landingmsg.pose.position.z = 0.15;
    landingmsg.pose.position.x = mavPos_(0);
    landingmsg.pose.position.y = mavPos_(1);
    landingmsg.pose.orientation.w = mavAtt_(0);
    landingmsg.pose.orientation.x = mavAtt_(1);
    landingmsg.pose.orientation.y = mavAtt_(2);
    landingmsg.pose.orientation.z = mavAtt_(3);
    target_pose_pub_.publish(landingmsg);
  }
  return false;
}

void geometricCtrl::mavstateCallback(const mavros_msgs::State::ConstPtr &msg) {
  current_state_ = *msg;
}

void geometricCtrl::statusloopCallback(const ros::TimerEvent &event) {
  if (sim_enable_) {
    // Enable OFFBoard mode and arm automatically
    // This is only run if the vehicle is simulated
    arm_cmd_.request.value = true;
    offb_set_mode_.request.custom_mode = "OFFBOARD";
    if (current_state_.mode != "OFFBOARD" &&
        (ros::Time::now() - last_request_ > ros::Duration(2.0))) {
      if (set_mode_client_.call(offb_set_mode_) &&
          offb_set_mode_.response.mode_sent) {
        ROS_INFO("Offboard enabled");
      }
      last_request_ = ros::Time::now();
    } else {
      if (!current_state_.armed &&
          (ros::Time::now() - last_request_ > ros::Duration(2.0))) {
        if (arming_client_.call(arm_cmd_) && arm_cmd_.response.success) {
          ROS_INFO("Vehicle armed");
        }
        last_request_ = ros::Time::now();
      }
    }
  }
  pubSystemStatus();
}

void geometricCtrl::pubReferencePose(const Eigen::Vector3d &target_position,
                                     const Eigen::Vector4d &target_attitude) {
  geometry_msgs::PoseStamped msg;

  msg.header.stamp = ros::Time::now();
  msg.header.frame_id = "map";
  msg.pose.position.x = target_position(0);
  msg.pose.position.y = target_position(1);
  msg.pose.position.z = target_position(2);
  msg.pose.orientation.w = target_attitude(0);
  msg.pose.orientation.x = target_attitude(1);
  msg.pose.orientation.y = target_attitude(2);
  msg.pose.orientation.z = target_attitude(3);
  referencePosePub_.publish(msg);
}

void geometricCtrl::pubRateCommands(const Eigen::Vector4d &cmd) {
  mavros_msgs::AttitudeTarget msg;
  double maxVelocity = 6.0;
  geometry_msgs::TwistStamped velocity_msg;
  msg.header.stamp = ros::Time::now();
  msg.header.frame_id = "map";
  msg.body_rate.x = cmd(0);
  msg.body_rate.y = cmd(1);
  msg.body_rate.z = cmd(2);
  msg.type_mask = 128; // Ignore orientation messages
  msg.thrust = cmd(3);

  // Publish velocity cmd (PI controller)
  const Eigen::Vector3d pos_error = targetPos_ - mavPos_;
  const Eigen::Vector3d vel_error = targetVel_ - mavVel_;
  // Eigen::Vector3d v_fb = 0.1 * Kpos_.asDiagonal() * pos_error +
  //                        0.1 * Kvel_.asDiagonal() *
  //                            vel_error; // feedback term for trajectory error
  velocity_msg.twist.linear.x =
      satfunc(velocity_msg.twist.linear.x, maxVelocity);
  velocity_msg.twist.linear.y =
      satfunc(velocity_msg.twist.linear.y, maxVelocity);
  velocity_msg.twist.linear.z = satfunc(velocity_msg.twist.linear.z, maxVelocity);
  angularVelPub_.publish(msg);
//  target_velocity_pub_.publish(velocity_msg);
}

void geometricCtrl::pubPoseHistory() {
  nav_msgs::Path msg;

  msg.header.stamp = ros::Time::now();
  msg.header.frame_id = "map";
  msg.poses = posehistory_vector_;

  posehistoryPub_.publish(msg);
}

void geometricCtrl::pubSystemStatus() {
  mavros_msgs::CompanionProcessStatus msg;

  msg.header.stamp = ros::Time::now();
  msg.component = 196; // MAV_COMPONENT_ID_AVOIDANCE
  msg.state = (int)companion_state_;

  systemstatusPub_.publish(msg);
}

void geometricCtrl::appendPoseHistory() {
  posehistory_vector_.insert(posehistory_vector_.begin(),
                             vector3d2PoseStampedMsg(mavPos_, mavAtt_));
  if (posehistory_vector_.size() > posehistory_window_) {
    posehistory_vector_.pop_back();
  }
}

geometry_msgs::PoseStamped
geometricCtrl::vector3d2PoseStampedMsg(Eigen::Vector3d &position,
                                       Eigen::Vector4d &orientation) {
  geometry_msgs::PoseStamped encode_msg;
  encode_msg.header.stamp = ros::Time::now();
  encode_msg.header.frame_id = "map";
  encode_msg.pose.orientation.w = orientation(0);
  encode_msg.pose.orientation.x = orientation(1);
  encode_msg.pose.orientation.y = orientation(2);
  encode_msg.pose.orientation.z = orientation(3);
  encode_msg.pose.position.x = position(0);
  encode_msg.pose.position.y = position(1);
  encode_msg.pose.position.z = position(2);
  return encode_msg;
}

//计算二维码控制的速度
Eigen::Vector3d geometricCtrl::computeAruco_vel(Eigen::Vector3d &aruco_cmd){
  Eigen::Vector3d vel_aruco = Karuco_.asDiagonal() * aruco_cmd;
  cout << "vel_aruco:" << vel_aruco.norm();
  geometry_msgs::TwistStamped velocity_msg;
  velocity_msg.header.stamp = ros::Time::now();
  velocity_msg.header.frame_id = "map";
  velocity_msg.twist.angular.z =
      satfunc(vel_aruco[0], 1);
  velocity_msg.twist.linear.x =
      satfunc(vel_aruco[1], 1);
  velocity_msg.twist.linear.y =
      satfunc(vel_aruco[2], 1);
  velocity_msg.twist.linear.z = -0.2;
  target_velocity_pub_.publish(velocity_msg);
}

//输入 机体速率命令 期望位置速度加速度
void geometricCtrl::computeBodyRateCmd(Eigen::Vector4d &bodyrate_cmd,
                                       const Eigen::Vector3d &target_pos,
                                       const Eigen::Vector3d &target_vel,
                                       const Eigen::Vector3d &target_acc) {
  /// Compute BodyRate commands using differential flatness
  /// Controller based on Faessler 2017
  const Eigen::Vector3d a_ref = target_acc;
  if (velocity_yaw_) {                          
    mavYaw_ = getVelocityYaw(mavVel_);                                          //从当前机体速度获取当前的偏航角
  }
  const Eigen::Vector4d q_ref = acc2quaternion(a_ref - g_, mavYaw_);            //加速度计解算四元数姿态角
  const Eigen::Matrix3d R_ref = quat2RotMatrix(q_ref);

  const Eigen::Vector3d pos_error = mavPos_ - target_pos;
  const Eigen::Vector3d vel_error = mavVel_ - target_vel;
  std::cout << "the position error is: " << pos_error(2) << std::endl;
  Eigen::Vector3d a_fb =
      Kpos_.asDiagonal() * pos_error +
      Kvel_.asDiagonal() * vel_error; // feedforward term for trajectory error
  // if (a_fb.norm() > max_fb_acc_){
  //   a_fb = (max_fb_acc_ / a_fb.norm()) *
  //          a_fb; // Clip acceleration if reference is too large
  //   std::cout << "the a_fb is: " << a_fb << std::endl;
  //   ROS_WARN("a_fb is too large!!!!!!!!!!!");
  // }
  std::cout << "a_fb" << a_fb.norm()<<endl;
  const Eigen::Vector3d a_rd =
      R_ref * D_.asDiagonal() * R_ref.transpose() * target_vel; // Rotor drag
  const Eigen::Vector3d a_des = a_fb + a_ref - a_rd - g_;

  q_des = acc2quaternion(a_des, mavYaw_);
 

  if (ctrl_mode_ == ERROR_GEOMETRIC) {
    bodyrate_cmd =
        geometric_attcontroller(q_des, a_des, mavAtt_); // Calculate BodyRate
  } else {
    bodyrate_cmd = attcontroller(q_des, a_des, mavAtt_); // Calculate BodyRate
  }
}

// 增加距离误差判断
// bool geometricCtrl::cla_distance(const Eigen::Vector3d &target_pos)
// {
//   double temp_delte = 0.2;

//   const Eigen::Vector3d pos_error3 = target_mavPos_ - target_pos;
//   // std::cout << "the position error is: " << pos_error(2) << std::endl;
//   Eigen::Vector2d pos_error;
//   pos_error(0) = pos_error3(0);
//   pos_error(1) = pos_error3(1);

//   if (pos_error.norm() < temp_delte)
//   {
//     std::cout << "HOLD  delta<0.2 | " << pos_error.norm() << std::endl;
//     return 1;
//   }
//   else
//   {
//     std::cout << "MOVE  delta>0.2 | " << pos_error.norm() << std::endl;
//     return 0;
//   }

// }




//p * q
Eigen::Vector4d geometricCtrl::quatMultiplication(const Eigen::Vector4d &q,
                                                  const Eigen::Vector4d &p) {
  Eigen::Vector4d quat;
  quat << p(0) * q(0) - p(1) * q(1) - p(2) * q(2) - p(3) * q(3),
      p(0) * q(1) + p(1) * q(0) - p(2) * q(3) + p(3) * q(2),
      p(0) * q(2) + p(1) * q(3) + p(2) * q(0) - p(3) * q(1),
      p(0) * q(3) - p(1) * q(2) + p(2) * q(1) + p(3) * q(0);
  return quat;
}

Eigen::Matrix3d geometricCtrl::quat2RotMatrix(const Eigen::Vector4d &q) {
  Eigen::Matrix3d rotmat;
  rotmat << q(0) * q(0) + q(1) * q(1) - q(2) * q(2) - q(3) * q(3),
      2 * q(1) * q(2) - 2 * q(0) * q(3), 2 * q(0) * q(2) + 2 * q(1) * q(3),

      2 * q(0) * q(3) + 2 * q(1) * q(2),
      q(0) * q(0) - q(1) * q(1) + q(2) * q(2) - q(3) * q(3),
      2 * q(2) * q(3) - 2 * q(0) * q(1),

      2 * q(1) * q(3) - 2 * q(0) * q(2), 2 * q(0) * q(1) + 2 * q(2) * q(3),
      q(0) * q(0) - q(1) * q(1) - q(2) * q(2) + q(3) * q(3);
  return rotmat;
}

Eigen::Vector4d geometricCtrl::rot2Quaternion(const Eigen::Matrix3d &R) {
  Eigen::Vector4d quat;
  double tr = R.trace();
  if (tr > 0.0) {
    double S = sqrt(tr + 1.0) * 2.0; // S=4*qw
    quat(0) = 0.25 * S;
    quat(1) = (R(2, 1) - R(1, 2)) / S;
    quat(2) = (R(0, 2) - R(2, 0)) / S;
    quat(3) = (R(1, 0) - R(0, 1)) / S;
  } else if ((R(0, 0) > R(1, 1)) & (R(0, 0) > R(2, 2))) {
    double S = sqrt(1.0 + R(0, 0) - R(1, 1) - R(2, 2)) * 2.0; // S=4*qx
    quat(0) = (R(2, 1) - R(1, 2)) / S;
    quat(1) = 0.25 * S;
    quat(2) = (R(0, 1) + R(1, 0)) / S;
    quat(3) = (R(0, 2) + R(2, 0)) / S;
  } else if (R(1, 1) > R(2, 2)) {
    double S = sqrt(1.0 + R(1, 1) - R(0, 0) - R(2, 2)) * 2.0; // S=4*qy
    quat(0) = (R(0, 2) - R(2, 0)) / S;
    quat(1) = (R(0, 1) + R(1, 0)) / S;
    quat(2) = 0.25 * S;
    quat(3) = (R(1, 2) + R(2, 1)) / S;
  } else {
    double S = sqrt(1.0 + R(2, 2) - R(0, 0) - R(1, 1)) * 2.0; // S=4*qz
    quat(0) = (R(1, 0) - R(0, 1)) / S;
    quat(1) = (R(0, 2) + R(2, 0)) / S;
    quat(2) = (R(1, 2) + R(2, 1)) / S;
    quat(3) = 0.25 * S;
  }
  return quat;
}
//微分平坦计算旋转矩阵
Eigen::Vector4d geometricCtrl::acc2quaternion(const Eigen::Vector3d &vector_acc,
                                              const double &yaw) {
  Eigen::Vector4d quat;
  Eigen::Vector3d zb_des, yb_des, xb_des, proj_xb_des;
  Eigen::Matrix3d rotmat;

  proj_xb_des << std::cos(yaw), std::sin(yaw), 0.0;

  zb_des = vector_acc / vector_acc.norm();                    //归一化        巧妙，坐标旋转的方向无人机Z轴方向
  yb_des = zb_des.cross(proj_xb_des) / (zb_des.cross(proj_xb_des)).norm();    //无人机Y轴方向
  xb_des = yb_des.cross(zb_des) / (yb_des.cross(zb_des)).norm();              //无人机X轴方向

  rotmat << xb_des(0), yb_des(0), zb_des(0), xb_des(1), yb_des(1), zb_des(1),
      xb_des(2), yb_des(2), zb_des(2);
  quat = rot2Quaternion(rotmat);
  return quat;
}
//算出速度偏航方向
double geometricCtrl::getVelocityYaw(const Eigen::Vector3d velocity) {
  return atan2(velocity(1), velocity(0)); 
}
//输入期望的姿态、期望加速度、当前姿态
Eigen::Vector4d geometricCtrl::attcontroller(const Eigen::Vector4d &ref_att,
                                             const Eigen::Vector3d &ref_acc,
                                             Eigen::Vector4d &curr_att) {
  // Geometric attitude controller
  // Attitude error is defined as in Brescianini, Dario, Markus Hehn, and
  // Raffaello D'Andrea. Nonlinear quadrocopter attitude control: Technical
  // report. ETH Zurich, 2013.

  Eigen::Vector4d ratecmd;
  Eigen::Vector4d qe, q_inv, inverse;
  Eigen::Matrix3d rotmat;
  Eigen::Vector3d zb;

  inverse << 1.0, -1.0, -1.0, -1.0;
  q_inv = inverse.asDiagonal() * curr_att;  //求共轭



  qe = quatMultiplication(q_inv, ref_att);    //获取C相对于B的姿态

  ratecmd(0) = (2.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(1);    //copysign获取第一个值的数据第二个值的符号
  ratecmd(1) = (2.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(2);
  ratecmd(2) = (1.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(3);
  rotmat = quat2RotMatrix(mavAtt_);
  zb = rotmat.col(2);
  ratecmd(3) =
      std::max(0.0, std::min(1.0, norm_thrust_const_ * ref_acc.dot(zb) +
                                      norm_thrust_offset_)); // Calculate thrust

  return ratecmd;
}

Eigen::Vector4d
geometricCtrl::geometric_attcontroller(const Eigen::Vector4d &ref_att,
                                       const Eigen::Vector3d &ref_acc,
                                       Eigen::Vector4d &curr_att) {
  // Geometric attitude controller
  // Attitude error is defined as in Lee, Taeyoung, Melvin Leok, and N. Harris
  // McClamroch. "Geometric tracking control of a quadrotor UAV on SE (3)." 49th
  // IEEE conference on decision and control (CDC). IEEE, 2010. The original
  // paper inputs moment commands, but for offboard control angular rate
  // commands are sent

  Eigen::Vector4d ratecmd;
  Eigen::Matrix3d rotmat;   // Rotation matrix of current atttitude
  Eigen::Matrix3d rotmat_d; // Rotation matrix of desired attitude
  Eigen::Vector3d zb;
  Eigen::Vector3d error_att;

  rotmat = quat2RotMatrix(curr_att);
  rotmat_d = quat2RotMatrix(ref_att);

  error_att = 0.5 * matrix_hat_inv(rotmat_d.transpose() * rotmat -
                                   rotmat.transpose() * rotmat);
  ratecmd.head(3) = (2.0 / attctrl_tau_) * error_att;
  rotmat = quat2RotMatrix(mavAtt_);
  zb = rotmat.col(2);
  ratecmd(3) =
      std::max(0.0, std::min(1.0, norm_thrust_const_ * ref_acc.dot(zb) +
                                      norm_thrust_offset_)); // Calculate thrust

  return ratecmd;
}

Eigen::Matrix3d geometricCtrl::matrix_hat(const Eigen::Vector3d &v) {
  Eigen::Matrix3d m;
  // Sanity checks on M
  m << 0.0, -v(2), v(1), v(2), 0.0, -v(0), -v(1), v(0), 0.0;
  return m;
}

Eigen::Vector3d geometricCtrl::matrix_hat_inv(const Eigen::Matrix3d &m) {
  Eigen::Vector3d v;
  // TODO: Sanity checks if m is skew symmetric
  v << m(7), m(2), m(3);
  return v;
}

void geometricCtrl::getStates(Eigen::Vector3d &pos, Eigen::Vector4d &att,
                              Eigen::Vector3d &vel, Eigen::Vector3d &angvel) {
  pos = mavPos_;
  att = mavAtt_;
  vel = mavVel_;
  angvel = mavRate_;
}

void geometricCtrl::getErrors(Eigen::Vector3d &pos, Eigen::Vector3d &vel) {
  pos = mavPos_ - targetPos_;
  vel = mavVel_ - targetVel_;
}

bool geometricCtrl::ctrltriggerCallback(std_srvs::SetBool::Request &req,
                                        std_srvs::SetBool::Response &res) {
  unsigned char mode = req.data;

  ctrl_mode_ = mode;
  res.success = ctrl_mode_;
  res.message = "controller triggered";
}

void geometricCtrl::setBodyRateCommand(Eigen::Vector4d bodyrate_command) {
  cmdBodyRate_ = bodyrate_command;
}

void geometricCtrl::setFeedthrough(bool feed_through) {
  feedthrough_enable_ = feed_through;
}

void geometricCtrl::dynamicReconfigureCallback(
    geometric_controller::GeometricControllerConfig &config, uint32_t level) {      //动态参数回调函数
  if (max_fb_acc_ != config.max_acc) {
    max_fb_acc_ = config.max_acc;
    ROS_INFO("Reconfigure request : max_acc = %.2f ", config.max_acc);
  } else if (Kpos_x_ != config.Kp_x) {
    Kpos_x_ = config.Kp_x;
    ROS_INFO("Reconfigure request : Kp_x  = %.2f  ", config.Kp_x);
  } else if (Kpos_y_ != config.Kp_y) {
    Kpos_y_ = config.Kp_y;
    ROS_INFO("Reconfigure request : Kp_y  = %.2f  ", config.Kp_y);
  } else if (Kpos_z_ != config.Kp_z) {
    Kpos_z_ = config.Kp_z;
    ROS_INFO("Reconfigure request : Kp_z  = %.2f  ", config.Kp_z);
  } else if (Kvel_x_ != config.Kv_x) {
    Kvel_x_ = config.Kv_x;
    ROS_INFO("Reconfigure request : Kv_x  = %.2f  ", config.Kv_x);
  } else if (Kvel_y_ != config.Kv_y) {
    Kvel_y_ = config.Kv_y;
    ROS_INFO("Reconfigure request : Kv_y =%.2f  ", config.Kv_y);
  } else if (Kvel_z_ != config.Kv_z) {
    Kvel_z_ = config.Kv_z;
    ROS_INFO("Reconfigure request : Kv_z  = %.2f  ", config.Kv_z);
  }else if (Karuco_angle != config.Karuco_angle) {
    Karuco_angle = config.Karuco_angle;
    ROS_INFO("Reconfigure request : Karuco_angle  = %.2f  ", config.Karuco_angle);
  }else if (Karuco_velx != config.Karuco_velx) {
    Karuco_velx = config.Karuco_velx;
    ROS_INFO("Reconfigure request : Karuco_velx  = %.2f  ", config.Karuco_velx);
  }else if (Karuco_vely != config.Karuco_vely) {
    Karuco_vely = config.Karuco_vely;
    ROS_INFO("Reconfigure request : Karuco_vely  = %.2f  ", config.Karuco_vely);
  }

  Kpos_ << -Kpos_x_, -Kpos_y_, -Kpos_z_;
  Kvel_ << -Kvel_x_, -Kvel_y_, -Kvel_z_;
  Karuco_<<Karuco_angle,Karuco_velx,Karuco_vely;
}