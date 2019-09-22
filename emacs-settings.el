(load-theme 'dracula t)

(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))

(setq sml/theme 'powerline)
(sml/setup)

(require 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key [f8] 'neotree-toggle)

(ac-config-default)

(show-paren-mode 1)

(menu-bar-mode -1)
;;; init.el ends here
