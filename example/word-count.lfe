(defun mapper (line _)
  (: lists map
    (lambda (x) (list x 1))
    (: re split line '"[^a-zA-Z]+" '(#(return list)))))

(defun reducer (iter _)
  (: lists map
    (match-lambda (((list word counts))
      (list word (: lists foldl #'+/2 0 counts)))) iter)

(defun main (_)
  (let ((filename '"/Users/oubiwann/lab/disco/data/book.txt")
        (result (: lfe-disco-job run filename #'mapper/2 #'reducer/2)))
    (: io format '"~p~n" (list results))))

