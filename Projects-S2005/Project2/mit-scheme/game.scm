(load "prisoner.scm")

;; ++++++++++++++++++++++++++++++++++++++++++++++++++ 
;; Problem 1
;; 
;; Definition of "extract-entry"
;; ++++++++++++++++++++++++++++++++++++++++++++++++++ 

;;
;; The *game-association-list* is defined as follows:
;;
(define *game-association-list*
  (list (list (list "c" "c") (list 3 3))
	(list (list "c" "d") (list 0 5))
	(list (list "d" "c") (list 5 0))
	(list (list "d" "d") (list 1 1))))

;;
;; We can extract a specific entry in this list by using the "list-ref" procedure. 
;;
;; For example:
;;
(list-ref *game-association-list* 0)
;; ==> (("c" "c") (3 3))
(list-ref *game-association-list* 1)
;; ==> (("c" "d") (0 5))

;;
;; and so on. To extract the entry associated with a specific play, we need to extract 
;; the "car" of the entry, and make sure that both elements of this "car" correspond 
;; to both elements of the argument play. 
;;
;; We define our "extract-entry" procedure as follows:
;;
(define (extract-entry play *game-association-list*)
  ;; 
  ;; Returns "true" if the play matches the entry:
  ;;
  (define (compare play entry)
    (let ((test (car entry)))
      (and (string=? (car play) (car test))
	   (string=? (cadr play) (cadr test)))))

  (let
      ;; 
      ;; Get references to each entry in the *game-association-list*:
      ;;
      ((first (list-ref *game-association-list* 0))
       (second (list-ref *game-association-list* 1))
       (third (list-ref *game-association-list* 2))
       (fourth (list-ref *game-association-list* 3)))
   
    ;; 
    ;; If we find a match, return that specific entry:
    ;;
    (cond 
     ((compare play first) first)
     ((compare play second) second)
     ((compare play third) third)
     ((compare play fourth) fourth)
     (else '()))))

;;
;; We can test our procedure as follows:
;;
(extract-entry (make-play "c" "c") *game-association-list*)
;; ==> (("c" "c") (3 3))
(extract-entry (make-play "c" "d") *game-association-list*)
;; ==> (("c" "d") (0 5))
(extract-entry (make-play "d" "c") *game-association-list*)
;; ==> (("d" "c") (5 0))
(extract-entry (make-play "d" "d") *game-association-list*)
;; ==> (("d" "d") (1 1))
(extract-entry (make-play "x" "x") *game-association-list*)
;; ==> ()

;;
;; Similarly, since "get-point-list" is defined as:
;;
(define (get-point-list game)
  (cadr (extract-entry game *game-association-list*)))

(get-point-list (make-play "c" "c"))
;; ==> (3 3)
(get-point-list (make-play "c" "d"))
;; ==> (0 5)
(get-point-list (make-play "d" "c"))
;; ==> (5 0)
(get-point-list (make-play "d" "d"))
;; ==> (1 1)

;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
;; Problem 2
;;
;; Use "play-loop" to play games between the five strategies.
;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

;;
;; For reference, the five strategies are defined as:
;;

;; Always "defect"
(define (NASTY my-history other-history)
  "d")

;; Always "cooperate"
(define (PATSY my-history other-history)
  "c")

;; "Defect" or "cooperate" with 50-50 chance
(define (SPASTIC my-history other-history)
  (if (= (random 2) 0)
      "c"
      "d"))

(define (EGALITARIAN my-history other-history)
  (define (count-instances-of test hist)
    (cond ((empty-history? hist) 0)
	  ((string=? (most-recent-play hist) test)
	   (+ (count-instances-of test (rest-of-plays hist)) 1))
	  (else
	    (count-instances-of test (rest-of-plays hist)))))
  (let ((ds (count-instances-of "d" other-history))
	(cs (count-instances-of "c" other-history)))
    (if (> ds cs) "d" "c")))

;; "Cooperate" on first round, otherwise return "eye for eye"
(define (EYE-FOR-EYE my-history other-history)
  (if (empty-history? my-history)
      "c"
      (most-recent-play other-history)))
       
;;
;; NASTY is a highly "dominant" strategy. It never "loses" outright, at worst tying only 
;; when it plays against itself. Otherwise, NASTY is able to beat all the other strategies.
;;
;; When NASTY plays against the following opponents, we obtain the following results:
;;

;;
;;           -------------------------------------------------------------------------
;;           |    NASTY   |    PATSY   |   SPASTIC   |  EGALITARIAN  |  EYE-FOR-EYE  |
;;------------------------------------------------------------------------------------
;;   NASTY   |    Ties    |    Wins    |    Wins     |     Wins      |     Wins      | 
;;           | 1.0 points | 5.0 points | 2.88 points |  1.04 points  |  1.04 points  | 
;;------------------------------------------------------------------------------------
;;

;; 
;; Note that in all these plays, SPASTIC is a stochastic strategy and will generate 
;; slightly different point values which vary from round to round.
;;

;;
;; PATSY never wins, and it loses badly against NASTY and SPASTIC. However, it ties with
;; itself, EGALITARIAN and EYE-FOR-EYE.
;;
;; When PATSY plays against the following opponents, we obtain the following results:
;;

;;
;;           ----------------------------------------------------------------------------
;;           |    NASTY    |    PATSY   |    SPASTIC   |  EGALITARIAN  |   EYE-FOR-EYE  |
;;---------------------------------------------------------------------------------------
;;   PATSY   |    Loses    |    Ties    |    Loses     |     Ties      |      Ties      |
;;           |  0.0 points | 3.0 points |  1.29 points |  3.0 points   |   3.0 points   |
;;---------------------------------------------------------------------------------------
;;

;;
;; Despite being ostensibly "random", the SPASTIC strategy fares quite well. When playing
;; against itself, the results are (essentially) a draw, where it wins or loses by a slight
;; random margin. Similarly, the results against EYE-FOR-EYE are usually neutral (i.e., a tie)
;; with an occasional very slighty win on the side of SPASTIC. SPASTIC wins decisively against
;; PATSY, and loses against NASTY.
;;
;; The most interesting behavior is when SPASTIC plays EGALITARIAN. Usually (roughly 70% of 
;; the time), SPASTIC will win decisively, but occassionally (roughly 30% of the time) it 
;; will lose (quite badly).
;; 
;; Note that SPASTIC is a stochastic strategy and will generate slightly different point 
;; values which vary from round to round. Specifically, when playing against itself, 
;; SPASTIC will either win or lose, but only by a very narrow margin, both opponents 
;; obtaining nearly the same number of points. This state of affairs is labeled a
;; "stochastic tie".
;;
;; When SPASTIC plays against the following opponents, we obtain the following results:
;;

;;
;;           ---------------------------------------------------------------------------------------------
;;           |     NASTY     |     PATSY    |       SPASTIC      |   EGALITARIAN   |     EYE-FOR-EYE     |
;;--------------------------------------------------------------------------------------------------------
;;  SPASTIC  |     Loses     |     Wins     |  "Stochastic Tie"  |  Usually Wins   |  Tie or Slight Win  |
;;           |  0.527 points |  4.1 points  |     2.32 points    |   2.77 points   |     2.29 points     |
;;           |               |              |                    |   Rare Loss     |                     |
;;           |               |              |                    |  1.22 points    |                     |
;;--------------------------------------------------------------------------------------------------------
;;