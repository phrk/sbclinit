
(load "utils.lisp")

(defpackage :bsview
	(:export :page-view :render) 
	(:use :common-lisp))

(in-package :bsview)

(defclass page-view ()
	((bs-css-url
		:initarg :bs-css-url
		:accessor bs-css-url)
	(bs-js-url
		:initarg :bs-js-url
		:accessor bs-js-url)
	(title
		:initarg :title
		:accessor title)
	(gen-content
		:initarg :gen-content
		:accessor gen-content)))

(defmethod render ((view page-view) req)
	(format nil "<!DOCTYPE html> ~
		<html lang=\"en\"> ~
		  <head> ~
		    <meta charset=\"utf-8\"> ~
		    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> ~
		    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> ~
		    <meta name=\"description\" content=\"\"> ~
		    <meta name=\"author\" content=\"\"> ~
		    <link rel=\"shortcut icon\" href=\"../../assets/ico/favicon.ico\"> ~
		 ~
		    <title>~A</title> ~
		 ~
		    <!-- Bootstrap core CSS --> ~
		    <link href=\"~A\" rel=\"stylesheet\"> ~
		 ~
		    <!-- Custom styles for this template --> ~
		    <link href=\"jumbotron.css\" rel=\"stylesheet\"> ~
		 ~
		    <!--[if lt IE 9]> ~
		      <script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script> ~
		      <script src=\"https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js\"></script> ~
		    <![endif]--> ~
		  </head> ~
		 <body> ~
		~A ~
		 <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js\"></script> ~
		 <script src=\"~A\"></script> ~
		</body> ~
		</html>" (title view) (bs-css-url view) (funcall (gen-content view) req) (bs-js-url view) ))
