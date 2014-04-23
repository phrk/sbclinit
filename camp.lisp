
(load "utils.lisp")

(defpackage :olead
	(:export :camp :camp-add-partner)
)

(in-package :olead)

(defclass camp-sheet () (
	(camp-eid :accessor camp-eid
			:initform -1
			:initarg :camp-eid)
	(hasoffers-url :accessor hasoffers-url
					:initform -1
					:initarg :hasoffers-url)
	(name)
	(advertiser-iid)
	(created)
	(api-userid)
	(api-key)
	(conversions)
	))

(defmethod camp-add-partner ((cmp camp) (partnerid string))
	(vector-push-extend partnerid (camp-partners cmp)))
