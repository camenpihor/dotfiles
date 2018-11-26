;;; init-python -- Emacs initialization settings

;;; Commentary:

;; Seetings for python development in Emacs

;;; Code:

(declare-function cpiho/require-package "init-packages")

(cpiho/require-package 'elpy)
(cpiho/require-package 'pyvenv)

(require 'init-flycheck)
(require 'elpy)

;; elpy
(elpy-enable)

(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;; pyvenv
(setenv "WORKON_HOME" (substitute-in-file-name "$HOME/miniconda3/envs"))
(pyvenv-mode 1)
(pyvenv-workon "camen3.6")
(global-set-key (kbd "C-c v a") 'pyvenv-workon)
(global-set-key (kbd "C-c v d") 'pyvenv-deactivate)

;; remove default elpy hooks
(add-hook 'python-mode-hook
	  (lambda() (highligh-indentation-mode -1)))

(provide 'init-python)
;;; init-python.el ends here
