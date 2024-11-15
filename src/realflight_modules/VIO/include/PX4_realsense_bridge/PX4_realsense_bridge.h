#ifndef PX4_REALSENSE_BRIDGE
#define PX4_REALSENSE_BRIDGE

#include <nav_msgs/Odometry.h>
#include <mavros_msgs/CompanionProcessStatus.h>
#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <tf/transform_listener.h>
#include <thread>
#include <mutex>

namespace bridge
{

  enum class MAV_STATE
  {
    MAV_STATE_UNINIT,             // 未初始化
    MAV_STATE_BOOT,               // 启动
    MAV_STATE_CALIBRATIN,         // 校准
    MAV_STATE_STANDBY,            // 待命
    MAV_STATE_ACTIVE,             // 活跃
    MAV_STATE_CRITICAL,           // 危急
    MAV_STATE_EMERGENCY,          // 应急
    MAV_STATE_POWEROFF,           // 关机
    MAV_STATE_FLIGHT_TERMINATION, // 飞行终止
  };

  class PX4_Realsense_Bridge
  {
  public:
    PX4_Realsense_Bridge(const ros::NodeHandle &nh); // 构造函数，传入ros节点句柄
    ~PX4_Realsense_Bridge();                         // 析构函数，在对象生命周期结束时执行清理工作

    void publishSystemStatus(); // 发布系统状态

    std::thread worker_; // 声明一个线程对象，用于线程管理

  private:
    ros::NodeHandle nh_; // 节点句柄对象

    // Subscribers
    ros::Subscriber odom_sub_; // 订阅里程计
    // Publishers
    ros::Publisher mavros_odom_pub_;          // 发布里程计
    ros::Publisher mavros_system_status_pub_; // 发布系统状态

    MAV_STATE system_status_{MAV_STATE::MAV_STATE_UNINIT}; // 声明两个状态枚举变量
    MAV_STATE last_system_status_{MAV_STATE::MAV_STATE_UNINIT};

    std::unique_ptr<std::mutex> status_mutex_; // 智能指针，指向一个 std::mutex 对象

    void odomCallback(const nav_msgs::Odometry &msg);   //回调函数

    bool flag_first_pose_received{false};      //声明一个布尔值，记录是否获得位姿

    ros::Time last_callback_time;   //时间戳
  };
}
#endif // PX4_REALSENSE_BRIDGE
