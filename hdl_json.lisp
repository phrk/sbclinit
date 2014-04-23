(load "utils.lisp")
(load "sheet.lisp")
(load "listener.lisp")
(ql:quickload "yason")

(defpackage :olead
	(:export :make-hdl-json)
	(:use :common-lisp)
)

(in-package :olead)

(defun make-hdl-json (on-sheet descrlink)
	"Make function that parses request and builds sheet object"
	#'(lambda (req)
		(let ((sht (make-instance 'sheet)))
			(handler-case
				(let ((postfield (tbnl:get-parameter "query")))
;					(format t "QUERY: ~A~%" postfield)
					(handler-case
						(let* ((queryjson (yason:parse postfield))
								(partnerid (gethash "partnerid" queryjson) )
								(campid (gethash "campid" queryjson) )
								(fields (gethash "fields" queryjson) ))
								(block build-sheet
;									(format t "PARTNERID: ~A~%" partnerid)
;									(format t "CAMPID: ~A~%" campid)
									(if (null partnerid) (return-from build-sheet "partnerid not set" ))
									(if (null campid) (return-from build-sheet "campid not set" ))
									(if (null fields) (return-from build-sheet "fields not set" ))
									(utils:iterate-array fields #'(lambda (kv)
																(let ((key (gethash "key" kv))
																		(value (gethash "value" kv)))
																			(if (not (null key))
																				(if (not (null value))
																					(set-field sht key value))))))
									(setf (sheet-partnerid sht) partnerid)
									(setf (sheet-campid sht) campid)
									(if (= (hash-table-count (sheet-fields sht) ) 0)
										(return-from build-sheet "fields not set"))
									(return-from build-sheet (funcall on-sheet sht))))
					(error (cnd) (format nil "{ \"error\": \"Could not parse query. See API description on ~A\" }" descrlink))))
			(error (cnd) (format nil "{ \"error\": \"POST field query not set. See API description on ~A\" }" descrlink))))))


(defun make-hdl-printbody()
	#'(lambda (req)
		(tbnl:raw-post-data)))
