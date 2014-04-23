(load "web/pageview.lisp")
(load "web/formgen.lisp")
(load "web/panelview.lisp")

(defpackage :olead
	(:export :make-on-index)
)

(in-package :olead)

(defun on-add-camp-validate(params check-camp-new)
	(maphash #'(lambda (key value)
					(format t "~A : ~A ~%" key value)) params)

	(funcall check-camp-new (gethash "camp_eid" params)))

(defun on-add-camp-filled(params successpath)
	(format t "on-add-camp-filled")
	(add-camp shtapi params)
	(if successpath
			(tbnl:redirect successpath)
				(tbnl:redirect "/")))

(defun make-add-camp-view(panelview check-camp-new auth default-success-path)

	(let ((formview (make-instance 'bsview:form-view :id "addcamp" 
													:caption "Новая кампания"
													:submit-caption "Добавить кампанию"
													:on-validate #'(lambda (params) (on-add-camp-validate params check-camp-new))
													:on-filled #'on-add-camp-filled
													:success-url default-success-path )))
		
		(bsview:add-field formview (bsview:make-field-info :id "name"
															:type "text"
															:caption "Название"
															:required t
															:placeholder "Введите название кампании"))

		(bsview:add-field formview (bsview:make-field-info :id "camp_eid"
															:type "text"
															:caption "ID кампании в hasoffers"
															:required t
															:placeholder "Введите ID кампании в hasoffers"))


		(bsview:add-field formview (bsview:make-field-info :id "hasoffers_url"
															:type "text"
															:caption "Введите url hassoffers"
															:required t
															:placeholder "Введите url hassoffers"))

		(bsview:add-field formview (bsview:make-field-info :id "advertiser_iid"
															:type "select"
															:caption "Выберите получателя анкет"
															:placeholder "Введите bank"
															:get-selects #'(lambda () 
																(setf ret (utils:make-smart-vec))
																(vector-push-extend (bsview:make-select-info :caption "Уббр Банк" :value "ubbr") ret)
																;(vector-push-extend (bsview:make-select-info :caption "Фаберлик" :value "faberlic") ret)
																ret)))

		(bsview:add-field formview (bsview:make-field-info :id "api_userid"
															:type "text"
															:caption "Введите API userid"
															:required t
															:placeholder "Введите ваш userid у API получателя"))


		(bsview:add-field formview (bsview:make-field-info :id "api_key"
															:type "text"
															:caption "Введите ключ API"
															:required t
															:placeholder "Секретный ключ API получателя"))

		

		(let ((pageview (make-instance 'bsview:page-view :bs-css-url "/file/css/bootstrap.min.css"
														:bs-js-url	"/file/js/bootstrap.min.js"
														:title "TEST FORM"
														:gen-content #'(lambda (req)
																		(concatenate 'string (bsview:render panelview req) (bsview:render formview req)) ))))

			#'(lambda (req) 
				(funcall auth)
				(bsview:render pageview req)))))
