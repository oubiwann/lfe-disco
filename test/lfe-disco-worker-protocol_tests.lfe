(defmodule lfe-disco-worker-protocol_tests
  (export all)
  (import
    (from lfeunit-util
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))
    (from lfeunit
      (assert 1)
      (assert-not 1)
      (assert-equal 2)
      (assert-not-equal 2)
      (assert-exception 3)
      (assert-error 2)
      (assert-throw 2)
      (assert-exit 2))))


(defun test-ok-data ()
  (list #(ok "data") 1 2 3))

(defun test-head-missing-data ()
  (list 'head-missing 1 2 3))

(defun test-more-data ()
  (list 'more-data 1 2 3))

(defun test-not-done-data ()
  (list 'more-data 1 2 3))

(defun parse_1_test ()
  (let ((result (: lfe-disco-worker-protocol parse (test-ok-data))))
    (assert-equal result 5)))

(defun parse_2_test ()
  (let ((result (: lfe-disco-worker-protocol parse
                  (test-ok-data) 'new-message)))
    (assert-equal result 5))
  (let ((result (: lfe-disco-worker-protocol parse
                  (test-ok-data) 'new-message)))
    (assert-equal result 5))
  )

(defun parse-new-message-header_test ()
  (let ((result (: lfe-disco-worker-protocol parse-new-message-header
                  (test-ok-data))))
    (assert-equal result 5))
  (let ((result (: lfe-disco-worker-protocol parse-new-message-header
                  (test-head-missing-data))))
    (assert-equal result #(error invalid-type)))
  (let ((result (: lfe-disco-worker-protocol parse-new-message-header
                  (test-more-data))))
    (assert-equal result (tuple 'cont (test-more-data) 'new-message))))

(defun parse-message-header_test ()
  (let ((result (: lfe-disco-worker-protocol parse-message-header
                  '"some buffer" (test-ok-data) 'some-message)))
    (assert-equal result 11))
  (let ((result (: lfe-disco-worker-protocol parse-message-header
                  '"some buffer" (test-head-missing-data) 'some-message)))
    (assert-equal result #(error invalid-type)))
  (let ((result (: lfe-disco-worker-protocol parse-message-header
                  '"some buffer" (test-more-data) 'some-message)))
    (assert-equal result (tuple 'cont '"some buffer" 'some-message))))

(defun check-message-length-errors_test ()
  (let* ((negative-one (: lfe-disco-util int->bin -1))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" negative-one 'some-type)))
    (assert-equal result #(error subzero-length)))
  (let* ((too-big-len (: lfe-disco-util int->bin
                        (+ (: lfe-disco-config max-message-length) 1)))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" too-big-len 'some-type)))
    (assert-equal result #(error message-too-large)))
  ; in this last one, we create a pattern that isn't matched in the func's cond
  ; in order to induce the (catch ...)
  (let* ((len (: lfe-disco-util int->bin 10))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" len '"non-binary type data")))
    (assert-equal result #(error unexpected)))
  )

(defun check-message-length-success_test ()
  ; make sure a length of zero works
  (let* ((len (: lfe-disco-util int->bin 0))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" len (list_to_binary '"some type"))))
    (assert-equal
      result
      (tuple 'parse-body (binary "some type") (binary "0") 13)))
  ; make sure large message lengths work
  (let* ((big-len (: lfe-disco-util int->bin
                    (- (: lfe-disco-config max-message-length) 1)))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" big-len (list_to_binary '"some type"))))
    (assert-equal
      result
      (tuple 'parse-body (binary "some type") (binary "104857599") 104857620)))
  (let* ((big-len (: lfe-disco-util int->bin
                    (: lfe-disco-config max-message-length)))
         (result (: lfe-disco-worker-protocol check-message-length
                  '"some buffer" big-len (list_to_binary '"some type"))))
    (assert-equal
      result
      (tuple 'parse-body (binary "some type") (binary "104857600") 104857621)))
  )
