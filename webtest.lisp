
(ql:quickload "hunchentoot")

;;; Subclass ACCEPTOR
(defclass vhost (tbnl:acceptor)
	;; slots
	((dispatch-table
		:initform '()
		:accessor dispatch-table
		:documentation "List of dispatch functions"))
  ;; options
	(:default-initargs                    ; default-initargs must be used
	:address "127.0.0.1"))               ; because ACCEPTOR uses it

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod tbnl:acceptor-dispatch-request ((vhost vhost) request)
	;; try REQUEST on each dispatcher in turn
	(mapc (lambda (dispatcher)
		(let ((handler (funcall dispatcher request)))
			(when handler               ; Handler found. FUNCALL it and return result
				(return-from tbnl:acceptor-dispatch-request (funcall handler request)))))
		(dispatch-table vhost))
	(call-next-method))

(defun foo(request)
	(print (tbnl:get-parameter "name")))

(defun bar(request)
	(format nil "BAR"))

(defvar vhost1 (make-instance 'vhost :port 8080))

(push (tbnl:create-prefix-dispatcher "/foo/" 'foo)
      (dispatch-table vhost1))

(push (tbnl:create-prefix-dispatcher "/bar/" 'bar)
      (dispatch-table vhost1))

(tbnl:start vhost1)
