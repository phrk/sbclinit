(load "utils.lisp")

(defpackage :bsview
	(:export :panel-view :render :panel-button :make-panel-button :add-button) 
	(:use :common-lisp))

(in-package :bsview)

(defstruct panel-button
	caption link)

(defclass panel-view()
	((buttons 
		:initarg :buttons
		:initform (utils:make-smart-vec)
		:accessor buttons)
	(caption
		:initarg :caption
		:initform "Project Caption"
		:accessor caption)
	(main-link
		:initarg :main-link
		:initform "#"
		:accessor main-link)))

(defmethod add-button((view panel-view) button)
	(vector-push-extend button (buttons view)))

(defmethod render((view panel-view) req)
	(setf ret (format nil
	"<div class=\"navbar navbar-inverse navbar-fixed-top\" role=\"navigation\"> ~
      <div class=\"container\"> ~
        <div class=\"navbar-header\"> ~
          <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\"> ~
            <span class=\"sr-only\">Toggle navigation</span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
          </button> ~
          <a class=\"navbar-brand\" href=\"~A\">~A</a> ~
        </div> ~
        <div class=\"collapse navbar-collapse\"> ~
          <ul class=\"nav navbar-nav\">" (main-link view) (caption view)))

	(utils:iterate-array (buttons view) #'(lambda (button)
				(setf ret (concatenate 'string ret
				(format nil "<li><a href=\"~A\">~A</a></li>" (panel-button-link button)
															(panel-button-caption button))))))
           ; <li class=\"active\"><a href=\"#\">Home</a></li> ~
           ; <li><a href=\"#about\">About</a></li> ~
           ; <li><a href=\"#contact\">Contact</a></li> ~

	(setf ret (format nil "~A </ul> ~
		</div><!--/.nav-collapse --> ~
		</div> ~
	</div>" ret))
	)
