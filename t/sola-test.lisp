(in-package :cl-user)
(defpackage sola-test
  (:use :cl
        :sola
        :prove))
(in-package :sola-test)

;; NOTE: To run this test file, execute `(asdf:test-system :sola)' in your Lisp.
(setf *enable-colors* nil)
(plan 2)

(subtest "Get all anime list test"
  (ok (sola::get-anime-master)))

(subtest "Title regex get test"
  (let* ((saekano (sola::get-columns '(title) 
		    (sola::get-anime-list :title ".*冴え.*" :update t))))
    (ok (find "冴えない彼女の育てかた" (sola::get-sae) :test #'string= :key #'first))))

(finalize)
