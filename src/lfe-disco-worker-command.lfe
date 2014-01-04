(defmodule lfe-disco-worker-command
  (export all))


(defun create-message (command-name)
  (create-message command-name '"\"\""))

(defun create-message (command-name payload)
  (++ command-name
      '" "
      (integer_to_list (byte_size (: erlang list_to_binary payload)))
      '" "
      payload
      '"\n"))

(defun ping ()
  (create-message '"PING"))

(defun task ()
  (create-message '"TASK"))

(defun input ()
  (create-message '"INPUT"))

(defun input-error (input-id replica-locations)
  "replica-locations is a list of ids of any replications that failed."
  (let* ((data (list input-id replica-locations))
         (payload (: lfe-disco-util json-encode 'list data)))
    (create-message '"INPUT_ERR" payload)))

(defun msg (payload)
  (create-message '"MSG" payload))

(defun worker-announce ()
  (let* ((data (list 'version (: lfe-disco-worker version)
                     'pid (: lfe-disco-util getpid)))
         (payload (: lfe-disco-util json-encode 'bin-pairs  data)))
  (create-message '"WORKER" payload)))
