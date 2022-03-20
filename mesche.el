;; target argument, populated with actual project targets
;; config argument, populated with actual project configs

(defvar mesche-cli-bin-path "/home/daviwil/Projects/Code/mesche/bin/mesche")

(defun mesche--read-project ()
  ;; TODO: Walk up the directory hierarchy until you find a .git or project.msc
  (read (shell-command-to-string (concat mesche-cli-bin-path " project"))))

(defun mesche--get-project-targets (complete-me filter-p completion-type)
  (cdar (mesche--read-project)))

(defun mesche--get-project-configs ()
  (cdadr (mesche--read-project)))

(transient-define-argument mesche-build-command--target-argument ()
  :description "Build Target"
  :class transient-switches
  :key "t"
  :argument-format "%s"
  :argument-regexp "\\.*"
  :choices mesche--get-project-targets)

(transient-define-argument mesche-build-command--config-argument ()
  :description "Configuration"
  :class transient-switches
  :key "c"
  :argument-format "--config %s"
  :argument-regexp "\\.*"
  :choices '("debug" "release"))

(defun mesche-build-command--execute ()
  (interactive)
  (message "%s" (transient-args transient-current-command)))

(transient-define-suffix mesche-build-command--build-project (&optional args)
  "Show current infix args"
  :key "b"
  :description "Build Project"
  (interactive (list (transient-args transient-current-command)))
  (message (concat "mesche build " (string-join args " "))))

(transient-define-suffix mesche-build-command--run-project (&optional args)
  "Show current infix args"
  :key "r"
  :description "Run Project"
  (interactive (list (transient-args transient-current-command)))
  (message (concat "mesche run " (string-join args " "))))

(transient-define-prefix mesche-build-command ()
  "Build command arguments"
  [["Arguments"
    ;; (mesche-build-command--target-argument)
    ;; ("t" "Build Target" "--target=" :choices mesche--get-project-targets)
    (mesche-build-command--config-argument)]
   ["Actions"
    (mesche-build-command--build-project)
    (mesche-build-command--run-project)]])

(transient-define-prefix mesche-run-command ()
  "Mesche CLI Interface"
  [["Current Project"
    ("b" "build" mesche-build-command)
    ("d" "deps" (lambda () (interactive) (message "hello")))
    ("r" "repl" (lambda () (interactive) (message "hello")))
    ("i" "install" (lambda () (interactive) (message "hello")))]

   ["Global Commands"
    ("n" "new" (lambda () (interactive) (message "hello")))
    ("v" "version" (lambda () (interactive) (message "hello")))]])

(provide 'mesche)
