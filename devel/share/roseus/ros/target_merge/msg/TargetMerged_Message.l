;; Auto-generated. Do not edit!


(when (boundp 'target_merge::TargetMerged_Message)
  (if (not (find-package "TARGET_MERGE"))
    (make-package "TARGET_MERGE"))
  (shadow 'TargetMerged_Message (find-package "TARGET_MERGE")))
(unless (find-package "TARGET_MERGE::TARGETMERGED_MESSAGE")
  (make-package "TARGET_MERGE::TARGETMERGED_MESSAGE"))

(in-package "ROS")
;;//! \htmlinclude TargetMerged_Message.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass target_merge::TargetMerged_Message
  :super ros::object
  :slots (_header _time _id _type _x _y _cov ))

(defmethod target_merge::TargetMerged_Message
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:time __time) 0.0)
    ((:id __id) 0)
    ((:type __type) 0)
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:cov __cov) (make-array 4 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _header __header)
   (setq _time (float __time))
   (setq _id (round __id))
   (setq _type (round __type))
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _cov __cov)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:time
   (&optional __time)
   (if __time (setq _time __time)) _time)
  (:id
   (&optional __id)
   (if __id (setq _id __id)) _id)
  (:type
   (&optional __type)
   (if __type (setq _type __type)) _type)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:cov
   (&optional __cov)
   (if __cov (setq _cov __cov)) _cov)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float64 _time
    8
    ;; uint8 _id
    1
    ;; uint8 _type
    1
    ;; float64 _x
    8
    ;; float64 _y
    8
    ;; float64[4] _cov
    (* 8    4)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float64 _time
       (sys::poke _time (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; uint8 _id
       (write-byte _id s)
     ;; uint8 _type
       (write-byte _type s)
     ;; float64 _x
       (sys::poke _x (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _y
       (sys::poke _y (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64[4] _cov
     (dotimes (i 4)
       (sys::poke (elt _cov i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float64 _time
     (setq _time (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; uint8 _id
     (setq _id (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _type
     (setq _type (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; float64 _x
     (setq _x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _y
     (setq _y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64[4] _cov
   (dotimes (i (length _cov))
     (setf (elt _cov i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;;
   self)
  )

(setf (get target_merge::TargetMerged_Message :md5sum-) "250d30ca0eed93948b788af357245216")
(setf (get target_merge::TargetMerged_Message :datatype-) "target_merge/TargetMerged_Message")
(setf (get target_merge::TargetMerged_Message :definition-)
      "std_msgs/Header header
float64 time
uint8 id
uint8 type
float64 x
float64 y
float64[4] cov
================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :target_merge/TargetMerged_Message "250d30ca0eed93948b788af357245216")


