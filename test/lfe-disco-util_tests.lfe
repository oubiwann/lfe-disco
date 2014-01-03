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
