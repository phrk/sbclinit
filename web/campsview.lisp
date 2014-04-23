(load "web/pageview.lisp")
(load "web/formgen.lisp")
(load "web/panelview.lisp")

(defpackage :olead
	(:export :make-camps-view)
)

(in-package :olead)

(defun render-camp (camp)
	(let ((ret ""))
		(mapcar #'(lambda (field) (setf ret (format nil "~A<td>~A</td>" ret field) ) ) camp) 
	ret) )

(defun render-camps-table (get-camps)
	(let ((ret "<br><br><br><center><table border=1 width=90%> ~
				<tr> ~
				<td><b>ID в hasoffers</b></td> ~
				<td><b>hasoffers url</b></td> ~
				<td><b>Название кампании</b></td> ~
				<td><b>Рекламодатель </b></td> ~
				<td><b>Дата создания </b></td> ~
				<td><b>API userid </b></td> ~
				<td><b>API ключ </b></td> ~
				<td><b>Конверсии </b></td> ~
				</tr>") )

		(map nil #'(lambda (camp) (setf ret (format nil "~A<tr>~A</tr>" ret (render-camp camp) ) ) ) (funcall get-camps shtapi) )

		(setf ret (format nil "~A </table></center>" ret) )
		ret ) )

(defun make-camps-view (panelview get-camps auth)
		(let ((pageview (make-instance 'bsview:page-view :bs-css-url "/file/css/bootstrap.min.css"
															:bs-js-url	"/file/js/bootstrap.min.js"
															:title "Кампании"
															:gen-content #'(lambda (req)
																			(concatenate 'string (bsview:render panelview req)  (render-camps-table get-camps) ) ))))

				#'(lambda (req) 
					(funcall auth)
					(bsview:render pageview req)))
		)
