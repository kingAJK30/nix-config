;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "KingAJK30"
      user-mail-address "86845258+kingAJK30@users.noreply.github.com")

(setq doom-theme 'doom-gruvbox)

(setq-default left-margin-width 1
              right-margin-width 1)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13))

(after! doom-modeline
  (setq doom-modeline-hud nil
        doom-modeline-window-width-limit 85
        doom-modeline-bar-width 3
        doom-modeline-major-mode-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project))

(setq display-line-numbers-type 'relative)

(use-package! lsp-ui
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point))

(after! highlight-indent-guides
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?│)
  (add-hook 'prog-mode-hook #'highlight-indent-guides-mode))
