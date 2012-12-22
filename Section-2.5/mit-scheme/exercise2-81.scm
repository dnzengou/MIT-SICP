;;
;; Exercise 2.81
;;
;; [WORKING]
;;

;;
;; First, let's define a "coercion" table:
;;
(define coercion-table (make-table))
(define get-coercion (coercion-table 'lookup-proc))
(define put-coercion (coercion-table 'insert-proc!))

;;
;; Let's also define the coercion procedure defined in the text 
;; and install it in the table:
;;
(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)

;;
;; And let's import the definition of "apply-generic" from the text:
;;
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

;;
;; Finally, let's define some numbers and see if we can get them to coerce:
;;
(define arg1 (make-scheme-number 1))
;; ==> 1
(define arg2 (make-complex-from-real-imag 2 3))
;; ==> (complex . rectangular 2 . 3)

;;
;; Let's see if it works:
;;
(add arg1 arg2)
;; ==> (complex . rectangular 3 . 3)
(add arg2 arg1)
;; ==> (complex . rectangular 3 . 3)

;;
;; It works, and it works both ways(!)
;;
;; Let's try some other operations:
;;
(sub arg1 arg2)
;; ==> (complex rectangular -1 . -3)
(sub arg2 arg1)
;; ==> (complex rectangular 1 . 3)

(real-part (mul arg1 arg2))
;; ==> 2 
(imag-part (mul arg1 arg2))
;; ==> 3

(real-part (mul arg2 arg1))
;; ==> 2
(imag-part (mul arg2 arg1))
;; ==> 3

(real-part (div arg2 arg1))
;; ==> 2
(imag-part (div arg2 arg1))
;; ==> 3