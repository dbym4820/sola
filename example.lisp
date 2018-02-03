;;; 全アニメデータの取得
(defun all ()
  (sola:get-anime-master))



;;; 女性向けアニメ一覧
(defun female-anime ()
  (mapcar #'first
	  (remove-if #'(lambda (d)
			 (when (= 0 (second d)) t))
		     (sola:get-columns '(title sex) (sola:get-anime-master)))))

;;; 男性向けアニメ一覧
(defun male-anime ()
  (mapcar #'first
	  (remove-if #'(lambda (d)
			 (when (= 1 (second d)) t))
		     (sola:get-columns '(title sex) (sola:get-anime-master)))))

;;; タイトルに「ドラ」が入るアニメのタイトル一覧を表示
(defun get-dola ()
  (sola:get-columns '(title) 
		    (sola:get-anime-list :title ".*ドラ.*" :update t)))

(defun get-sae ()
  (sola:get-columns '(title) 
		    (sola:get-anime-list :title ".*冴え.*" :update t)))


