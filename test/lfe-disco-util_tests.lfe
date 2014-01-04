(defmodule lfe-disco-util_tests
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


; XXX move these to lfe-utils
(defun binary-to-integer_test ()
  (assert-equal -1 (: lfe-disco-util bin->int #B(45 49)))
  (assert-equal 0 (: lfe-disco-util bin->int #B(48)))
  (assert-equal 1 (: lfe-disco-util bin->int #B(49))))

(defun integer-to-binary_test ()
  (assert-equal #B(45 49) (: lfe-disco-util int->bin -1))
  (assert-equal #B(48) (: lfe-disco-util int->bin 0))
  (assert-equal #B(49) (: lfe-disco-util int->bin 1)))

(defun json-encode_test ()
  (let* ((data (list 'key-1 '"value 1" 'key-2 '"value 2"))
         (result (list_to_binary (: lfe-disco-util json-encode 'bin-pairs data))))
    (assert-equal
      '"{\"key-1\":\"value 1\",\"key-2\":\"value 2\"}"
      `(binary_to_list ,result))))

(defun json-encode-pairs_test ()
  (let* ((data (list 'key-1 '"value 1" 'key-2 '"value 2"))
         (result (list_to_binary (: lfe-disco-util json-encode 'pairs data))))
    (assert-equal
      '"{\"key-1\":[118,97,108,117,101,32,49],\"key-2\":[118,97,108,117,101,32,50]}"
      `(binary_to_list ,result))))

(defun json-encode-bin-pairs_test ()
  (let* ((data (list 'key-1 '"value 1" 'key-2 '"value 2"))
         (result (list_to_binary (: lfe-disco-util json-encode 'bin-pairs data))))
    (assert-equal
      '"{\"key-1\":\"value 1\",\"key-2\":\"value 2\"}"
      `(binary_to_list ,result))))

(defun json-encode-list_test ()
  (let* ((data '(1 2 3))
         (result (list_to_binary (: lfe-disco-util json-encode 'list data))))
    (assert-equal '"[1,2,3]" `(binary_to_list ,result))))

(defun json-encode-lists_test ()
  (let* ((data '(1 2 3 (2 3 4 (3 4 5))))
         (result (list_to_binary (: lfe-disco-util json-encode 'list data))))
    (assert-equal '"[1,2,3,[2,3,4,[3,4,5]]]" `(binary_to_list ,result))))

(defun json-encode-raw_test ()
  (let* ((data 1)
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"1" `(binary_to_list ,result)))
  (let* ((data 'a)
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"\"a\"" `(binary_to_list ,result)))
  (let* ((data '"A")
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"[65]" `(binary_to_list ,result)))
  (let* ((data '(1 2 3))
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"[1,2,3]" `(binary_to_list ,result)))
  (let* ((data (list 1 2 3))
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"[1,2,3]" `(binary_to_list ,result)))
  (let* ((data '(a "A" b "B"))
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"[\"a\",[65],\"b\",[66]]" `(binary_to_list ,result)))
  (let* ((data (list 'a '"A" 'b '"B"))
         (result (list_to_binary (: lfe-disco-util json-encode 'raw data))))
    (assert-equal '"[\"a\",[65],\"b\",[66]]" `(binary_to_list ,result))))

