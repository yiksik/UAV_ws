#!/usr/bin/env python
import rospy
from geometry_msgs.msg import PoseStamped

#发布目标点到move_base
def publish_goal(x, y, z, qx, qy, qz, qw):
    pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=10)

    rospy.sleep(1)

    goal = PoseStamped()
    goal.header.seq = 0
    goal.header.stamp = rospy.Time.now()
    goal.header.frame_id = 'map'
    goal.pose.position.x = x
    goal.pose.position.y = y
    goal.pose.position.z = z
    goal.pose.orientation.x = qx
    goal.pose.orientation.y = qy
    goal.pose.orientation.z = qz
    goal.pose.orientation.w = qw
    pub.publish(goal)

    print("publish goal!")
