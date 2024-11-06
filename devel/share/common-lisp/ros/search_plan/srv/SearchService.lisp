; Auto-generated. Do not edit!


(cl:in-package search_plan-srv)


;//! \htmlinclude SearchService-request.msg.html

(cl:defclass <SearchService-request> (roslisp-msg-protocol:ros-message)
  ((req_type
    :reader req_type
    :initarg :req_type
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SearchService-request (<SearchService-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SearchService-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SearchService-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name search_plan-srv:<SearchService-request> is deprecated: use search_plan-srv:SearchService-request instead.")))

(cl:ensure-generic-function 'req_type-val :lambda-list '(m))
(cl:defmethod req_type-val ((m <SearchService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader search_plan-srv:req_type-val is deprecated.  Use search_plan-srv:req_type instead.")
  (req_type m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SearchService-request>) ostream)
  "Serializes a message object of type '<SearchService-request>"
  (cl:let* ((signed (cl:slot-value msg 'req_type)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SearchService-request>) istream)
  "Deserializes a message object of type '<SearchService-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'req_type) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SearchService-request>)))
  "Returns string type for a service object of type '<SearchService-request>"
  "search_plan/SearchServiceRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SearchService-request)))
  "Returns string type for a service object of type 'SearchService-request"
  "search_plan/SearchServiceRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SearchService-request>)))
  "Returns md5sum for a message object of type '<SearchService-request>"
  "755dfbc93987f6abb3e7f3251f87b1d6")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SearchService-request)))
  "Returns md5sum for a message object of type 'SearchService-request"
  "755dfbc93987f6abb3e7f3251f87b1d6")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SearchService-request>)))
  "Returns full string definition for message of type '<SearchService-request>"
  (cl:format cl:nil "int8 req_type #0为恢复正常 1为请求悬停或减速~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SearchService-request)))
  "Returns full string definition for message of type 'SearchService-request"
  (cl:format cl:nil "int8 req_type #0为恢复正常 1为请求悬停或减速~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SearchService-request>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SearchService-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SearchService-request
    (cl:cons ':req_type (req_type msg))
))
;//! \htmlinclude SearchService-response.msg.html

(cl:defclass <SearchService-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass SearchService-response (<SearchService-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SearchService-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SearchService-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name search_plan-srv:<SearchService-response> is deprecated: use search_plan-srv:SearchService-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <SearchService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader search_plan-srv:success-val is deprecated.  Use search_plan-srv:success instead.")
  (success m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SearchService-response>) ostream)
  "Serializes a message object of type '<SearchService-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SearchService-response>) istream)
  "Deserializes a message object of type '<SearchService-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SearchService-response>)))
  "Returns string type for a service object of type '<SearchService-response>"
  "search_plan/SearchServiceResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SearchService-response)))
  "Returns string type for a service object of type 'SearchService-response"
  "search_plan/SearchServiceResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SearchService-response>)))
  "Returns md5sum for a message object of type '<SearchService-response>"
  "755dfbc93987f6abb3e7f3251f87b1d6")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SearchService-response)))
  "Returns md5sum for a message object of type 'SearchService-response"
  "755dfbc93987f6abb3e7f3251f87b1d6")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SearchService-response>)))
  "Returns full string definition for message of type '<SearchService-response>"
  (cl:format cl:nil "bool success~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SearchService-response)))
  "Returns full string definition for message of type 'SearchService-response"
  (cl:format cl:nil "bool success~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SearchService-response>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SearchService-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SearchService-response
    (cl:cons ':success (success msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SearchService)))
  'SearchService-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SearchService)))
  'SearchService-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SearchService)))
  "Returns string type for a service object of type '<SearchService>"
  "search_plan/SearchService")