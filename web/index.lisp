(load "web/pageview.lisp")
(load "web/formgen.lisp")
(load "web/panelview.lisp")

(defpackage :olead
	(:export :make-on-index)
)

(in-package :olead)

(defstruct panel-button
	caption
	link)

(defun make-panel-page-gener(buttons-vec content basement title)
	#'(lambda ()
		"PANEL-GENER"))

;;;;;;;;;;;;;;;;;

(defun make-test-view()

	(let ((formview (make-instance 'bsview:form-view :id "reg" 
													:caption "Регистрация"
													:submit-caption "Зарегистрироваться"
													:on-filled #'(lambda () "filled") ))
			(panelview (make-instance 'bsview:panel-view :caption "Olead" )))
		
		(bsview:add-button panelview (bsview:make-panel-button :caption "Описание"
																:link "/descr/"))
		(bsview:add-button panelview (bsview:make-panel-button :caption "Тарифы"
																:link "/plans/"))

		(bsview:add-field formview (bsview:make-field-info :id "name"
															:type "text"
															:caption "Имя"
															:placeholder "Введите Имя"))

		(bsview:add-field formview (bsview:make-field-info :id "lastname"
															:type "text"
															:caption "Фамилия"
															:placeholder "Введите фамилию"))

		(bsview:add-field formview (bsview:make-field-info :id "email"
															:type "text"
															:caption "Email"
															:placeholder "Введите email"))

		(bsview:add-field formview (bsview:make-field-info :id "banks"
															:type "select"
															:caption "Выберите получателя"
															:placeholder "Введите bank"
															:get-selects #'(lambda () 
																(setf ret (utils:make-smart-vec))
																(vector-push-extend (bsview:make-select-info :caption "Убббр Банк" :value "ubbr") ret)
																(vector-push-extend (bsview:make-select-info :caption "Фаберлик" :value "faberlic") ret)
																ret)))

		(let ((pageview (make-instance 'bsview:page-view :bs-css-url "/file/css/bootstrap.min.css"
														:bs-js-url	"/file/js/bootstrap.min.js"
														:title "TEST FORM"
														:gen-content #'(lambda (req)
																		(bsview:render formview req)))))

			#'(lambda (req) (format nil "~A~A" (bsview:render pageview req)
												(bsview:render panelview req))))))


(defun gen-test-page(req)
	(format nil " TEST PAGE \"123\" ~
	~
	asd "))

(defun make-gen-register-page(params bootstrapcss-url bootstrapjs-url)
#'(lambda (req)
	(let ((params (make-hash-table)))
	(if (null (gethash "title" params))
		(setf (gethash "title" params) "Registration" ))
	
	
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
    <title>olead API test</title> ~
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
 ~
  <body> ~
 ~
    <div class=\"navbar navbar-inverse navbar-fixed-top\" role=\"navigation\"> ~
      <div class=\"container\"> ~
        <div class=\"navbar-header\"> ~
          <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\"> ~
            <span class=\"sr-only\">Toggle navigation</span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
          </button> ~
           ~
		  <a class=\"navbar-brand\" href=\"register.php\">Olead test</a> ~
        </div> ~
      </div> ~
    </div> ~
	 ~
 ~
	<div class=\"container\" style=\"margin: 40px;\"> ~
	      <div class=\"row\"><h2>~A</h2> ~
	  </div> ~
 ~
	  <form role=\"form\" action=\"olead_test.php?filled=1\" method=\"post\"> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"partnerid\" class=\"col-md-2\"> ~
	        partnerid: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
			  <input type=\"text\" class=\"form-control\" id=\"partnerid\" name=\"partnerid\" placeholder=\"Введите partnerid\"> ~
			</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"compid\" class=\"col-md-2\"> ~
	        campid: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
			  <input type=\"text\" class=\"form-control\" id=\"campid\" name=\"campid\" placeholder=\"Введите campid\"> ~
			</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"firstname\" class=\"col-md-2\"> ~
	        Имя: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
 ~
		<input type=\"text\" class=\"form-control\" id=\"firstname\" name=\"firstname\" placeholder=\"Введите имя\"> ~
		</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"lastname\" class=\"col-md-2\"> ~
	        Фамилия: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
 ~
		<input type=\"text\" class=\"form-control\" id=\"lastname\" name=\"lastname\" placeholder=\"Введите фамилию\"> ~
 ~
		</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"company\" class=\"col-md-2\"> ~
	        Город: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
 ~
 			<input type=\"text\" class=\"form-control\" id=\"city\" name=\"city\" placeholder=\"Введите город\"> ~
 ~
	 		</div> ~
	    </div> ~
 ~
		<div class=\"form-group\"> ~
	      <label for=\"emailaddress\" class=\"col-md-2\"> ~
	        Email: ~
	      </label> ~
		  	<div class=\"col-md-10\"> ~
 ~
	 		<input type=\"email\" class=\"form-control\" id=\"emailaddress\" name=\"emailaddress\" placeholder=\"Введите email адрес\"> ~
	  	 		<p class=\"help-block\"> ~
					Например: yourname@domain.com ~
		  		</p> ~
			</div> ~
	    </div> ~
 ~
		<div class=\"form-group\"> ~
	      <label for=\"tel\" class=\"col-md-2\"> ~
	        Телефон: ~
	      </label> ~
			<div class=\"col-md-10\"> ~
			<input type=\"text\" class=\"form-control\" id=\"tel\" name=\"tel\" placeholder=\"Введите телефон\"> ~
			</div> ~
	    </div> ~
 ~
	  <div class=\"row\"> ~
	      <div class=\"col-md-2\"> ~
	      </div> ~
	      <div class=\"col-md-10\"> ~
	        <button type=\"submit\" class=\"btn btn-info\" id=\"register\"> ~
				Зарегистрироваться ~
	        </button> ~
	      </div> ~
	    </div> ~
	  </form> ~
	  </div> ~
	 ~
    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js\"></script> ~
    <script src=\"~A\"></script> ~
  </body> ~
</html>" bootstrapcss-url "TITLE" bootstrapjs-url))))



(defun make-gen-add-comp-page(params bootstrapcss-url bootstrapjs-url)
#'(lambda (req)
	(let ((params (make-hash-table)))
	(if (null (gethash "title" params))
		(setf (gethash "title" params) "Registration" ))


(setf status "")

(let ((senderid (tbnl:get-parameter "sender_id"))
			(campid (tbnl:get-parameter "campid")))
	(if (and
			(not (equal nil senderid))
			(not (equal nil campid)))
		(progn 
			(postmodern:query (format nil "INSERT INTO sheetapi.camps(camp_eid, senderid) VALUES (~A, ~A)" campid senderid))
			(setf status (concatenate 'string status (format nil "Кампиния добавлена ID: ~A API_ID: ~A" campid senderid))))))

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
    <title>olead API test</title> ~
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
 ~
  <body> ~
 ~
    <div class=\"navbar navbar-inverse navbar-fixed-top\" role=\"navigation\"> ~
      <div class=\"container\"> ~
        <div class=\"navbar-header\"> ~
          <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\"> ~
            <span class=\"sr-only\">Toggle navigation</span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
          </button> ~
           ~
		  <a class=\"navbar-brand\" href=\"register.php\">Olead test</a> ~
        </div> ~
      </div> ~
    </div> ~
	 ~
 ~
	<div class=\"container\" style=\"margin: 40px;\"> ~
	      <div class=\"row\"><h2>~A</h2> ~
	  </div> ~
 ~
	  <form role=\"form\" action=\"?filled=1\" method=\"get\"> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"senderid\" class=\"col-md-2\"> ~
	        ID api рекламодателя: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
			  <input type=\"text\" class=\"form-control\" id=\"senderid\" name=\"sender_id\" placeholder=\"Введите sender_id\"> ~
			</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"campid\" class=\"col-md-2\"> ~
	        ID оффера в hasoffers: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
			  <input type=\"text\" class=\"form-control\" id=\"campid\" name=\"campid\" placeholder=\"Введите id кампании\"> ~
			</div> ~
	    </div> ~
 ~
	    <div class=\"form-group\"> ~
	      <label for=\"firstname\" class=\"col-md-2\"> ~
	        Описание: ~
	      </label> ~
	      <div class=\"col-md-10\"> ~
 ~
		<input type=\"text\" class=\"form-control\" id=\"descr\" name=\"descr\" placeholder=\"Введите описание\"> ~
		</div> ~
	    </div> ~
 ~
	  <div class=\"row\"> ~
	      <div class=\"col-md-2\"> ~
	      </div> ~
	      <div class=\"col-md-10\"> ~
	        <button type=\"submit\" class=\"btn btn-info\" id=\"register\"> ~
				Добавить кампанию ~
	        </button> ~
	      </div> ~
	    </div> ~
	  </form> ~
	  </div> ~
	 ~
    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js\"></script> ~
    <script src=\"~A\"></script> ~
  </body> ~
 <br><b>~A</b> ~
</html>" bootstrapcss-url "Добавить кампанию" bootstrapjs-url status))))


(defun make-list-comps-page(params bootstrapcss-url bootstrapjs-url)
#'(lambda (req)
	(let ((params (make-hash-table)))
	(if (null (gethash "title" params))
		(setf (gethash "title" params) "Registration" ))


(setf resp (postmodern:query (format nil "SELECT * FROM sheetapi.camps")))

(setf campsblock "<table border=1><tr><td> ID Кампании </td><td>ID API Рекламодателя</td></tr>")

(mapcar #'(lambda (line) 
			(setf campsblock (concatenate 'string campsblock (format nil "<tr><td>~A </td> <td>~A </td></tr>" (first line) (second line) ))))
		resp)

(setf campsblock (concatenate 'string campsblock "</table>"))

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
    <title>olead API test</title> ~
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
 ~
  <body> ~
 ~
    <div class=\"navbar navbar-inverse navbar-fixed-top\" role=\"navigation\"> ~
      <div class=\"container\"> ~
        <div class=\"navbar-header\"> ~
          <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\"> ~
            <span class=\"sr-only\">Toggle navigation</span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
            <span class=\"icon-bar\"></span> ~
          </button> ~
           ~
		  <a class=\"navbar-brand\" href=\"register.php\">Olead test</a> ~
        </div> ~
      </div> ~
    </div> ~
	 ~
 ~
	<div class=\"container\" style=\"margin: 40px;\"> ~
	      <div class=\"row\"><h2>~A</h2> ~
	  </div> ~
<div>~A</div> ~
    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js\"></script> ~
    <script src=\"~A\"></script> ~
  </body> ~
</html>" bootstrapcss-url "Кампании" campsblock bootstrapjs-url))))

;css/bootstrap.min.css
;../../dist/js/bootstrap.min.js
;;;;;;;;;;;;;;;;;

(defun make-on-cabinet ()
	#'(lambda (req)
		"ON-INDEX!"))

