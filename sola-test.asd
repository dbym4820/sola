(in-package :cl-user)
(defpackage sola-test-asd
  (:use :cl :asdf))
(in-package :sola-test-asd)

(defsystem sola-test
  :author "TomokiAburatani"
  :license "MIT License"
  :depends-on (:sola
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "sola-test"))))
  :description "Test system for sola"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
