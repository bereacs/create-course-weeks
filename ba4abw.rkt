#lang racket

(require "create-pages.rkt")

; start_date = datetime.date(2013, 8, 21)
; end_date = datetime.date(2013, 12, 5)

(start-date (date* 0 0 0 21 8 2013 1 6 #f -18000 0 "EST"))
(end-date (date* 0 0 0 5 12 2013 5 115 #f -18000 0 "EST"))
(output-directory "ba4abw")

(define ba4abw
  (let ([counter 0])
    (λ ()
      (λ (the-date y m d yd dow)
        (define week# (get-week-number the-date))
        (cond
          [(sunday? the-date)
           `(page
             (file ,(format "~a-~a-~a-w~a.md"
                            y (pad2 m) (pad2 d) 
                            (pad2 week#)))
             (yaml
              (title ,(format "Week ~a" week# ))
              (slug "...")
              (week ,week#)
              (category "week")
              (layout post)
              (publish no))
             (content
              (blank 1)))]
          
          [(tr? the-date)
           
           (set! counter (add1 counter))
           
           `(page
             (file ,(format "~a-~a-~a-~a.md"
                            y (pad2 m) (pad2 d) 
                            (pad3 counter)))
             (yaml
              (title "")
              (category "day")
              (layout post)
              (publish no)
              )
             (content
              (blank 1)
              (=== "Due Today")
              (blank 1)
              (=== "Team Time")
              (blank 1)
              (=== "In Class")
              (blank 1)
              (=== "Launched Today")
              ))]
          )
        ))))

(define (generate-ba4abw)
  (for-each 
   render-page 
   (generate-pages (reverse (make-list-of-dates)) 
                   (λ (d) (or (tr? d)
                              (sunday? d)))
                   ba4abw
                   (list))))

(generate-ba4abw)