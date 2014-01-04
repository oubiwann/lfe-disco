(defmodule lfe-disco-util
  (export all))

(include-lib "kernel/include/file.hrl")


; XXX move these to lfe-utils
(defun bin->int (bin-data)
  (list_to_integer (binary_to_list bin-data)))

(defun int->bin (int)
  (list_to_binary (integer_to_list int)))

; XXX these are in lfe-openstack, too -- time to move these into lfe-utils
(defun json-wrap (data)
  "Ugh. I'm not a fan of JSON in Erlang. Really not a fan.

  data is a list with an even number of elements. Assuming one counts the
  elements starting with 1, the odd-numbered elements are keys and the
  even-numbered elements are values."
  (let* (((tuple keys values) (: lfe-utils partition-list data))
         (pairs (: lists zip keys values)))
    (tuple pairs)))

(defun json-wrap-bin (data)
  "Same as above, but convert values to binary in addition.

  data is a list with an even number of elements. Assuming one counts the
  elements starting with 1, the odd-numbered elements are keys and the
  even-numbered elements are values."
  (let* (((tuple keys values) (: lfe-utils partition-list data))
         (values (: lists map #'list_to_binary/1 values))
         (pairs (: lists zip keys values)))
    (tuple pairs)))

(defun json-encode (data)
  "Ah, much better."
  (json-encode 'bin-pairs data))

(defun json-encode
  "Ah, much better."
  (('pairs data)
    (json-encode 'raw (json-wrap data)))
  (('bin-pairs data)
    (json-encode 'raw (json-wrap-bin data)))
  (('list data)
    (json-encode 'raw data))
  (('list-bin data)
    (json-encode 'raw (: lists map #'list_to_binary/1 data)))
  (('raw data)
    (binary_to_list
      (: jiffy encode data))))

(defun getpid ()
  "We define own own here, so that we can unit test it. (: os getpid) is
  sticky and looks like it's used by meck itself, so it can't be mecked.

  Ours, however, can be :-)"
  (: os getpid))

(defun get-file-size (filename)
  (let (((tuple 'ok file-info) (: file read_file_info '"/etc/passwd")))
    (file_info-size file-info)))
