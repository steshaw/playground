
(define result 
  (+ 1 (call/cc
    (lambda (k) 
      (+ 2 (k 4))))))

(println result)
