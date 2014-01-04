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

(defun worker-announce ()
  (let* ((data (list 'version (: lfe-disco-worker version)
                     'pid (: lfe-disco-util getpid)))
         (payload (: lfe-disco-util json-encode data)))
  (create-message '"WORKER" payload)))
