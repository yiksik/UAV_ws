# Install script for directory: /home/fcs/UAV/UAV_WS/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/fcs/UAV/UAV_WS/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  
      if (NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}")
        file(MAKE_DIRECTORY "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}")
      endif()
      if (NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/.catkin")
        file(WRITE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/.catkin" "")
      endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/_setup_util.py")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE PROGRAM FILES "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/_setup_util.py")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/env.sh")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE PROGRAM FILES "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/env.sh")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/setup.bash;/home/fcs/UAV/UAV_WS/install/local_setup.bash")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE FILE FILES
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/setup.bash"
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/local_setup.bash"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/setup.sh;/home/fcs/UAV/UAV_WS/install/local_setup.sh")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE FILE FILES
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/setup.sh"
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/local_setup.sh"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/setup.zsh;/home/fcs/UAV/UAV_WS/install/local_setup.zsh")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE FILE FILES
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/setup.zsh"
    "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/local_setup.zsh"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/fcs/UAV/UAV_WS/install/.rosinstall")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/fcs/UAV/UAV_WS/install" TYPE FILE FILES "/home/fcs/UAV/UAV_WS/build/catkin_generated/installspace/.rosinstall")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/fcs/UAV/UAV_WS/build/gtest/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/catkin_simple/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/realsense-ros/realsense2_description/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/DecompROS/decomp_ros_msgs/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/controller/camera_pose_node/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/cmake_utils/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/map_generator/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/plan_env/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/path_searching/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/pose_utils/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/quadrotor_msgs/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/fake_drone/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/auto_search/search_plan/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/drone_detect/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/controller/controller_msgs/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/auto_search/target_merge/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/odom_visualization/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/local_sensing/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/mockamap/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/realsense-ros/realsense2_camera/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/so3_control/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/traj_utils/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/bspline_opt/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/plan_manage/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/planner/rosmsg_tcp_bridge/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/uav_utils/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/uav_simulator/so3_quadrotor_simulator/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/controller/geometric_controller/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/realflight_modules/VIO/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/DecompROS/decomp_ros_utils/cmake_install.cmake")
  include("/home/fcs/UAV/UAV_WS/build/utils/rviz_plugins/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/fcs/UAV/UAV_WS/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
