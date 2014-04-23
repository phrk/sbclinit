(ql:quickload "bordeaux-threads")

(load "queue.lisp")

(defpackage :utils
	(:export :make-smart-vec :iterate-array :iterate-list :escape-string :with-lock :with-cond-wait :with-kick :notnil :field-setp :field-not-setp)
	(:use :common-lisp))

(in-package :utils)

(defun make-smart-vec ()
	(make-array 1 :fill-pointer 0 :adjustable t))

(defun iterate-array (arr fn)
	(map nil fn arr))

(defun iterate-list (lst fn)
	(apply fn lst))
	
(defun with-lock (lock fn)
	(bordeaux-threads:acquire-lock lock)
	(setf ret (funcall fn))
	(bordeaux-threads:release-lock lock)
	(return-from with-lock ret))

(defun cond-wait (condvar lock check-reached reset-condition)
	(bordeaux-threads:acquire-lock lock)
	(loop do
			(bordeaux-threads:condition-wait condvar lock)
		while (not (funcall check-reached)))
	(funcall reset-condition)
	(bordeaux-threads:release-lock lock))

(defun escape-string(str)
	(let ((qpos (search "\'" str)))
		(if (null qpos)
			str
			(concatenate 'string (escape-string (subseq str 0 qpos))
								(escape-string (subseq str (+ 1 qpos) (length str)))))))

(defun with-kick (cond lock fn)
	(bordeaux-threads:acquire-lock lock)
	(funcall fn)
	(bordeaux-threads:condition-notify cond)
	(bordeaux-threads:release-lock lock))

(defun notnil(field)
	(not (equal nil field)))

(defun field-setp (field)
	(and (notnil field)
		(not (equal "" field))))

(defun field-not-setp (field)
	(not (field-setp field)))

;(setf val nil)

;(setf cond (bordeaux-threads:make-condition-variable))

;(setf lock (bordeaux-threads:make-lock))

;(defun reached()
;	val)

;(defun wait-thread()
;	(with-cond-wait cond lock #'reached #'(lambda () (setf cond (bordeaux-threads:make-condition-variable))))
;	(format t "COND REACHED!!!!!!!"))

;(defun kick()
;	(bordeaux-threads:acquire-lock lock)
;	(setf val t)
;	(bordeaux-threads:condition-notify cond)
;	(format t "Kicked!")
;	(bordeaux-threads:release-lock lock))

;(bordeaux-threads:make-thread #'wait-thread)


