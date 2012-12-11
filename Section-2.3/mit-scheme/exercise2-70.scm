;;
;; Exercise 2.70
;;
;; The following eight-symbol alphabet with associated relative frequencies was designed to 
;; efficiently encode the lyrics of 1950s rock songs. (Note that the "symbols" of an "alphabet"
;; need not be individual letters.)
;; 
;;  A 2     NA 16
;;  BOOM 1  SHA 3
;;  GET 2   YIP 9
;;  JOB 2   WAH 1
;;
;; Use "generate-huffman-tree" (Exercise 2.69) to generate a corresponding Huffman tree, and use
;; "encode" (Exercise 2.68) to encode the following message:
;;
;;  Get a job
;;  Sha na na na na na na na na
;;  Get a job
;;  Sha na na na na na na na na
;;  Wah yip yip yip yip yip yip yip yip yip
;;  Sha boom
;;
;; How many bits aer required for the encoding? What is the smallest number of bits that would be 
;; needed to encode this song if we used a fixed-length code for the 8-symbol alphabet?
;;

;;
;; Let's import the required procedures:
;;
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))
(define (make-code-tree left right)
  (list left
	right
	(append (symbols left) (symbols right))
	(+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
	((= bit 1) (right-branch branch))
	(else
	 (error "Bad bit -- CHOOSE BRANCH" bit))))
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
	'()
	(let ((next-branch 
	       (choose-branch (car bits) current-branch)))
	  (if (leaf? next-branch)
	      (cons (symbol-leaf next-branch)
		    (decode-1 (cdr bits) tree))
	      (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))
(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else 
	   (element-of-set? x (cdr set)))))
(define (reverse items)
  (define (reverse-iter lst1 lst2)
    (if (null? lst1)
	lst2
	(reverse-iter (cdr lst1) (cons (car lst1) lst2))))
  (reverse-iter items '()))
(define (encode-symbol symbol tree)
  (define (encode-symbol-iter working total)
    (if (leaf? working)
	(reverse total)
	(let ((symbols-left (symbols (left-branch working)))
	      (symbols-right (symbols (right-branch working))))
	  (cond ((element-of-set? symbol symbols-left)
		 (encode-symbol-iter (left-branch working) (cons 0 total)))
		((element-of-set? symbol symbols-right)
		 (encode-symbol-iter (right-branch working) (cons 1 total)))
		(else 
		 (error "Bad symbol: ENCODE-SYMBOL" symbol))))))
  (encode-symbol-iter tree '()))
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))
(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((< (weight x) (weight (car set))) (cons x set))
	(else
	 (cons (car set)
	       (adjoin-set x (cdr set))))))
(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
	(adjoin-set (make-leaf (car pair)    ;; symbol
			       (cadr pair))  ;; frequency
		    (make-leaf-set (cdr pairs))))))
(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq)
	  (accumulate op init (cdr seq)))))
(define (successive-merge pairs)
  (define (successive-merge-lambda a b)
    (if (null? b)
	a
	(make-code-tree a b)))
  (accumulate successive-merge-lambda '() (reverse pairs)))
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

;;
;; With the supporting procedures defined, this exercise is pretty straightforward:
;;
(define tree (generate-huffman-tree
	      '((A 2)
		(BOOM 1)
		(GET 2)
		(JOB 2)
		(NA 16)
		(SHA 3)
		(YIP 9)
		(WAH 1))))

(symbols tree)
;; ==> (na yip sha a get job boom wah)
(weight tree)
;; ==> 36
(+ 2 1 2 2 16 3 9 1)
;; ==> 36

(encode '(get a job) tree)
;; ==> (1 1 1 1 0 1 1 1 0 1 1 1 1 1 0)
(encode '(sha na na na na na na na na) tree)
;; ==> (1 1 0 0 0 0 0 0 0 0 0)
(encode '(get a job) tree)
;; ==> (1 1 1 1 0 1 1 1 0 1 1 1 1 1 0)
(encode '(sha ha na na na na na na na na) tree)
;; ==> (1 1 0 0 0 0 0 0 0 0 0)
(encode '(wah yip yip yip yip yip yip yip yip yip) tree)
;; ==> (1 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
(encode '(sha boom) tree)
;; ==> (1 1 0 1 1 1 1 1 1 0)

;;
;; Let's see if these decode correctly:
;;
(decode '(1 1 1 1 0 1 1 1 0 1 1 1 1 1 0) tree)
;; ==> (get a job)
(decode '(1 1 0 0 0 0 0 0 0 0 0) tree)
;; ==> (sha na na na na na na na na)
(decode '(1 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0) tree)
;; ==> (wah yip yip yip yip yip yip yip yip yip)
(decode '(1 1 0 1 1 1 1 1 1 0) tree)
;; ==> (sha boom)

;;
;; How many bits are required by this encoding?
;;
(* 2 (length (encode '(get a job) tree)))
;; ==> 30
(* 2 (length (encode '(sha na na na na na na na na) tree)))
;; ==> 22
(length (encode '(wah yip yip yip yip yip yip yip yip yip) tree))
;; ==> 25
(length (encode '(sha boom) tree))
;; ==> 10

(+ 30 22 25 10)
;; ==> 87

;;
;; So 87 bits are required using the Huffman encoding.
;;

;;
;; Let's calculate how much space is required if we used a fixed-length 
;; encoding of 3 bits:
;;
;;  '(get a job) ==> 3 symbols ==> 9 bits
;;  '(sha na na na na na na na na) ==> 9 symbols ==> 27 bits
;;  '(wah yip yip yip yip yip yip yip yip yip) ==> 10 symbols ==> 30 bits
;;  '(sha boom) ==> 2 symbols ==> 6 bits
;;
(+ (* 2 (+ 9 27)) 30 6)
;; ==> 108

;;
;; If we used fixed-length encoding, we would require 108 bits.
;;
;; The Huffman encoding saves requires bout 80.6% the amount of space as the 
;; fixed length encoding does.
;;