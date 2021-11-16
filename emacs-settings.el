(load-theme 'dracula t)

(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))

(setq sml/theme 'powerline)
(sml/setup)

(require 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key [f8] 'neotree-toggle)

;; (ac-config-default)

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

