#!/usr/bin/env python3
import numpy as np
import time
import cv2, math
import cv2.aruco as aruco
from _02_Aruco_development import Aruco_development
from std_msgs.msg import Float32MultiArray
import rospy

cap = cv2.VideoCapture(0)

# mtx = np.array([[483.3314, 0      , 291.6761], [0      , 380.5020, 245.6134], [ 0        , 0        , 1        ]])
# dist = np.array([[-0.0916, -0.0852,  0.0217, -0.0214]])

# mtx = np.array([[538.3000, 0      , 323.0242], [0      , 537.7739, 249.5598], [ 0        , 0        , 1        ]]) 
# dist = np.array([[-0.3932, 0.1689, -0.0017, 0.0011]])

mtx = np.array([[564.5227, -1.1096 , 312.8541], [0      , 566.5789, 219.1828], [ 0        , 0        , 1        ]]) 
dist = np.array([[-0.4098, 0.2200, -0.1058, -1.6292e-04,0.0036]])

dict = aruco.getPredefinedDictionary(aruco.DICT_4X4_250) #aruco字典
Aruco = Aruco_development(mtx,dist)
msg = Float32MultiArray()
if  __name__ == '__main__':
    try:
        pub = rospy.Publisher('aruco/cmd', Float32MultiArray, queue_size=100)
        rospy.init_node('aruco_detect', anonymous=True)
        rate = rospy.Rate(30)
        while not rospy.is_shutdown():
            ret, frame = cap.read()
            data, ROI, ret, LightImg= Aruco.PnP_get_distance_and_ROI_Draw(frame,dict)
            msg.data = data.tolist()
            # print("data:",data,"ret:",ret)
            if ret == 1:
                pub.publish(msg)
            cv2.imshow("frame", frame)
            key = cv2.waitKey(1)
            rate.sleep()
    except rospy.ROSInterruptException:
        pass
        

    # while True:
    #     ret, frame = cap.read()
    #     anglevel_z,tvec, ROI, ret, LightImg= Aruco.PnP_get_distance_and_ROI_Draw(frame,dict)
    #     print("ang_vel:",anglevel_z,"tvec",tvec,"ret:",ret)

    #     cv2.imshow("frame", frame)
    #     key = cv2.waitKey(1)
