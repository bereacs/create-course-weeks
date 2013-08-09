#lang racket
(require racket/date
         racket/pretty
         mzlib/string)

(provide (all-defined-out))

(define start-date 
  (make-parameter (date* 0 0 0 21 8 2013 1 6 #f -18000 0 "EST")))

(define end-date
  (make-parameter (date* 0 0 0 5 12 2013 5 115 #f -18000 0 "EST")))

(define output-directory (make-parameter "weeks"))


#|
(struct date (second
              minute
              hour
              day
              month
              year
              week-day
              year-day
              dst?
              time-zone-offset)
|#

(define DAY+1 (* 24 (* 60 60)))
(define DAY+5 (* 5 DAY+1))
(define DAY+7 (* 7 DAY+1))
(define DAY+14 (* 14 DAY+1))


(define (date- d duration)
  (seconds->date (- (date->seconds d) duration)))
(define (date+ d duration)
  (seconds->date (+ (date->seconds d) duration)))

(define (add-day d) (date+ d DAY+1))


(define (add-days d count)
  (for ([i (in-range 0 count)])
    (set! d (add-day d)))
  d)

(define (make-list-of-dates)
  (define result '())
  (define d (start-date))
  (for ([c (in-range (date-year-day (start-date))
                     ;; add1 makes it inclusive.
                     (add1 (date-year-day (end-date))))])
    (set! result (cons d result))
    (set! d (add-day d)))
  result)

(define (mwf? d)
  (member (date-week-day d) '(1 3 5)))

(define (tr? d)
  (member (date-week-day d) '(2 4)))

(define (t? d)
  (member (date-week-day d) '(2)))

(define (dow->name dow)
  (list-ref '(Sunday Monday Tuesday Wednesday Thursday Friday Satuday)
            dow))

(define (month->name dow)
  (list-ref '(Jan Feb Mar Apr May Jun Jul Aug Sep Nov Dec)
            dow))

(define (pretty-day d)
  (case d
    [(1) (format "~ast" d)]
    [(2) (format "~and" d)]
    [(3) (format "~ard" d)]
    [(21) (format "~ast" d)]
    [(22) (format "~and" d)]
    [(23) (format "~ard" d)]
    [(31) (format "~ast" d)]
    [else (format "~ath" d)]))


(define (->lower s)
  (define result (apply string (string->list (->string s))))
  (string-lowercase! result)
  result)

(define (padn n p)
  (cond
    [(< n 10) (format "~a~a" (make-string (- p 1) #\0) n)]
    [(< n 100) (format "~a~a" (make-string (- p 2) #\0) n)]
    [else n]))

(define (pad2 n)
  (padn n 2))

(define (pad3 n)
  (padn n 3))

(define (tuesday? d)
  (= 2 (date-week-day d)))

(define (thursday? d)
  (= 4 (date-week-day d)))

(define (monday? d)
  (= 1 (date-week-day d)))

(define (sunday? d)
  (= 0 (date-week-day d)))

(define (get-week-number yd)
  (define diff (- (date-year-day yd)
                  (date-year-day (start-date))))
  (add1 (quotient diff 7)))






(define (generate-pages lod day-filter? template args)
  (for/list ([d (filter day-filter? lod)])
    ((apply template args)
     d
     (date-year d)
     (date-month d)
     (date-day d)
     (date-year-day d)
     (date-week-day d)
     )))

(define (->string s)
  (format "~a" s))

(define (list-intersperse o ls)
  (cond
    [(empty? ls) ls]
    [(empty? (rest ls)) ls]
    [else
     (cons (first ls)
           (cons o
                 (list-intersperse o (rest ls))))]))

(define (render-yaml y)
  (format "~a: \"~a\"~n"
          (first y)
          (apply string-append
                 (map ->string (list-intersperse " " (rest y))))))

(define (equal-signs? o)
  (member o '(= == === ==== =====)))

(define (add-newline s)
  (format "~a~n" s))

(define (identity o) o)

(define (render-content c)
  (match c
    [`(blank ,n)
     (make-string n #\newline)]
    
    [(list (? equal-signs? e) stuff ...)
     (format "~a ~a~n"
             (make-string (string-length (->string e)) #\#)
             (apply string-append (map ->string (list-intersperse " " stuff))))]
    [`(seq ,str ...)
     (apply string-append
            (map add-newline str))]
    [else 
     (apply string-append 
            (map identity else))]
    ))

(define (render-page p)
  (match p
    [`(page ,f ,y ,c)
     (unless (directory-exists? (output-directory))
       (make-directory (output-directory)))
     
     (let* ([op (open-output-file (format "~a/~a" (output-directory) (second f)) #:exists 'replace)]
            [yaml (render-page y)]
            [content (render-page c)])
       (fprintf op
                "---~n~a---~n~a~n"
                yaml
                content)
       (close-output-port op)
       )]
    [`(yaml ,pieces ...)
     (apply string-append (map render-yaml pieces))]
    [`(content ,pieces ...)
     (apply string-append (map render-content pieces))]
    ))




