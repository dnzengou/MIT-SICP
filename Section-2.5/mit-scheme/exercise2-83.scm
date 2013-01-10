;;
;; Exercise 2.83
;;
;; [WORKING]
;;

;;
;; Both the tower diagram and the problem statement refer to a type hierarchy that
;; looks something like the following:
;;
;;  integer --> rational --> real --> complex
;;
;; We do not presently have an "integer" or a "real" number package. 
;; 
;; Let's agree to use our pre-existing "scheme-number" package as the "real" package.
;;
;; Let's furthermore design an "integer" package which will be very similar to 
;; the "scheme-number" package, except that the domain will be restricted to integers.
;; Notably, we will not support the division operation, since integers are not closed
;; under the division operation.
;; 
(define (install-integer-package)
  (define (tag x)
    (attach-tag 'integer x))
  (put 'add '(integer integer)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(integer integer)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(integer integer)
       (lambda (x y) (tag (* x y))))
  (put 'exp '(integer integer)
       (lambda (x y) (tag (expt x y))))
  (put 'equ? '(integer integer)
       (lambda (x y) (= x y)))
  (put '=zero? '(integer)
       (lambda (p) (= p 0)))
  (put 'make 'integer
       (lambda (x) (tag x)))
  'done)

(define (make-integer n)
  ((get 'make 'integer) n))
  
;;
;; In practice, other than in name, there is little-to-no difference between the 
;; "scheme-number" package and the "integer" package.
;;

;;
;; Install the integer package:
;;
(install-integer-package)

;;
;; We will also define a coercion procedure, to coerce the integers into 
;; scheme-numbers, should this be required:
;;
(define (integer->scheme-number n)
  (make-scheme-number n))

(put-coercion 'integer 'scheme-number integer->scheme-number)

;;
;; Let's run some unit tests:
;;
(define i1 (make-integer 2))
(define i2 (make-integer 3))

(add i1 i2)
;; ==>
(sub i1 i2)
;; ==>
(mul i1 i2)
;; ==>


;;
;; However, we have not hitherto generated "integer" and "real" packages, and, 
;; on the contrary, both "integer" and "real" types are handled uniformly by 
;; our "scheme-number" package. 
;;
;; Accordingly, we will define two hierarchies that looks something more like:
;;
;;  scheme-number ---> rational ---> complex
;;
;;
;; [WORKING --> rewrite this part]
;;
;; We will moreover define "helper" procedures that raise a scheme-number 
;; directly to a complex (if the scheme number is not a rational number), and 
;; which "lower" a rational number to a scheme-number (i.e., convert the 
;; rational representation to a real-number representation as a scheme-number).
;;

;; The scheme number will be our "real".


(define (install-integer-package)
  (define (tag x)
    (attach-tag 'integer x))
  
  (put 'add '(integer integer)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(integer integer)
       (lambda (x y)
;;
;; Let's also coerce integers into being scheme-numbers:
;;


;;
;; This method uses the "exact-integer?" procedure which is built into MIT Scheme.
;;
(define (raise-scheme-number->rational n)
  ;; Helper method (go straight to complex)
  (define (raise-scheme-number->complex n)
    (make-complex-from-real-imag n 0.0))

  ;; Raise depending on the type
  (if (exact-integer? n)
      (make-rational n 1)
      (raise-scheme-number->complex n)))

;;
;; Raise a rational to complex by first converting it to a real 
;; (i.e., scheme-number):
;;
(define (raise-rational->complex r)
  ;; Helper method (determines if the argument is of type rational)
  (define (is-rational? x)
    (if (pair? x)
	(let ((kind (car x)))
	  (eq? kind 'rational))
	#f))

  ;; Helper method (lower the rational down to real/scheme-number)
  (define (lower-rational->scheme-number x)
    (let ((n (numer x))
	  (d (denom x)))
      (make-scheme-number (/ (* 1.0 n) (* 1.0 d)))))

  ;; Raise to complex
  (if (is-rational? r)
      (let ((x (lower-rational->scheme-number r)))
	(make-complex-from-real-imag x 0.0))
      ;; default, just return the value
      r))

;;
;; Run some unit tests:
;;
(raise-scheme-number->rational (make-scheme-number 3))
;; ==> (rational 3 . 1)
(raise-scheme-number->rational (make-scheme-number 3.14))
;; ==> (complex rectangular 3.14 . 0.)

(raise-rational->complex (make-rational 3 1))
;; ==> (complex rectangular 3. . 0.)
(raise-rational->complex (make-rational 5 4))
;; ==> (complex rectangular 1.25 . 0.)

;;
;; We define the generic "raise" procedure:
;;
(define (raise x) (apply-generic 'raise x))

;;
;; Update the operations table:
;;
(put 'raise '(scheme-number) raise-scheme-number->rational)
(put 'raise '(rational)
     (lambda (z) (attach-tag 'complex (raise-rational->complex z))))
    