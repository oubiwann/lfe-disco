(defmodule lfe-disco-util
  (export all))


; XXX move these to lfe-utils
(defun bin->int (bin-data)
  (list_to_integer (binary_to_list bin-data)))

(defun int->bin (int)
  (list_to_binary (integer_to_list int)))
