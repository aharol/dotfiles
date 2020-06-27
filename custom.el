(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default)))
 '(package-selected-packages
   (quote
    (org-roam-bibtex ox-rst flymake-python-pyflakes pylint flycheck-pyflakes crontab-mode gruvbox-theme yaml-imenu yaml-tomato cython-mode highlight-symbol json-mode yaml-mode fold-this use-package elpygen elpy jedi-core jedi markdown-mode ein dash-at-point sbt-mode scala-mode smart-mode-line-powerline-theme smart-mode-line sml-modeline sml-mode powerline-evil neotree powerline ## dracula-theme exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree super-save smartrep smartparens operate-on-number move-text magit projectile imenu-anywhere hl-todo guru-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region epl editorconfig easy-kill diminish diff-hl discover-my-major crux browse-kill-ring beacon anzu ace-window)))
 '(safe-local-variable-values (quote ((flycheck-disabled-checkers emacs-lisp-checkdoc)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'dracula t)
;; (load-theme 'gruvbox-dark-medium t)

(require 'powerline)
(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))

(setq sml/theme 'powerline)
(sml/setup)

(require 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key [f8] 'neotree-toggle)

; (ac-config-default)

(show-paren-mode 1)
(menu-bar-mode -1)

(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

;;  Emacs diff similar to vimdiff
(add-to-list 'command-switch-alist '("diff" . command-line-diff)) ;; Usage: emacs -diff file1 file2

;; saner ediff default
(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(add-hook 'ediff-before-setup-hook 'new-frame)
(add-hook 'ediff-quit-hook 'delete-frame)

;; Proxy settings
(setq url-using-proxy t)
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "proxy.dmz.ace:3128")
        ("https" . "proxy.dmz.ace:3128")
        ("ftp" . "proxy.dmz.ace:3128")))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)


;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:server-args
;;       '("--log-level" "DEBUG"
;;         "--log-traceback"))
;; (setq jedi:complete-on-dot t)
;;
;; (defun my-python-hook ()
;;   (interactive)
;;   (define-key python-mode-map (kbd "RET") 'newline-and-indent))
;; (add-hook 'python-mode-hook 'my-python-hook)


;;(add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)
;; (setq py-python-command "/usr/bin/python3")
                                     ; optional

;; (defcustom python-autopep8-path (executable-find "autopep8")
;;   "autopep8 executable path."
;;   :group 'python
;;   :type 'string)

;; (defun python-autopep8 ()
;;   "Automatically formats Python code to conform to the PEP 8 style guide.
;; $ autopep8 --in-place --aggressive --aggressive <filename>"
;;   (interactive)
;;   (when (eq major-mode 'python-mode)
;;     (shell-command
;;      (format "%s --in-place --aggressive %s" python-autopep8-path
;;              (shell-quote-argument (buffer-file-name))))
;;     (revert-buffer t t t)))

;; (bind-key "C-c C-a" 'python-auto-format)

;; (eval-after-load 'python
;;   '(if python-autopep8-path
;;        (add-hook 'before-save-hook 'python-autopep8)))

(use-package org-roam-bibtex
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
              (("C-c n a" . orb-note-actions))))


(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(when (not package-archive-contents)
  (package-refresh-contents))


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)  ;load and activate packages, including auto-complete

(ac-config-default)

(global-auto-complete-mode t)
