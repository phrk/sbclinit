(load "web/formgen.lisp")
(load "web/pageview.lisp")

(defpackage :bsview
	(:export :make-login-page :auth :make-auth :logout :make-logout-page))

(in-package :bsview)

(defun auth (check-login-pass login-page-path success-page-path)
	;(tbnl:start-session)
	;	(format t "SESSION USER: ~A~%" (tbnl:session-value :userid))
	(if (tbnl:session-value :userid) 
		(return-from auth t))

		(tbnl:redirect (concatenate 'string login-page-path (format nil "?success_path=~A" success-page-path) ) )
	)

(defun make-auth (check-login-pass login-page-path success-page-path)
	#'(lambda ()
		(auth check-login-pass login-page-path success-page-path) ) )

(defun logout ()
	(setf (tbnl:session-value :userid)  nil) )

(defun on-filled-login(params successpath)
	;(format t "ON-FILLED-LOGIN: ~A ~%" (yason:encode params))
	;(let ((successpath (gethash "success_path" params)))
		(setf (tbnl:session-value :userid) (gethash "userid" params) )
		(if successpath
			(tbnl:redirect successpath)
				(tbnl:redirect "/"))
		"Добро пожаловать") 

(defun make-logout-page (redirect-path)
	#'(lambda (req)
		(logout)
		(tbnl:redirect redirect-path) ) )

(defun make-login-page (check-login-pass)

		(let ((formview (make-instance 'bsview:form-view :id "loginform" 
													:caption "Пожалуйста, войдите"
													:submit-caption "Войти"
													:on-validate #'(lambda (params) (funcall check-login-pass (gethash "userid" params) (gethash "pass" params) ))
													:on-filled #'on-filled-login )))
		
		(bsview:add-field formview (bsview:make-field-info :id "userid"
															:type "text"
															:caption "Логин"
															:required t
															:placeholder "Введите логин"))

		(bsview:add-field formview (bsview:make-field-info :id "pass"
															:type "text"
															:caption "Пароль"
															:required t
															:placeholder "Введите пароль"))

			(let ((pageview (make-instance 'bsview:page-view :bs-css-url "/file/css/bootstrap.min.css"
																:bs-js-url	"/file/js/bootstrap.min.js"
																:title "Логин"
																:gen-content #'(lambda (req)
																				(bsview:render formview req) ))))

					#'(lambda (req)  (bsview:render pageview req)))
			) )
