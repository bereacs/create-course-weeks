#lang racket
(require racket/date)
(provide start-date
         end-date
         template)

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

(define start-date 
  (date* 0 0 0 7 1 2013 1 6 #f -18000 0 "EST"))

(define end-date
  (date* 0 0 0 26 4 2013 5 115 #f -18000 0 "EST"))

(define (template ...)
  ...)
