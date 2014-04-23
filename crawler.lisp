(load "~/quicklisp/setup.lisp")
(ql:quickload "bordeaux-threads")
(ql:quickload :drakma)

(defclass crawler () (
	(urls-queue :initform '()
				:accessor crawler-urls-queue)
	(queue-lock :initform (bordeaux-threads:make-lock "queue-lock")
				:accessor crawler-queue-lock)
	(on-crawled :accessor crawler-on-crawled)))


(defmethod add-url ((crwlr crawler) (url string))
	(with-lock (crawler-queue-lock crwlr) #'(lambda () (push url (crawler-urls-queue crwlr)))))

(defmethod next-url ((crwlr crawler))
	(with-lock (crawler-queue-lock crwlr) #'(lambda () (pop (crawler-urls-queue crwlr)))))

(defmethod crawler-thread ((crwlr crawler))
	(loop do
		(let ((url (next-url crwlr)))
			(if (not (equal nil url))
				(handler-case
					(progn
					(setf text (drakma:http-request url :connection-tineout 5))
					(funcall (crawler-on-crawled crwlr) url text))
				(T (var) ( print "error~%" ) )  )))
		while t))

(defmethod crawler-start ((crwlr crawler) (nthreads integer) on-crawled )
	(setf (crawler-on-crawled crwlr) on-crawled)
	(loop for i from 1 to nthreads
		do (bordeaux-threads:make-thread #'(lambda () (crawler-thread crwlr)))))


(setf c (make-instance 'crawler))

(loop for i from 0 to 3
	do (add-url c (format nil "http://lisp.org/~A" i)))

(crawler-start c 2 #' (lambda (url text) ( format t "onCrawl: url:~A text:~A~%" url text ) ) )
