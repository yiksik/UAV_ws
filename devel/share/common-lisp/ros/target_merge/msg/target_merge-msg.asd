
(cl:in-package :asdf)

(defsystem "target_merge-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "TargetMerged_Message" :depends-on ("_package_TargetMerged_Message"))
    (:file "_package_TargetMerged_Message" :depends-on ("_package"))
  ))