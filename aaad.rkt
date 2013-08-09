(define (aaad team)
  (λ (the-date y m d yd dow)
    (define week# (get-week-number the-date))
    (cond
      [(tuesday? the-date)
       (define purpose "Goals")
       `(page
         (file ,(format "~a-~a-~a-~a-~a-~a.md"
                        y (pad2 m) (pad2 d) 
                        (->lower team) 
                        (->lower purpose)
                        (pad2 week#)))
         (yaml
          (title ,(format "Team ~a: Week ~a ~a" team week# purpose))
          (week ,week#)
          (category ,(->lower team))
          (layout default)
          (publish no))
         (content
          (== ,(format "~a, ~a ~a" (dow->name dow) (month->name m) (pretty-day d)))
          (blank 1)
          (=== ,purpose)
          (blank 1)
          (seq 
           "| **Role** |**Task** |"
           "| {{site.lead}}| Keep us on track. |"
           "| {{site.docu}}| Keep us writing. |"
           "| {{site.advocate}}| Make it usable. |"
           "| {{site.entrepreneur}}| Take over the world. |"
           )
          ))]
      [(thursday? the-date)
       (define purpose "Update")
       `(page
         (file ,(format "~a-~a-~a-~a-~a-~a.md"
                        y (pad2 m) (pad2 d) 
                        (->lower team) 
                        (->lower purpose)
                        (pad2 week#)))
         (yaml
          (title ,(format "Team ~a: Week ~a ~a" team week# purpose))
          (week ,week#)
          (category ,(->lower team))
          (layout default)
          (publish no))
         (content
          (== ,(format "~a, ~a ~a" (dow->name dow) (month->name m) (pretty-day d)))
          (blank 1)
          (=== ,purpose)
          ))]
      [(monday? the-date)
       (define purpose "Reflection")
       `(page
         (file ,(format "~a-~a-~a-~a-~a-~a.md"
                        y (pad2 m) (pad2 d) 
                        (->lower team) 
                        (->lower purpose)
                        (pad2 week#)))
         (yaml
          (title ,(format "Team ~a: Week ~a ~a" team week# purpose))
          (week ,week#)
          (category ,(->lower team))
          (layout default)
          (publish no))
         (content
          (== ,(format "~a, ~a ~a" (dow->name dow) (month->name m) (pretty-day d)))
          (blank 1)
          (=== ,purpose)
          (blank 1)
          (==== "Summary")
          (blank 1)
          (seq
           "| **Role** |**Task** | **Done** |"
           "| {{site.lead}}| Keep us on track. | {{site.done}} |"
           "| {{site.docu}}| Keep us writing. | {{site.notdone}} |"
           "| {{site.advocate}}| Make it usable. | {{site.done}} |"
           "| {{site.entrepreneur}}| Take over the world. | {{site.done}} |"
           )
          (blank 1)
          (==== "{{site.lead}}" "Process Lead")
          (blank 1)
          (==== "{{site.advocate}}" "Advocate")
          (blank 1)
          (==== "{{site.docu}}" "Documentation Lead")
          (blank 1)
          (==== "{{site.entrepreneur}}" "Entrepreneur")
          ))]
      )
    ))

(define (generate-aaad teams)
  (for ([t teams])
    (for-each 
     render-page 
     (generate-pages (make-list-of-dates) (λ (d) (or (monday? d)
                                                     (tuesday? d)
                                                     (thursday? d)))
                     aaad (list t)))))


(define (run-aad)
  (generate-aaad '(Cupcake Donut Eclair Froyo)))