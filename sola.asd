(in-package :cl-user)
(defpackage sola-asd
  (:use :cl :asdf))
(in-package :sola-asd)

(defsystem sola
  :description "Common Lisp API for Shanglira"
  :version "0.1.1"
  :author "Tomoki Aburatani"
  :license "MIT License"
  :depends-on ("alexandria"
	       "uiop"
	       "cl-ppcre"
	       "dexador"
	       "jonathan")
  :serial t
  :components ((:static-file "README.md")
	       (:static-file "LICENSE")
	       (:module "src"
		:components
		((:file "sola"))))
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op sola-test))))

