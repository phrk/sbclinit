(load "web/addcampview.lisp")
(load "web/campsview.lisp")
(load "web/loginview.lisp")

(defpackage :olead
	(:export :start-olead-face)
	(:use :common-lisp)
)

(in-package :olead)

(defun check-camp-new(campid)
	(format t "check-camp-new campid:~A~%" campid)
	nil)

(defun check-login-pass(login pass)
	;(format t "ON-AUTH: LOGIN: ~A PASS: ~A ~%" login pass)
	(let ((resp (postmodern:query (format nil "SELECT pass FROM sheetapi.users WHERE login = '~A'" login))))
		;(format t "~A~%" (yason:encode (nth 0 (nth 0 resp) ) ) )
		(if (null resp)
			(return-from check-login-pass "Неправильный логин или пароль") )
		(if (not (equal pass (nth 0 (nth 0 resp) ) ))
			(return-from check-login-pass "Неправильный логин или пароль") )

		nil ) )

(defun make-panel ()
	(let ((panelview (make-instance 'bsview:panel-view :caption "olead" )))

	(bsview:add-button panelview (bsview:make-panel-button :caption "Описание"
																:link "/descr/"))
	(bsview:add-button panelview (bsview:make-panel-button :caption "Кампании"
																:link "/camps/"))
	(bsview:add-button panelview (bsview:make-panel-button :caption "Новая кампания"
																:link "/addcamp/"))
	(bsview:add-button panelview (bsview:make-panel-button :caption "Выйти"
																:link "/logout/"))
		panelview))

(defun start-olead-face (lstnr)
	(let ((panelview (make-panel)))
		(listener-add-handler lstnr "/file/" (make-file-listener "/file/" "web/file/"))
		(listener-add-handler lstnr "/login/" (bsview:make-login-page #'check-login-pass))
		(listener-add-handler lstnr "/addcamp/" (make-add-camp-view panelview
																#'check-camp-new (bsview:make-auth #'check-login-pass "/login/" "/addcamp/")
																"/camps/") )

		(listener-add-handler lstnr "/camps/" (make-camps-view panelview #'get-camps (bsview:make-auth #'check-login-pass "/login/" "/camps/") ))
		
		(listener-add-handler lstnr "/logout/" (bsview:make-logout-page "/descr/"))

	))
