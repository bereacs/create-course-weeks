#lang racket

(require "create-pages.rkt")

(start-date (date* 0 0 0 21 8 2013 1 6 #f -18000 0 "EST"))
(end-date (date* 0 0 0 5 12 2013 5 115 #f -18000 0 "EST"))
(output-directory "craftoe")


(define tr
  (let ([counter 0])
    (λ ()
      (λ (the-date y m d yd dow)
        (cond
          [(sunday? the-date)
           `(page 
             ;; PICK UP HERRE
             
          [(tr? the-date)
           
           (set! counter (add1 counter))
           
           `(page
             (file ,(format "~a-~a.md"
                            (pad2 m) (pad2 d) 
                            ))
             (yaml
              (title "")
              (activity "")
              (date ,(format "~a~a~a" y (pad2 m) (pad2 d)))
              
              ,(let ([release-date
                     (date- the-date DAY+7)])
               `(release ,(format "~a~a~a"
                                  (date-year release-date)
                                  (pad2 (date-month release-date))
                                  (pad2 (date-day release-date)))))
              (layout default)
                                
              )
             (content
              (blank 1)
              (=== "In Class")
              (blank 1)
              ))]
          )
        ))))




(define (generate-tr)
  (for-each 
   render-page 
   (generate-pages (reverse (make-list-of-dates)) 
                   (λ (d) (or (tr? d) ))
                   tr
                   (list))))

(generate-tr)