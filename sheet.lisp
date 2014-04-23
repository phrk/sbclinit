
(ql:quickload "yason")
(load "utils.lisp")

(defpackage :olead
	(:export :sheet :get-field :set-field :sheet-fields-tojson :sheet-fields-fromjson :sheet-tostring :sheet-fill-debug :sheet-fields)
	(:use :common-lisp)
)

(in-package :olead)

(defclass sheet ()
	((fields :accessor sheet-fields
			 :initarg :fields
			 :initform (make-hash-table :test #'equal))
	(sheetid :accessor sheet-landid
			 :initarg :sheetid
			 :initform -1
			 :documentation "recieved from advertiser")
	(partnerid :accessor sheet-partnerid
			 :initarg :partnerid
			 :initform -1)
	(campid :accessor sheet-campid
			 :initarg :campid
			 :initform -1)))

(defmethod get-field ((sht sheet) (field string))
	(gethash field (sheet-fields sht)))
	
(defmethod set-field ((sht sheet) (field string) (value string))
	(setf (gethash field (sheet-fields sht)) value) )

(defmethod sheet-fields-tojson((sht sheet))
	(with-output-to-string (str) 
		(yason:encode (sheet-fields sht) str)))

(defmethod sheet-fields-fromjson((sht sheet) jsonfields)
	(setf (sheet-fields sht) (yason:parse jsonfields)))

(defmethod sheet-fill-debug ()
	"not implemented")

(defmethod sheet-tostring ((sht sheet))
	(setf ret (format nil "partnerid:~A~% campid:~A~% fields:~A~%" (sheet-partnerid sht) (sheet-campid sht) (hash-table-size (sheet-fields sht))))
	(maphash #'(lambda (k v)
			(setf ret (concatenate 'string ret k))
			(setf ret (concatenate 'string ret v))) (sheet-fields sht))
	(return-from sheet-tostring ret))
