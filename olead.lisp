(load "~/quicklisp/setup.lisp")
(ql:quickload "postmodern")
(ql:quickload "yason")
(ql:quickload :drakma)

(load "utils.lisp")
(load "sheet.lisp")
;(load "camp.lisp")
(load "listener.lisp")
(load "hdl_json.lisp")

(load "web/index.lisp")
(load "web/addcampview.lisp")

(load "web/oleadface.lisp")

(defpackage :olead
	(:export :olead-test)
	(:use :common-lisp)
)

(in-package :olead)

(defclass sheetapi ()
	((lstnr
			:accessor sheetapi-lstnr)
	(camps
			:accessor sheetapi-camps
			:initform (make-hash-table :test #'equal))
	(senders
			:accessor sheetapi-senders
			:initform (make-hash-table :test #'equal))
	(dblock
			:accessor sheetapi-dblock
			:initform (bordeaux-threads:make-lock "queue-lock"))))

(defmethod sheetapi-logf ((shtapi sheetapi) str)
	(format t "~A" str))

(defmethod get-sender-fun((shtapi sheetapi) campid)
	(gethash campid (sheetapi-senders shtapi)))

;(sheet-partnerid sht) (sheet-campid sht) (sheet-fields-tojson sht)))

(defmethod putdb-sheet ((shtapi sheetapi) sht)
	(handler-case
		(postmodern:query (format nil "INSERT INTO sheetapi.sheets (partner_eid, camp_id, fields) VALUES ('~A', '~A', '~A' )" (sheet-partnerid sht) (sheet-campid sht) (sheet-fields-tojson sht)))		
	(t (cnd) (sheetapi-logf shtapi "putdb-sheet: error inserting to db"))))

(defmethod sheet-connect-db ((shtapi sheetapi))
	(handler-case
		(setf *database* (postmodern:connect-toplevel "olead" "olead" "olead" "127.0.0.1"))
	(error (cnd) (sheetapi-logf shtapi "sheet-connect-db: error connecting to db") )))

;http://track.otclick-adv.ru/aff_lsr?offer_id=168&aff_id=2
(defmethod send-hasoffers-event ((sht sheet))
	(drakma:http-request (format nil "http://track.otclick-adv.ru/aff_lsr?offer_id=~A&aff_id=~A" (sheet-campid sht) (sheet-partnerid sht) ) ))

(defmethod on-sheet((shtapi sheetapi) sht)
	(putdb-sheet shtapi sht)
	(send-hasoffers-event sht)
;	(funcall (get-sender-fun shtapi (sheet-campid sht)) sht)
	(sheet-tostring sht))

(defun make-uri-print()
	#'(lambda (req)
		(tbnl:request-uri req)))

(defmethod ubrr-sender((sht sheet))
	)

(defmethod sheetapi-add-senders ((shtapi sheetapi))
	(setf (gethash "0" (sheetapi-senders shtapi))
		#'ubrr-sender))

(defmethod load-camp ((shtapi sheetapi) campid senderid)
	(format t "add-camp camp:~A sender:~A~%" campid senderid)
	(setf (gethash campid (sheetapi-camps shtapi)) senderid))

(defmethod load-camps((shtapi sheetapi))
	(handler-case
		(let ((resp (postmodern:query (format nil "SELECT * FROM sheetapi.camps"))))
			(mapcar	#'(lambda (line)
								(load-camp shtapi (first line) (second line))) resp))
	(error (cnd) (sheetapi-logf shtapi "load-camps error loading from db"))))

(defmethod add-camp((shtapi sheetapi) camp-hash)
	(handler-case
		(postmodern:query
			(format nil "INSERT INTO sheetapi.camps (camp_eid, ~
										hasoffers_url, ~
										name, ~
										advertiser_iid, ~
										api_userid, ~
										api_key) VALUES ('~A', '~A', '~A', '~A', '~A', '~A')"
				(gethash "camp_eid" camp-hash)
				(gethash "hasoffers_url" camp-hash)
				(gethash "name" camp-hash)
				(gethash "advertiser_iid" camp-hash)
				(gethash "api_userid" camp-hash)
				(gethash "api_key" camp-hash) ) )
	(error (cnd) (format t "add-camp INSERT ERROR") ) ) )

(defmethod get-camps ((shtapi sheetapi))
	(let ((ret (utils:make-smart-vec)))
		(handler-case
			(let ((resp (postmodern:query (format nil "SELECT * FROM sheetapi.camps"))))
				(mapcar #'(lambda (line)
							;(format t "~A~%" (yason:encode line))
							(vector-push-extend line ret)
							)
					resp))
		(error (cnd) (format t "get-camps INSERT ERROR") ) )
	ret) )

(defmethod sheetapi-start ((shtapi sheetapi))
	(print "sheetapi-start")
	(defparameter lstnr (make-instance 'listener))

	(sheetapi-add-senders shtapi)
	(sheet-connect-db shtapi)
	(load-camps shtapi)
	

	(start-olead-face lstnr)

	;(listener-add-handler lstnr "/foo/" (make-hdl-json #'(lambda (sht) ( on-sheet shtapi sht ) ) "<a href=http://olead.otclick-adv.ru/jsonapi/descr/>http://olead.otclick-adv.ru/jsonapi/descr/</a>"))
	
	;(listener-add-handler lstnr "/testview/" (make-test-view))
	;(listener-add-handler lstnr "/printbody/" (make-hdl-printbody ))
	;(listener-add-handler lstnr "/ifs/" (make-on-cabinet))
	;(listener-add-handler lstnr "/register/" (make-gen-register-page (make-hash-table) "/file/css/bootstrap.min.css" "/file/js/bootstrap.min.js") )

	;(listener-add-handler lstnr "/addcamp/" (make-add-camp-view ) )
	
	;(listener-add-handler lstnr "/listcomp/" (make-list-comps-page (make-hash-table) "/file/css/bootstrap.min.css" "/file/js/bootstrap.min.js") )

	;(listener-add-handler lstnr "/printuri/" (make-uri-print) )
	;(listener-add-handler lstnr "/file/" (make-file-listener "/file/" "web/file/"))
	(listener-start lstnr 4242))

(defparameter shtapi (make-instance 'sheetapi))
(sheetapi-start shtapi)

;(defun testjson()
;	(handler-case
;			(json:decode-json-from-string "{\"a\" :\"b\", \"c\":\"d\", \"fields\": [ { \"key0\": \"value0\" }, { \"key1\": \"value1\" }  ] }")
;	(error (cnd) 666 )))
	
(defun testjason()
	(yason:parse "{\"a\" :\"b\", \"c\":\"d\", \"fields\": [ { \"key0\": \"value0\" }, { \"key1\": \"value1\" }  ] }"))
		
;(print  (testjson) )
;(print (gethash "fields" (testjason)) )

;(defun sheet-test())

;(sheet-test)
