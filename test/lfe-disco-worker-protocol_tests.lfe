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

(defun parse_1_test ()
  (let ((result (: lfe-disco-worker-protocol parse (test-ok-data))))
    (assert-equal result 5)))

(defun parse_2_test ()
  (let ((result (: lfe-disco-worker-protocol parse
                  (test-ok-data) 'new-message)))
    (assert-equal result 5)))

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
                  '"buffer" (test-ok-data) 'message)))
    (assert-equal result 11))
  (let ((result (: lfe-disco-worker-protocol parse-message-header
                  '"buffer" (test-head-missing-data) 'message)))
    (assert-equal result #(error invalid-type)))
  (let ((result (: lfe-disco-worker-protocol parse-message-header
                  '"buffer" (test-more-data) 'message)))
    (assert-equal result (tuple 'cont '"buffer" 'message))))

; XXX add missing unit test
(defun check-message-length ()
  )
