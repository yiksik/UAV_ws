## *********************************************************
##
## File autogenerated for the geometric_controller package
## by the dynamic_reconfigure package.
## Please do not edit.
##
## ********************************************************/

from dynamic_reconfigure.encoding import extract_params

inf = float('inf')

config_description = {'name': 'Default', 'type': '', 'state': True, 'cstate': 'true', 'id': 0, 'parent': 0, 'parameters': [{'name': 'max_acc', 'type': 'double', 'default': 7.0, 'level': 0, 'description': 'Max Feedback Acceleration', 'min': 1.0, 'max': 8.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kp_x', 'type': 'double', 'default': 8.0, 'level': 0, 'description': 'Proportional gain for X position error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kp_y', 'type': 'double', 'default': 8.0, 'level': 0, 'description': 'Proportional gain for Y position error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kp_z', 'type': 'double', 'default': 10.0, 'level': 0, 'description': 'Proportional gain for Z position error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kv_x', 'type': 'double', 'default': 1.5, 'level': 0, 'description': 'Proportional gain for X velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kv_y', 'type': 'double', 'default': 1.5, 'level': 0, 'description': 'Proportional gain for Y velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Kv_z', 'type': 'double', 'default': 3.3, 'level': 0, 'description': 'Proportional gain for Z velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Karuco_angle', 'type': 'double', 'default': 1.5, 'level': 0, 'description': 'Proportional gain for aruco_angle velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Karuco_velx', 'type': 'double', 'default': 1.5, 'level': 0, 'description': 'Proportional gain for aruco X velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'Karuco_vely', 'type': 'double', 'default': 1.5, 'level': 0, 'description': 'Proportional gain for aruco Y velocity error', 'min': 0.1, 'max': 20.0, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}, {'name': 'normalizedthrust_offset', 'type': 'double', 'default': 0.1, 'level': 0, 'description': 'Proportional gain for Z velocity error', 'min': -0.5, 'max': 0.5, 'srcline': 291, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'edit_method': '', 'ctype': 'double', 'cconsttype': 'const double'}], 'groups': [], 'srcline': 246, 'srcfile': '/opt/ros/noetic/lib/python3/dist-packages/dynamic_reconfigure/parameter_generator_catkin.py', 'class': 'DEFAULT', 'parentclass': '', 'parentname': 'Default', 'field': 'default', 'upper': 'DEFAULT', 'lower': 'groups'}

min = {}
max = {}
defaults = {}
level = {}
type = {}
all_level = 0

#def extract_params(config):
#    params = []
#    params.extend(config['parameters'])
#    for group in config['groups']:
#        params.extend(extract_params(group))
#    return params

for param in extract_params(config_description):
    min[param['name']] = param['min']
    max[param['name']] = param['max']
    defaults[param['name']] = param['default']
    level[param['name']] = param['level']
    type[param['name']] = param['type']
    all_level = all_level | param['level']
