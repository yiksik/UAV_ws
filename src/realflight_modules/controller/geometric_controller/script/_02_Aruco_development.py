# -*- coding:utf-8 _*-
"""
@author:Wu Xinhui
@time: 2022/07/06
"""
import numpy as np
import cv2
#import matplotlib.pyplot as plt
from cv2 import aruco
import math
#import cv2.aruco as aruco
#from cv2 import aruco

np.set_printoptions(suppress=True, precision=4)
EMap = np.loadtxt('/home/zjy/catkin_ws/src/ego-planner/controller/geometric_controller/script/EMap.txt')
CV_PI = 3.1415
class Aruco_development:

    def __init__(self,Camera_internal_reference,Distortion_coefficient) -> None:
        self.Camera_internal_reference=Camera_internal_reference
        self.Distortion_coefficient=Distortion_coefficient
        self.ROI = None
        self.thetaz = float()
        self.tvec = np.empty((0, 3))
        self.data_return = np.empty((0, 4))
    def isRotationMatrix(self,R) :
        Rt = np.transpose(R)
        shouldBeIdentity = np.dot(Rt, R)
        I = np.identity(3, dtype = R.dtype)
        n = np.linalg.norm(I - shouldBeIdentity)
        return n < 1e-6

    def rotationMatrixToEulerAngles(self,R) :
        assert(self.isRotationMatrix(R))
        sy = math.sqrt(R[0,0] * R[0,0] +  R[1,0] * R[1,0])
        singular = sy < 1e-6
        if  not singular :
            x = math.atan2(R[2,1] , R[2,2])
            y = math.atan2(-R[2,0], sy)
            z = math.atan2(R[1,0], R[0,0])
        else :
            x = math.atan2(-R[1,2], R[1,1])
            y = math.atan2(-R[2,0], sy)
            z = 0
        return np.array([x, y, z])


    def get_corners(self,Frame,dict):
        Corners, IDs, _ = aruco.detectMarkers(Frame, dict)
        return Corners, IDs
    
    def draw_and_get_corners(self,Frame,dict):
        Corners, IDs, _ = aruco.detectMarkers(Frame, dict)
        Frame = aruco.drawDetectedMarkers(Frame,Corners,IDs)
        return Corners, IDs

    def PnP_get_distance_and_ROI(self,Frame,dict):
        Point3D = np.empty((0, 3))                                                                  #角点在世界坐标系下的世界坐标左上 左下 右上右下
        Point2D = np.empty((0, 2))                                                                  #aruco计算出的图像坐标
        Distance = None
        ROI = None
        ret=0
        Corners, IDs, _ = aruco.detectMarkers(Frame, dict)
        all_Point2D = []
        if len(Corners) != 0:
            for i,Corner in enumerate(Corners):
                Point3D = np.empty((0, 3))
                Point2D = np.empty((0, 2))
                ID = IDs.flatten()[i]
                print(ID)
                if  ID > 2:
                    print(1)
                    continue
                Point3D = np.vstack((Point3D, np.hstack((EMap[(ID-1), 1:9].reshape(-1, 2), np.zeros((4, 1))))))         #h水平拼接，v垂直拼接
                Point2D = np.vstack((Point2D, Corner.reshape(-1, 2)))
            
                ret, RvecW2C, tW2C = cv2.solvePnP(Point3D, Point2D, self.Camera_internal_reference, self.Distortion_coefficient)  # 解算位姿
                RW2C = cv2.Rodrigues(RvecW2C)[0]
                RC2W = np.linalg.inv(RW2C)
                tC2W = -np.linalg.inv(RW2C).dot(tW2C)
                Distance = tC2W.flatten()[2]
                for axis in Point2D:
                    all_Point2D.append(axis)
            if len(all_Point2D)>0:  
                ROI = np.hstack((np.min(all_Point2D,axis=0),np.max(all_Point2D,axis=0))).astype(np.int)
                ret = 1
        if Distance is None:
            Distance = 9999
        return Distance, ROI, ret, Frame

    def PnP_get_distance_and_ROI_Draw(self,Frame,dict):
        Point3D = np.empty((0, 3))
        Point2D = np.empty((0, 2))
        ROI = None
        ret = 0
        Corners, IDs, _ = aruco.detectMarkers(Frame,dict)
        # print("Corners:",Corners, "IDs:", IDs)
        # print(IDs)
        all_Point2D = []
        if len(Corners) != 0:
            Frame = aruco.drawDetectedMarkers(Frame,Corners,IDs)
            for i,Corner in enumerate(Corners):                 #同时获得索引和值索引有1个,array存放三维数组，只有一个三维数组
                # print("corner:",Corner)
                Point3D = np.empty((0, 3))
                Point2D =np.empty((0, 2))
                ID = IDs.flatten()[i]
                if  ID > 2:
                    continue
                Point3D = np.vstack((Point3D, np.hstack((EMap[(ID-1), 1:9].reshape(-1, 2), np.zeros((4, 1))))))         #三维世界坐标点，四行三列x y z
                Point2D = np.vstack((Point2D, Corner.reshape(-1, 2)))           #二维图像点 四个，四行两列x y

                ret, RvecW2C, tW2C = cv2.solvePnP(Point3D, Point2D, self.Camera_internal_reference, self.Distortion_coefficient)  # 解算位姿
                RW2C = cv2.Rodrigues(RvecW2C)[0]                                                            #罗德里格斯转换为旋转矩阵
                self.thetaz = -math.atan2(RW2C[1][0], RW2C[0][0])               #Z轴旋转速度
                self.tvec = tW2C.flatten()/50
                self.tvec[1] = -1* self.tvec[1]
                self.data_return = np.hstack((self.thetaz,self.tvec))
                # print("z:",thetaz)
                # print("tvec",tvec,"tW2C:", tW2C.flatten())
                for axis in Point2D:
                    all_Point2D.append(axis)
                if len(all_Point2D)>0:  
                    ROI = np.hstack((np.min(all_Point2D,axis=0),np.max(all_Point2D,axis=0))).astype(np.int)
                    ret = 1
        # cv2.putText(Frame, str(Distance), (10,30), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 3)
        return self.data_return,ROI, ret, Frame

        


