(package-initialize)
(menu-bar-mode 0)
(if (display-graphic-p)
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode 0)))
(tooltip-mode 0)
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))

(setq initial-scratch-message "")
(setq initial-major-mode 'lisp-mode)

(setq load-prefer-newer t)
(setq inhibit-startup-screen t)
(setq user-full-name "Lucas Meyers"
      user-mail-address "meye2058@umn.edu")
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

(setq use-package-verbose t)
(setq use-package-always-demand t)

(use-package diminish
  :ensure t)

(use-package magit
  :ensure t
  :bind ("<f8>" . magit-status))

(use-package hydra
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (enable-recursive-mini-buffers t)
  :bind (("C-c C-r" . ivy-resume)))

(use-package ivy-hydra
  :ensure t
  :after (hydra ivy))

(use-package swiper
  :ensure t
  :after (ivy)
  :bind (("C-s" . swiper)))

(use-package counsel
  :ensure t
  :after (ivy swiper)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-find-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate))
  :config
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package company
  :ensure t
  :init (global-company-mode)
  :custom
  (company-minimum-prefix-length 3)
  (company-tooltip-align-annotations t))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode 1)
  :bind (("C-z" . undo)
         ("C-S-z" . undo-tree-redo)))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package reftex
  :custom
  (reftex-plug-into-AUCTeX t))

(use-package latex
  :ensure auctex
  :after reftex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-PDF-mode t)
  :config
  (add-hook 'LaTeX-mode-hook
            '(lambda () (define-key LaTeX-mode-map (kbd "$") 'self-insert-command)))
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        (lambda () (latex-unicode-simplified))
                        nil
                        t)))
  :bind (("RET" . newline-and-indent)
         :map LaTeX-mode-map
         ("RET" . newline-and-indent)))

(use-package semantic
  :ensure nil
  :config
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
  (semantic-mode 1))

(use-package semantic/bovine/gcc
  :ensure nil
  :after (semantic))

(use-package latex-pretty-symbols)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package ispell
  :ensure t
  :custom
  (ispell-program-name "ispell")
  (ispell-dictionary "american")
  :bind ("<f7>" . ispell))

(use-package flyspell
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-buffer))

(use-package elpy
  :ensure t
  :config
  (elpy-enable))

(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t)
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package cargo
  :ensure t
  :config
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(use-package racer
  :ensure t
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode))

(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook #'flycheck-haskell-setup))

(use-package haskell-interactive-mode
  :after (haskell-mode))

(use-package haskell-process
  :after (haskell-interactive-mode)
  :config
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))

(use-package company-ghci
  :ensure t
  :after (company haskell-mode haskell-interactive-mode)
  :config
  (push 'company-ghci company-backends)
  (add-hook 'haskell-mode-hook 'company-mode)
  (add-hook 'haskell-interactive-mode-hook 'company-mode))

(use-package flycheck
  :ensure t
  :config
  :init (global-flycheck-mode))

(use-package projectile
  :ensure t
  :after flycheck)

(use-package org
  :ensure t
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)))

(use-package deft
  :ensure t
  :bind (("C-c d" . deft))
  :custom
  (deft-directory (expand-file-name "~/Dropbox/deft"))
  (deft-extensions (list "org" "tex" "txt"))
  (deft-default-extension "org")
  (deft-text-mode 'org-mode)
  (deft-use-filename-as-title t)
  (deft-use-filter-string-for-filename t)
  (deft-auto-save-interval 0)
  (deft-recursive t))

(use-package moe-theme
  :ensure t
  :config
  (moe-dark))

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 2
      kept-old-versions 2
      version-control t)
