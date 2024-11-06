
(cl:in-package :asdf)

(defsystem "search_plan-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "SearchService" :depends-on ("_package_SearchService"))
    (:file "_package_SearchService" :depends-on ("_package"))
  ))