
(load "utils.lisp")
(ql:quickload :drakma)

(defpackage :olead
	(:export :faberlic-test)
	(:use :common-lisp))

(in-package :olead)

(defun fill-order-debug()
	(let ((order (make-hash-table)))
		(setf (gethash "id" order) "300")
		(setf (gethash "sfio" order) "Ivanov Ivan")
		(setf (gethash "email" order) "arturg000@gmail.com")
		(setf (gethash "phone" order) "89645338243")
		(setf (gethash "idtown" order) "111")
		(setf (gethash "comment" order) "blablabla2")
		(return-from fill-order-debug order)))

(defun faberlic-test()
	(let ((reqobj (make-hash-table))
			(orders (make-smart-vec)))
		(setf (gethash "user" reqobj) "test")
		(setf (gethash "password" reqobj) "test")
		(setf (gethash "task" reqobj) "addorders")
		
		(vector-push-extend (fill-order-debug) orders)
		(setf (gethash "orders" reqobj) orders)
		(let ((content (with-output-to-string (str) (yason:encode reqobj str)))
			;(url "http://127.0.0.1:4242/printbody/")
			(url "http://ru.dev.faberlic.ru/api/api.php"))
			(drakma:http-request url :method :post :content content))))
