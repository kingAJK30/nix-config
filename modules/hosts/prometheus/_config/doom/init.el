;;; init.el -*- lexical-binding: t; -*-
(doom!
 :input
 :completion
 (corfu +orderless)
 (vertico +icons)

 :ui
 doom
 dashboard
 hl-todo
 modeline
 ophints
 (popup +defaults)
 treemacs
 (vc-gutter +pretty)
 workspaces

 :editor
 (evil +everywhere)
 file-templates
 fold
 (format +onsave)
 snippets

 :emacs
 dired
 electric
 (ibuffer +icons)
 undo
 vc

 :term
 vterm

 :checkers
 syntax
 (spell +flyspell)

 :tools
 (eval +overlay)
 (debugger +lsp)
 llm
 lookup
 lsp
 magit
 make
 direnv
 tree-sitter

 :lang
 emacs-lisp
 (nix +lsp)
 (rust +lsp)
 (python +lsp)
 (lua +lsp)
 (web +lsp)
 (qt +qml)
 yaml

 :config
 (default +bindings +smartparens))
