(require 'package)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(dolist (archive '(("marmalade" . "http://marmalade-repo.org/packages/")
		   ("melpa-stable" . "http://stable.melpa.org/packages/")
                   ("melpa" . "http://melpa.org/packages/")))
  (add-to-list 'package-archives archive :append))

(add-to-list 'auto-mode-alist '("\\.cljs$" . clojure-mode))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defun my-packages-alist (archive packages)
  "take the archive name e.g. `melpa'
and a list of packages and create an associated list:
((package1 . archive) (package2 . archive) ...)"
  (let ((alist-of-packages ()))
    (dolist (package packages)
      (add-to-list 'alist-of-packages `(,package . ,archive)))
    alist-of-packages))

(when (boundp 'package-pinned-packages)
  (setq package-pinned-packages
	(my-packages-alist "melpa-stable"
			   '(clojure-mode cider))))

(defvar my-packages '(starter-kit
                      starter-kit-bindings
                      starter-kit-ruby
                      color-theme
                      textmate
                      expand-region
                      starter-kit-eshell
                      clojure-mode
                      cider
                      sass-mode
                      yaml-mode
                      rainbow-delimiters
                      company
                      json-mode
                      json-reformat
                      smartparens)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'clojure-mode-hook #'smartparens-strict-mode)

(global-company-mode)
(global-auto-revert-mode 1)

(load-theme 'manoj-dark t)

;; Textmate like fuzzy file locate and symbol lookup
;; Map to Super-t and Super-T. For the sake of Mac
;; terminal/iterm ssh user also mapped to Meta-t and
;; Meta-T
(textmate-mode)
(global-set-key (kbd "M-t") 'textmate-goto-file)
(global-set-key (kbd "M-T") 'textmate-goto-symbol)


;; Turn off ido flex complete if the complete list is
;; exceed 2000. Emacs will freeze up otherwise.
(defvar af-ido-flex-fuzzy-limit (* 2000 5))
(defadvice ido-set-matches-1 (around my-ido-set-matches-1 activate)
  (let ((ido-enable-flex-matching (< (* (length (ad-get-arg 0)) (length ido-text))
                                     af-ido-flex-fuzzy-limit)))
    ad-do-it))



;; Provid IntelliJ C-W style incremental selection base on sexp.
(global-set-key (kbd "M-+") 'er/expand-region)

;; Sort out the font size and background color
(custom-set-faces
 '(default ((t (:stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
