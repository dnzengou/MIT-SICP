;;
;; Procedures for generating Huffman trees:
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

;;
;; Constructing and manipulating the tree:
;;
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

;;
;; Decoding using the tree:
;;
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

;;
;; Encoding using the tree:
;;
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

;;
;; Generating the tree itself
;;
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