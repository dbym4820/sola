(in-package :cl-user)
(defpackage sola
  (:use :cl)
  (:import-from :alexandria
		:make-keyword
		:read-file-into-string)
  (:import-from :uiop
		:file-exists-p
	        :directory-exists-p
		:delete-file-if-exists)
  (:import-from :local-time
		:timestamp-year
		:now)
  (:import-from :cl-ppcre
                :parse-string
   		:scan-to-strings)
  (:import-from :jonathan
		:parse)
  (:import-from :cl-ignition
		:with-prefix
		:get-single-key
		:request-dbpedia
		:convert-query)
  (:export :make-request-url
           :set-sola-endpoint
	   :get-anime-master
	   :get-anime-list
	   :get-single-column
	   :get-columns
	   :with-prefix
           :get-single-key
	   :request-dbpedia
           :convert-query))
(in-package :sola)

;;; Basic configuration
(defparameter *sola-endpoint* "http://api.moemoe.tokyo/anime/v1/master/")

(defun set-sola-endpoint (endpoint-url)
  (setf *sola-endpoint* endpoint-url))

(defparameter *latest-master* nil)

(defun already-master-p ()
  (when *latest-master* t))

;;; Web API
(defun make-request-url (&rest opt)
  (format nil "~A~{~A/~}~A" *sola-endpoint*
          (reverse (cdr (reverse opt)))
          (car (reverse opt))))

;;; List operator
(defun compose-even-items (lst)
  (cond ((evenp (length lst))
	 (pairlis
	  (loop for data in lst
		for number from 0 
		when (evenp number)
		  collect data)
	  (loop for data in lst
		for number from 0 
		when (oddp number)
		  collect data)))))

(defun json-to-alist (json-string)
  (cond ((string= json-string "[]") nil)
	(t
	 (mapcar #'compose-even-items (parse json-string)))))

#|
Main part of SOLA(Shangrila Anime API)
|#
(defun get-anime-master ()
  (labels ((make-year-list (year &optional y-list)
	     (cond ((< year 2014) y-list)
		   (t (make-year-list (1- year) (append y-list `(,year)))))))
    (reduce #'append
	    (remove-if #'null
		       (mapcar #'(lambda (year-cours)
				   (json-to-alist
				    (dex:get (make-request-url (princ-to-string (first year-cours)) (princ-to-string (second year-cours))))))
			       (reduce #'append
				       (mapcar #'(lambda (y)
						   (mapcar #'(lambda (c)
							       (list y c))
							   '(1 2 3 4)))
					       (reverse (make-year-list (timestamp-year (now)))))))))))

			       
(defun get-anime-data (&key update)
  (progn
    (when (or (not (already-master-p)) update)
      (setf *latest-master* (get-anime-master)))
    *latest-master*))
      
(defmacro with-anime-api ((var &key update) &body body)
  `(let ((,var (get-anime-data :update ,update)))
     ,@body))

(defun get-anime-list (key item &key update)
  (let ((key-sym (make-keyword (string-downcase (princ-to-string key)))))
    (with-anime-api (anime-master :update update)
      (remove-if #'null
		 (mapcar #'(lambda (single-anime)
			     (cond ((stringp (cdr (assoc key-sym single-anime)))
				    (when (scan-to-strings (princ-to-string item) (cdr (assoc key-sym single-anime)))
				      single-anime))
				   ((integerp (cdr (assoc key-sym single-anime)))
				    (when (eql (cdr (assoc key-sym single-anime)) item)
				      single-anime))
				   (t nil)))
			 anime-master)))))

(defun get-single-column (key anime-info-list)
  (let ((key-sym (make-keyword (string-downcase (princ-to-string key)))))
    (mapcar #'(lambda (d)
		(cdr (assoc key-sym d)))
	    anime-info-list)))

(defun get-columns (option-key-list anime-info-list)
  (let ((key-sym-list
	  (mapcar #'(lambda (opt-key-list)
		      (make-keyword (string-downcase (princ-to-string opt-key-list))))
		  option-key-list)))
    (loop for single-anime in anime-info-list
	  collect (loop for opt-key in key-sym-list
			collect (cdr (assoc opt-key single-anime))))))
