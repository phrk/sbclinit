
(defun our-copy-tree (tr)
	(if (atom tr)
		tr
		(cons (our-copy-tree (car tr))
				(our-copy-tree (cdr tr)))))

(defun listlen (lst)
	(if (null lst)
		0
		(+ (listlen (cdr lst)) 1)) )
		
(defun ourmember (obj lst)
	(if (null lst)
		nil
		(if (equal obj (car lst))
			lst
			(ourmember obj (cdr lst)) ) ) )
			
(defun mirror? (a)
	(equal a (reverse a)))


(defun nrepeats(obj lst)
	(if (null lst) 
	0
	(if (not (equal (car lst) obj))
		0
		(+ 1 (nrepeats obj (cdr lst) ) ))))


(defun code-repeats (lst)
	(if (null lst)
	lst
	(let ((nreps (nrepeats (car lst) lst))) 
		(if (equal nreps 1)
		(return-from code-repeats (cons (car lst)
										(code-repeats (nthcdr nreps lst))))
		(return-from code-repeats (cons (list nreps (car lst))
										(code-repeats (nthcdr nreps lst))))))))

(defun consn (n obj lst)
	(if (equal n 0)
	lst
	(return-from consn ( consn (- n 1) obj (cons obj lst)))))

;(defun decode-repeats (lst)
;	if (listp (car lst))
;	(let ((n (car (car lst))) (obj ) ) )	 
;	())


(defun pos+ (lst)
	(do-pos lst 1))

(defun do-pos (lst i)
	(if (null lst)
	lst
	(cons (+ (car lst) i) (do-pos (cdr lst) (+ i 1)) )))


(defun make-smart-vec ()
	(make-array 1 :fill-pointer 0 :adjustable t))

(defun fill-vec (size)
	(let ((vec (make-smart-vec)))
		(loop
		for i from 0 to size
		do (if (oddp i) (vector-push-extend i vec))) 
		(return-from fill-vec vec)))
	
(defun bin-search (key vec getkey)
	(do-bin-search key vec 0 (- (length vec) 1) getkey ) )

(defun do-bin-search (key vec l r getkey)
	(let* ((index (floor (/ (+ l r) 2)))
			(med (funcall getkey vec index )))
	(cond ((equal med key)
				(return-from do-bin-search index))
			((equal l r)
				(return-from do-bin-search nil))
			((> key med)
				(return-from do-bin-search  (do-bin-search key vec index r getkey) ))
			((< key med) 
				(return-from do-bin-search  (do-bin-search key vec l index getkey) )))))

;(defun fillvec (size) )
;(setf vec (make-array 1))



