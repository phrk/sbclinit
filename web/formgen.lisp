(load "utils.lisp")

(defpackage :bsview
	(:export :form-view :render :field-info :make-field-info :add-field :select-info :make-select-info) 
	(:use :common-lisp))

(in-package :bsview)

(defstruct select-info
	caption value)

(defstruct field-info
	type id caption placeholder required get-selects)

(defclass field ()
	((inputtype
		:accessor inputtype)))

(defclass field-text (field)
	((placeholder
		:initarg :placeholder
		:accessor placeholder)))

(defclass field-select (field)
	(get-selects))

(defclass form-view()
	((fields
		:initarg :fields
		:accessor fields
		:initform (utils:make-smart-vec))
	(success-url
		:initarg :success-url
		:accessor success-url)
	(id
		:initarg :id
		:accessor id)
	(caption
		:initarg :caption
		:accessor caption)
	(submit-caption
		:initarg :submit-caption
		:accessor submit-caption)
	(on-validate
		:initarg :on-validate
		:accessor on-validate)
	(on-filled
		:initarg :on-filled
		:accessor on-filled)
	))

(defmethod add-field ((view form-view) field)
	(vector-push-extend field (fields view)))

(defmethod render ((view form-view) req)
	(progn
		(setf filled (utils:notnil (tbnl:get-parameter "filled")))
		(setf ret "")

		(if (tbnl:get-parameter "success_path")

			(setf ret (format nil "<div class=\"container\" style=\"margin: 40px;\"> ~% ~
						<div class=\"row\"><h2>~A</h2></div>~% ~
						<form role=\"form\" action=\"?filled=1&success_path=~A\" method=\"post\" id=\"~A\" name=\"~A\">~%" (caption view)
																		(tbnl:get-parameter "success_path") (id view) (id view)))
			(if (success-url view)

				(setf ret (format nil "<div class=\"container\" style=\"margin: 40px;\"> ~% ~
						<div class=\"row\"><h2>~A</h2></div>~% ~
						<form role=\"form\" action=\"?filled=1&success_path=~A\" method=\"post\" id=\"~A\" name=\"~A\">~%" (caption view)
																		(success-url view) (id view) (id view)))

				(setf ret (format nil "<div class=\"container\" style=\"margin: 40px;\"> ~% ~
							<div class=\"row\"><h2>~A</h2></div>~% ~
							<form role=\"form\" action=\"?filled=1\" method=\"post\" id=\"~A\" name=\"~A\">~%" (caption view) (id view) (id view))) ) )
		
		(setf fillerror nil)
		(setf validate-error-msg "")
		(setf params (make-hash-table :test #'equal))
		(utils:iterate-array (fields view)
						#'(lambda (field)
								(if (equal (field-info-type field) "text")
									(progn
										(if filled
											(if (utils:field-not-setp (tbnl:post-parameter (field-info-id field)))
												; param set
												(progn
													(setf ret (concatenate 'string ret
														(format nil
														"<div class=\"form-group\">~% ~
															<label for=\"~A\" class=\"col-md-10\">~% ~
																~A <font color=red><b>(Обязательный параметр)</b></font>:~% ~
															</label>~% ~
															<div class=\"col-md-10\">~% ~
																<input type=\"text\" class=\"form-control\" id=\"~A\" name=\"~A\" placeholder=\"~A\">~% ~
															</div>~% ~
														</div>~%" (field-info-id field)
																(field-info-caption field)
																(field-info-id field)
																(field-info-id field)
																(field-info-placeholder field) )))
													(setf fillerror t))
												; param not set
													(progn
														(setf (gethash (field-info-id field) params) (tbnl:post-parameter (field-info-id field)))
														(setf ret (concatenate 'string ret
															(format nil
															"<div class=\"form-group\">~% ~
																<label for=\"~A\" class=\"col-md-10\">~% ~
																	~A :~% ~
																</label>~% ~
																<div class=\"col-md-10\">~% ~
																	<input type=\"text\" class=\"form-control\" id=\"~A\" name=\"~A\" placeholder=\"~A\" value=\"~A\">~% ~
																</div>~% ~
															</div>~%" (field-info-id field)
																	(field-info-caption field)
																	(field-info-id field)
																	(field-info-id field)
																	(field-info-placeholder field)
																	(tbnl:post-parameter (field-info-id field)))))))


												; else 
												(setf ret (concatenate 'string ret
													(format nil
													"<div class=\"form-group\">~% ~
														<label for=\"~A\" class=\"col-md-10\">~% ~
															~A:~% ~
														</label>~% ~
														<div class=\"col-md-10\">~% ~
															<input type=\"text\" class=\"form-control\" id=\"~A\" name=\"~A\" placeholder=\"~A\">~% ~
														</div>~% ~
													</div>~%" (field-info-id field)
															(field-info-caption field)
															(field-info-id field)
															(field-info-id field)
															(field-info-placeholder field) )))

											)))
								
								(if (equal (field-info-type field) "select")
									(if filled
										(progn 
											(setf ret (format nil "~A ~
													<div class=\"form-group\">~% ~
														<label for=\"~A\" class=\"col-md-4\">~% ~
															~A~% ~
														</label>~% ~
														<div class=\"col-md-10\">~% ~
															<select class=\"form-control\" name=\"~A\" id=\"~A\" form=\"~A\" required>~%"
															ret (field-info-id field)
																(field-info-caption field)
																(field-info-id field)
																(field-info-id field)
																(id view) ))
											
										(setf (gethash (field-info-id field) params) (tbnl:post-parameter (field-info-id field)))

										(utils:iterate-array (funcall (field-info-get-selects field)) 
																#'(lambda (sel)
																		(if (equal (select-info-value sel) (tbnl:post-parameter (field-info-id field)))
																			(setf ret (format nil "~A<option value=\"~A\" selected>~A</option>~%"
																									ret
																									(select-info-value sel)
																									(select-info-caption sel)
																									 ) )
																			(setf ret (format nil "~A<option value=\"~A\">~A</option>~%"
																									ret
																									(select-info-value sel)
																									(select-info-caption sel)
																									 ) ))))

										(setf ret (format nil "~A</select></div></div>~%" ret)))
										; if not filled
										(progn 
											(setf ret (format nil "~A ~
													<div class=\"form-group\">~% ~
														<label for=\"~A\" class=\"col-md-4\">~% ~
															~A~% ~
														</label>~% ~
														<div class=\"col-md-10\">~% ~
															<select class=\"form-control\" name=\"~A\" id=\"~A\" form=\"~A\" required>~%"
															ret (field-info-id field)
																(field-info-caption field)
																(field-info-id field)
																(field-info-id field)
																(id view) ))

										(utils:iterate-array (funcall (field-info-get-selects field)) 
																#'(lambda (sel)
																		(setf ret (format nil "~A<option value=\"~A\">~A</option>~%"
																								ret
																								(select-info-value sel)
																								(select-info-caption sel)
																								 ) )))

										(setf ret (format nil "~A</select></div></div>~%" ret)))
									))
								))
		(if (and filled
				(null fillerror))
			(let ((validate-res (funcall (on-validate view) params) ))
				(if (not (null validate-res)) 
					(setf validate-error-msg validate-res)
					(if (tbnl:get-parameter "success_path")
						(setf validate-error-msg (funcall (on-filled view) params (tbnl:get-parameter "success_path") ) ) 
						(if (success-url view)
							(setf validate-error-msg (funcall (on-filled view) params (success-url view) ) )
							(setf validate-error-msg (funcall (on-filled view) params "/" ) ) )
						 ) ) ) )
		
		(format nil "~A <div class=\"row\">~% ~
					<div class=\"col-md-2\">~% ~
					</div>~% ~
						<div class=\"col-md-10\">~% ~
							<button type=\"submit\" class=\"btn btn-info\" id=\"register\">~% ~
							~A~% ~
							</button>~% ~
						</div>~% ~
					</div>~% ~
					</form>~% ~
					~A~% ~
					</div></div>~%" ret (submit-caption view) validate-error-msg)
	))
