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

(defun error_test ()
  (let ((result (: lfe-disco-worker-command error '"There was an error!")))
    (assert-equal result `'"ERROR 19 There was an error!\n")))

(defun fail_test ()
  (let ((result (: lfe-disco-worker-command fail '"There was a failure!")))
    (assert-equal result `'"FAIL 20 There was a failure!\n")))

(defun task_test ()
  (let ((result (: lfe-disco-worker-command task)))
    (assert-equal result `'"TASK 2 \"\"\n")))

(defun done_test ()
  (let ((result (: lfe-disco-worker-command done)))
    (assert-equal result `'"DONE 2 \"\"\n")))

(defun input_test ()
  (let ((result (: lfe-disco-worker-command input)))
    (assert-equal result `'"INPUT 2 \"\"\n")))

(defun input-error_test ()
  (let ((result (: lfe-disco-worker-command input-error 1 '(2 3 4))))
    (assert-equal result `'"INPUT_ERR 11 [1,[2,3,4]]\n")))

(defun msg_test ()
  (let ((result (: lfe-disco-worker-command msg '"hey there!")))
    (assert-equal result `'"MSG 10 hey there!\n")))

; XXX output/2 needs to be mocked
(defun output_test ()
  (let ((result (list_to_binary
                    (: lists sublist
                      (: lfe-disco-worker-command output
                        '"data" '"/etc/passwd") 32))))
      (assert-equal
        '"OUTPUT 27 [\"data\",\"/etc/passwd\","
        `(binary_to_list ,result)))
  (let ((result (: lfe-disco-worker-command output
                  '"data" '"/output/path" 1024)))
    (assert-equal result `'"OUTPUT 28 [\"data\",\"/output/path\",1024]\n")))

; XXX worker-announce/0 needs to be mocked
(defun worker-announce_test ()
  ; XXX why isn't meck working for this test?!
  ;(: meck new 'lfe-disco-util '(passthrough unstick))
  ;(: meck new 'lfe-disco-util)
  ;(: meck expect 'lfe-disco-util 'getpid 0 12345)
  ;(: meck expect
  ;  'lfe-disco-util 'json-encode (lambda (x) (: meck passthrough (list x))))
  ;(: meck expect
  ;  'lfe-disco-util 'json-wrap-bin (lambda (x) (: meck passthrough (list x))))
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
  (let ((result (list_to_binary
                  (: lfe-disco-worker-command worker-announce 12345))))
    (assert-equal
      '"WORKER 31 {\"version\":\"1.1\",\"pid\":\"12345\"}\n"
      `(binary_to_list ,result)))
  (let ((result (list_to_binary
                  (: lfe-disco-worker-command worker-announce '"12345"))))
    (assert-equal
      '"WORKER 31 {\"version\":\"1.1\",\"pid\":\"12345\"}\n"
      `(binary_to_list ,result)))
  )
