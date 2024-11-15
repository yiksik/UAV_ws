#!/usr/bin/env python
import rospy
from goal import publish_goal

if __name__ == '__main__':
    try:
        rospy.init_node('publish_goal', anonymous=True)

        publish_goal(2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0)
        rospy.sleep(5)
        publish_goal(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0)

        rospy.spin()
    except rospy.ROSInterruptException:
        pass