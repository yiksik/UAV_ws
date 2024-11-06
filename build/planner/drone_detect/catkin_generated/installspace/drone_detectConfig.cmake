# generated from catkin/cmake/template/pkgConfig.cmake.in

# append elements to a list and remove existing duplicates from the list
# copied from catkin/cmake/list_append_deduplicate.cmake to keep pkgConfig
# self contained
macro(_list_append_deduplicate listname)
  if(NOT "${ARGN}" STREQUAL "")
    if(${listname})
      list(REMOVE_ITEM ${listname} ${ARGN})
    endif()
    list(APPEND ${listname} ${ARGN})
  endif()
endmacro()

# append elements to a list if they are not already in the list
# copied from catkin/cmake/list_append_unique.cmake to keep pkgConfig
# self contained
macro(_list_append_unique listname)
  foreach(_item ${ARGN})
    list(FIND ${listname} ${_item} _index)
    if(_index EQUAL -1)
      list(APPEND ${listname} ${_item})
    endif()
  endforeach()
endmacro()

# pack a list of libraries with optional build configuration keywords
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_pack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  set(_argn ${ARGN})
  list(LENGTH _argn _count)
  set(_index 0)
  while(${_index} LESS ${_count})
    list(GET _argn ${_index} lib)
    if("${lib}" MATCHES "^(debug|optimized|general)$")
      math(EXPR _index "${_index} + 1")
      if(${_index} EQUAL ${_count})
        message(FATAL_ERROR "_pack_libraries_with_build_configuration() the list of libraries '${ARGN}' ends with '${lib}' which is a build configuration keyword and must be followed by a library")
      endif()
      list(GET _argn ${_index} library)
      list(APPEND ${VAR} "${lib}${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}${library}")
    else()
      list(APPEND ${VAR} "${lib}")
    endif()
    math(EXPR _index "${_index} + 1")
  endwhile()
endmacro()

# unpack a list of libraries with optional build configuration keyword prefixes
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_unpack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  foreach(lib ${ARGN})
    string(REGEX REPLACE "^(debug|optimized|general)${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}(.+)$" "\\1;\\2" lib "${lib}")
    list(APPEND ${VAR} "${lib}")
  endforeach()
endmacro()


if(drone_detect_CONFIG_INCLUDED)
  return()
endif()
set(drone_detect_CONFIG_INCLUDED TRUE)

# set variables for source/devel/install prefixes
if("FALSE" STREQUAL "TRUE")
  set(drone_detect_SOURCE_PREFIX /home/fcs/UAV/UAV_WS/src/planner/drone_detect)
  set(drone_detect_DEVEL_PREFIX /home/fcs/UAV/UAV_WS/devel)
  set(drone_detect_INSTALL_PREFIX "")
  set(drone_detect_PREFIX ${drone_detect_DEVEL_PREFIX})
else()
  set(drone_detect_SOURCE_PREFIX "")
  set(drone_detect_DEVEL_PREFIX "")
  set(drone_detect_INSTALL_PREFIX /home/fcs/UAV/UAV_WS/install)
  set(drone_detect_PREFIX ${drone_detect_INSTALL_PREFIX})
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "WARNING: package 'drone_detect' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  message("${_msg}")
endif()

# flag project as catkin-based to distinguish if a find_package()-ed project is a catkin project
set(drone_detect_FOUND_CATKIN_PROJECT TRUE)

if(NOT "include;/usr/include/eigen3;/usr/local/include/opencv4;/usr/include " STREQUAL " ")
  set(drone_detect_INCLUDE_DIRS "")
  set(_include_dirs "include;/usr/include/eigen3;/usr/local/include/opencv4;/usr/include")
  if(NOT " " STREQUAL " ")
    set(_report "Check the issue tracker '' and consider creating a ticket if the problem has not been reported yet.")
  elseif(NOT " " STREQUAL " ")
    set(_report "Check the website '' for information and consider reporting the problem.")
  else()
    set(_report "Report the problem to the maintainer 'Jiangchao Zhu <zjujiangchaozhu@gmail.com>' and request to fix the problem.")
  endif()
  foreach(idir ${_include_dirs})
    if(IS_ABSOLUTE ${idir} AND IS_DIRECTORY ${idir})
      set(include ${idir})
    elseif("${idir} " STREQUAL "include ")
      get_filename_component(include "${drone_detect_DIR}/../../../include" ABSOLUTE)
      if(NOT IS_DIRECTORY ${include})
        message(FATAL_ERROR "Project 'drone_detect' specifies '${idir}' as an include dir, which is not found.  It does not exist in '${include}'.  ${_report}")
      endif()
    else()
      message(FATAL_ERROR "Project 'drone_detect' specifies '${idir}' as an include dir, which is not found.  It does neither exist as an absolute directory nor in '\${prefix}/${idir}'.  ${_report}")
    endif()
    _list_append_unique(drone_detect_INCLUDE_DIRS ${include})
  endforeach()
endif()

set(libraries "/usr/local/lib/libopencv_calib3d.so.4.2.0;/usr/local/lib/libopencv_core.so.4.2.0;/usr/local/lib/libopencv_dnn.so.4.2.0;/usr/local/lib/libopencv_features2d.so.4.2.0;/usr/local/lib/libopencv_flann.so.4.2.0;/usr/local/lib/libopencv_gapi.so.4.2.0;/usr/local/lib/libopencv_highgui.so.4.2.0;/usr/local/lib/libopencv_imgcodecs.so.4.2.0;/usr/local/lib/libopencv_imgproc.so.4.2.0;/usr/local/lib/libopencv_ml.so.4.2.0;/usr/local/lib/libopencv_objdetect.so.4.2.0;/usr/local/lib/libopencv_photo.so.4.2.0;/usr/local/lib/libopencv_stitching.so.4.2.0;/usr/local/lib/libopencv_video.so.4.2.0;/usr/local/lib/libopencv_videoio.so.4.2.0;/usr/local/lib/libopencv_aruco.so.4.2.0;/usr/local/lib/libopencv_bgsegm.so.4.2.0;/usr/local/lib/libopencv_bioinspired.so.4.2.0;/usr/local/lib/libopencv_ccalib.so.4.2.0;/usr/local/lib/libopencv_datasets.so.4.2.0;/usr/local/lib/libopencv_dnn_objdetect.so.4.2.0;/usr/local/lib/libopencv_dnn_superres.so.4.2.0;/usr/local/lib/libopencv_dpm.so.4.2.0;/usr/local/lib/libopencv_face.so.4.2.0;/usr/local/lib/libopencv_freetype.so.4.2.0;/usr/local/lib/libopencv_fuzzy.so.4.2.0;/usr/local/lib/libopencv_hdf.so.4.2.0;/usr/local/lib/libopencv_hfs.so.4.2.0;/usr/local/lib/libopencv_img_hash.so.4.2.0;/usr/local/lib/libopencv_line_descriptor.so.4.2.0;/usr/local/lib/libopencv_optflow.so.4.2.0;/usr/local/lib/libopencv_phase_unwrapping.so.4.2.0;/usr/local/lib/libopencv_plot.so.4.2.0;/usr/local/lib/libopencv_quality.so.4.2.0;/usr/local/lib/libopencv_reg.so.4.2.0;/usr/local/lib/libopencv_rgbd.so.4.2.0;/usr/local/lib/libopencv_saliency.so.4.2.0;/usr/local/lib/libopencv_shape.so.4.2.0;/usr/local/lib/libopencv_stereo.so.4.2.0;/usr/local/lib/libopencv_structured_light.so.4.2.0;/usr/local/lib/libopencv_superres.so.4.2.0;/usr/local/lib/libopencv_surface_matching.so.4.2.0;/usr/local/lib/libopencv_text.so.4.2.0;/usr/local/lib/libopencv_tracking.so.4.2.0;/usr/local/lib/libopencv_videostab.so.4.2.0;/usr/local/lib/libopencv_viz.so.4.2.0;/usr/local/lib/libopencv_xfeatures2d.so.4.2.0;/usr/local/lib/libopencv_ximgproc.so.4.2.0;/usr/local/lib/libopencv_xobjdetect.so.4.2.0;/usr/local/lib/libopencv_xphoto.so.4.2.0")
foreach(library ${libraries})
  # keep build configuration keywords, target names and absolute libraries as-is
  if("${library}" MATCHES "^(debug|optimized|general)$")
    list(APPEND drone_detect_LIBRARIES ${library})
  elseif(${library} MATCHES "^-l")
    list(APPEND drone_detect_LIBRARIES ${library})
  elseif(${library} MATCHES "^-")
    # This is a linker flag/option (like -pthread)
    # There's no standard variable for these, so create an interface library to hold it
    if(NOT drone_detect_NUM_DUMMY_TARGETS)
      set(drone_detect_NUM_DUMMY_TARGETS 0)
    endif()
    # Make sure the target name is unique
    set(interface_target_name "catkin::drone_detect::wrapped-linker-option${drone_detect_NUM_DUMMY_TARGETS}")
    while(TARGET "${interface_target_name}")
      math(EXPR drone_detect_NUM_DUMMY_TARGETS "${drone_detect_NUM_DUMMY_TARGETS}+1")
      set(interface_target_name "catkin::drone_detect::wrapped-linker-option${drone_detect_NUM_DUMMY_TARGETS}")
    endwhile()
    add_library("${interface_target_name}" INTERFACE IMPORTED)
    if("${CMAKE_VERSION}" VERSION_LESS "3.13.0")
      set_property(
        TARGET
        "${interface_target_name}"
        APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${library}")
    else()
      target_link_options("${interface_target_name}" INTERFACE "${library}")
    endif()
    list(APPEND drone_detect_LIBRARIES "${interface_target_name}")
  elseif(TARGET ${library})
    list(APPEND drone_detect_LIBRARIES ${library})
  elseif(IS_ABSOLUTE ${library})
    list(APPEND drone_detect_LIBRARIES ${library})
  else()
    set(lib_path "")
    set(lib "${library}-NOTFOUND")
    # since the path where the library is found is returned we have to iterate over the paths manually
    foreach(path /home/fcs/UAV/UAV_WS/install/lib;/opt/ros/noetic/lib)
      find_library(lib ${library}
        PATHS ${path}
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
      if(lib)
        set(lib_path ${path})
        break()
      endif()
    endforeach()
    if(lib)
      _list_append_unique(drone_detect_LIBRARY_DIRS ${lib_path})
      list(APPEND drone_detect_LIBRARIES ${lib})
    else()
      # as a fall back for non-catkin libraries try to search globally
      find_library(lib ${library})
      if(NOT lib)
        message(FATAL_ERROR "Project '${PROJECT_NAME}' tried to find library '${library}'.  The library is neither a target nor built/installed properly.  Did you compile project 'drone_detect'?  Did you find_package() it before the subdirectory containing its code is included?")
      endif()
      list(APPEND drone_detect_LIBRARIES ${lib})
    endif()
  endif()
endforeach()

set(drone_detect_EXPORTED_TARGETS "")
# create dummy targets for exported code generation targets to make life of users easier
foreach(t ${drone_detect_EXPORTED_TARGETS})
  if(NOT TARGET ${t})
    add_custom_target(${t})
  endif()
endforeach()

set(depends "roscpp;sensor_msgs")
foreach(depend ${depends})
  string(REPLACE " " ";" depend_list ${depend})
  # the package name of the dependency must be kept in a unique variable so that it is not overwritten in recursive calls
  list(GET depend_list 0 drone_detect_dep)
  list(LENGTH depend_list count)
  if(${count} EQUAL 1)
    # simple dependencies must only be find_package()-ed once
    if(NOT ${drone_detect_dep}_FOUND)
      find_package(${drone_detect_dep} REQUIRED NO_MODULE)
    endif()
  else()
    # dependencies with components must be find_package()-ed again
    list(REMOVE_AT depend_list 0)
    find_package(${drone_detect_dep} REQUIRED NO_MODULE ${depend_list})
  endif()
  _list_append_unique(drone_detect_INCLUDE_DIRS ${${drone_detect_dep}_INCLUDE_DIRS})

  # merge build configuration keywords with library names to correctly deduplicate
  _pack_libraries_with_build_configuration(drone_detect_LIBRARIES ${drone_detect_LIBRARIES})
  _pack_libraries_with_build_configuration(_libraries ${${drone_detect_dep}_LIBRARIES})
  _list_append_deduplicate(drone_detect_LIBRARIES ${_libraries})
  # undo build configuration keyword merging after deduplication
  _unpack_libraries_with_build_configuration(drone_detect_LIBRARIES ${drone_detect_LIBRARIES})

  _list_append_unique(drone_detect_LIBRARY_DIRS ${${drone_detect_dep}_LIBRARY_DIRS})
  _list_append_deduplicate(drone_detect_EXPORTED_TARGETS ${${drone_detect_dep}_EXPORTED_TARGETS})
endforeach()

set(pkg_cfg_extras "")
foreach(extra ${pkg_cfg_extras})
  if(NOT IS_ABSOLUTE ${extra})
    set(extra ${drone_detect_DIR}/${extra})
  endif()
  include(${extra})
endforeach()
