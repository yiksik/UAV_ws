;; Auto-generated. Do not edit!


(when (boundp 'search_plan::SearchService)
  (if (not (find-package "SEARCH_PLAN"))
    (make-package "SEARCH_PLAN"))
  (shadow 'SearchService (find-package "SEARCH_PLAN")))
(unless (find-package "SEARCH_PLAN::SEARCHSERVICE")
  (make-package "SEARCH_PLAN::SEARCHSERVICE"))
(unless (find-package "SEARCH_PLAN::SEARCHSERVICEREQUEST")
  (make-package "SEARCH_PLAN::SEARCHSERVICEREQUEST"))
(unless (find-package "SEARCH_PLAN::SEARCHSERVICERESPONSE")
  (make-package "SEARCH_PLAN::SEARCHSERVICERESPONSE"))

(in-package "ROS")





(defclass search_plan::SearchServiceRequest
  :super ros::object
  :slots (_req_type ))

(defmethod search_plan::SearchServiceRequest
  (:init
   (&key
    ((:req_type __req_type) 0)
    )
   (send-super :init)
   (setq _req_type (round __req_type))
   self)
  (:req_type
   (&optional __req_type)
   (if __req_type (setq _req_type __req_type)) _req_type)
  (:serialization-length
   ()
   (+
    ;; int8 _req_type
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int8 _req_type
       (write-byte _req_type s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int8 _req_type
     (setq _req_type (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _req_type 127) (setq _req_type (- _req_type 256)))
   ;;
   self)
  )

(defclass search_plan::SearchServiceResponse
  :super ros::object
  :slots (_success ))

(defmethod search_plan::SearchServiceResponse
  (:init
   (&key
    ((:success __success) nil)
    )
   (send-super :init)
   (setq _success __success)
   self)
  (:success
   (&optional (__success :null))
   (if (not (eq __success :null)) (setq _success __success)) _success)
  (:serialization-length
   ()
   (+
    ;; bool _success
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass search_plan::SearchService
  :super ros::object
  :slots ())

(setf (get search_plan::SearchService :md5sum-) "755dfbc93987f6abb3e7f3251f87b1d6")
(setf (get search_plan::SearchService :datatype-) "search_plan/SearchService")
(setf (get search_plan::SearchService :request) search_plan::SearchServiceRequest)
(setf (get search_plan::SearchService :response) search_plan::SearchServiceResponse)

(defmethod search_plan::SearchServiceRequest
  (:response () (instance search_plan::SearchServiceResponse :init)))

(setf (get search_plan::SearchServiceRequest :md5sum-) "755dfbc93987f6abb3e7f3251f87b1d6")
(setf (get search_plan::SearchServiceRequest :datatype-) "search_plan/SearchServiceRequest")
(setf (get search_plan::SearchServiceRequest :definition-)
      "int8 req_type #0为恢复正常 1为请求悬停或减速
---
bool success
")

(setf (get search_plan::SearchServiceResponse :md5sum-) "755dfbc93987f6abb3e7f3251f87b1d6")
(setf (get search_plan::SearchServiceResponse :datatype-) "search_plan/SearchServiceResponse")
(setf (get search_plan::SearchServiceResponse :definition-)
      "int8 req_type #0为恢复正常 1为请求悬停或减速
---
bool success
")



(provide :search_plan/SearchService "755dfbc93987f6abb3e7f3251f87b1d6")


