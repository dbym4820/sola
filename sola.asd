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
	       (:file "sola")))
