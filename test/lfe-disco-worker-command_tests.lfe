(defmodule lfe-disco-worker-command_tests
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


(defun create-message_test ()
  (let ((result (: lfe-disco-worker-command create-message '"FOO")))
    (assert-equal result `'"FOO 2 \"\"\n"))
  (let ((result (: lfe-disco-worker-command create-message '"BAR" '"baz")))
    (assert-equal result `'"BAR 3 baz\n")))

(defun ping_test ()
  (let ((result (: lfe-disco-worker-command ping)))
    (assert-equal result `'"PING 2 \"\"\n")))

(defun task_test ()
  (let ((result (: lfe-disco-worker-command task)))
    (assert-equal result `'"TASK 2 \"\"\n")))

(defun input_test ()
  (let ((result (: lfe-disco-worker-command input)))
    (assert-equal result `'"INPUT 2 \"\"\n")))

(defun input-error_test ()
  (let ((result (: lfe-disco-worker-command input-error 1 '(2 3 4))))
    (assert-equal result `'"INPUT_ERR 11 [1,[2,3,4]]\n")))

(defun msg_test ()
  (let ((result (: lfe-disco-worker-command msg '"hey there!")))
    (assert-equal result `'"MSG 10 hey there!\n")))


(defun worker-announce_test ()
  ; XXX why isn't meck working for this test?!
  ;(: meck new 'lfe-disco-util '(passthrough unstick))
  ;(: meck new 'lfe-disco-util)
  ;(: meck expect 'lfe-disco-util 'getpid 0 12345)
  ;(: meck expect 'lfe-disco-util 'json-encode (lambda (x) (: meck passthrough (list x))))
  ;(: meck expect 'lfe-disco-util 'json-wrap-bin (lambda (x) (: meck passthrough (list x))))
  ;(try
    (let ((result (list_to_binary
                    (: lists sublist
                      (: lfe-disco-worker-command worker-announce)
                      34))))
      (assert-equal
        '"WORKER 31 {\"version\":\"1.1\",\"pid\":\""
        `(binary_to_list ,result)))
    ;(after
      ;(: meck validate 'lfe-disco-util)
      ;(: meck unload 'lfe-disco-util))))
  )
