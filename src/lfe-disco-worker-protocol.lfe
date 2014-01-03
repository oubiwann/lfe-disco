(defmodule lfe-disco-worker-protocol
  (export all))

(defun parse (buffer)
  (parse buffer 'new-message))

(defun parse
  ((buffer 'new-message)
    (parse-new-message-header buffer))
  ((buffer (= (tuple 'parse-length type) state))
    ; XXX call parse-message-header here ...
    (+ 2 3))
  ; XXX the following needs a guard for when the byte_size is less than total
  ;((buffer (= (tuple 'parse-body type length-str total) state))
  ;  (+ 3 4))
  ((buffer (tuple 'parse-body type length-str total))
    (+ 4 5)))

(defun parse-new-message-header (buffer)
  "Parse a new message."
  (case (car buffer)
    ((tuple 'ok type)
      (parse buffer (tuple 'parse-length type)))
    ('head-missing
      (tuple 'error 'invalid-type))
    ('more-data
      (tuple 'cont buffer 'new-message))))

(defun parse-message-header (buffer data state)
  "Parse a message whose state is other than 'new-message."
  (case (car data)
    ((tuple 'ok length-str)
      ; XXX call check-message-length here...
      (+ 5 6))
    ('head-missing
      (tuple 'error 'invalid-type))
    ('more-data
      (tuple 'cont buffer state))))

(defun check-message-length (buffer length-str type)
  "Once the data and the message length have been extracted, do some checks.
  If everything works out, continue parsing."
  (let ((len (: lfe-disco-util bin->int length-str)))
    (try
      (cond
        ((< len 0)
          (tuple 'error 'subzero-length))
        ((> len (: lfe-disco-config max-message-length))
          (tuple 'error 'message-too-large))
        ('true
          (let ((total (+ (byte_size type) (byte_size length-str) len 3)))
            ; XXX uncomment the following line once parse/2 is complete and
            ;   delete the line after
            ;(parse buffer (tuple 'parse-body type length-str total))
            (tuple 'parse-body type length-str total)
            )))
      (catch
        ((tuple _ _ _)
          (tuple 'error 'unexpected))))))
