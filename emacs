(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/haskell-mode/")

;; Regular ole bullshit
(require 'saveplace)
(setq-default save-place t)
(require 'uniquify)
(require 'ansi-color)
;; General broo haha!
(setq inhibit-startup-message t)
(transient-mark-mode t)
(menu-bar-mode -1)
(setq compilation-window-height 8)
(mouse-avoidance-mode 'jump)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode t)
(auto-compression-mode 1)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(setq case-fold-search t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode nil)
(setq font-lock-maximum-decoration t)
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(display-time)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; CUSTOM KEYS
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key [f2] (quote align-beginning-of-defun))
(global-set-key [f3] 'scroll-line-up)
(global-set-key [S-f8] 'nroff-fill-mode)
(global-set-key [f10] (quote align-end-of-defun))
(global-set-key [M-s] 'center-line)



(defun trim-trailing-whitespace ()
    (interactive)
      (save-excursion
           (beginning-of-buffer)
           (replace-regexp "[ ]+$" "" nil nil nil)))

;;  Colours
(add-to-list 'default-frame-alist '(background-color . "black"))
(add-to-list 'default-frame-alist '(foreground-color . "white"))
(add-to-list 'default-frame-alist '(cursor-color . "white"))
;; From emacs documentation: http://www.gnu.org/software/emacs/windows/faq4.html#font-lock
(when (fboundp 'global-font-lock-mode)
      ;; customize face attributes
      (setq font-lock-face-attributes
            ;; Symbol-for-Face Foreground Background Bold Italic Underline
            '((font-lock-builtin-face           "peru")
              (font-lock-comment-face           "gray35")
              (font-lock-comment-delimiter-face "gray40")
              (font-lock-constant-face          "plum2")
              ;;(font-lock-doc-face               "green")
              (font-lock-function-name-face     "#A8FF60")
              (font-lock-keyword-face           "#96CBFE")
              ;;(font-lock-negation-char-face     "white")
              (font-lock-preprocessor-face      "RoyalBlue")
              ;;(font-lock-regexp-grouping-backslash "bold white")
              ;;(font-lock-regexp-grouping-construct "bold white")
              (font-lock-string-face            "misty rose")
              (font-lock-type-face              "salmon")
              (font-lock-variable-name-face     "yellow")
              (font-lock-warning-face           "Light Red")
              )))

(custom-set-faces
 '(modeline ((t (:background "white" :foreground "grey5"))))
 '(mode-line-inactive ((t (:background "grey15" :foreground "grey50"))))
 '(modeline-buffer-id ((t (:background "steelblue3" :foreground "grey125"))))
 '(fringe ((t (:background "black"))))
 )
;; Turn off Bold for X


;; smart-compile
;; ref. http://homepage.mac.com/zenitani/elisp-j.html#smart-compile
(when (require 'smart-compile "smart-compile" t)
      (global-set-key "\C-c\C-c" 'smart-compile)
      (add-hook 'c-mode-common-hook
                (lambda () (local-set-key "\C-c\C-c" 'smart-compile)))
      (add-hook 'sh-mode-hook
                (lambda () (local-set-key "\C-c\C-c" 'smart-compile))))


;; Nuke whitespace
(defun my-delete-leading-whitespace (start end)
  "Delete whitespace at the beginning of each line in region."
  (interactive "*r")
  (save-excursion
   (if (not (bolp)) (forward-line 1))
   (delete-whitespace-rectangle (point) end nil)))
(global-set-key (kbd "C-x C-l") 'my-delete-leading-whitespace)

;; YASNIPPET
(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'yasnippet-bundle "~/.emacs.d/plugins/yasnippet-bundle.elc")


;; RFC Viewing Mod
(require 'rfcview "~/.emacs.d/rfcview.elc")
(setq auto-mode-alist
      (cons '("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode)
            auto-mode-alist))
(autoload 'rfcview-mode "rfcview" nil t)

;;Paredit
(autoload 'paredit-mode "paredit"
          "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'haskell-mode-hook (lambda () (paredit-mode +1)))
(setq skeleton-pair-alist
      '((?\( _ ?\))
        (?[  _ ?])
        (?{  _ ?})
        (?\" _ ?\")))
(defun autopairs-ret (arg)
  (interactive "P")
  (let (pair)
    (dolist (pair skeleton-pair-alist)
            (when (eq (char-after) (car (last pair)))
                  (save-excursion (newline-and-indent))))
    (newline arg)
    (indent-according-to-mode)))
(global-set-key (kbd "RET") 'autopairs-ret)

;;; **********************************************************************
;;; C
;;; **********************************************************************
(add-hook 'c-mode-common-hook
          (function
           (lambda ()
                                        ; use gnuish style, two spaces intent length etc.
             (c-set-style "gnu"))))
                                        ; "my" bsdish style, 4 spaces inedent, with "} else {" etc.
                                        ;(c-set-style "bsd")
                                        ;(setq c-hanging-braces-alist 
                                        ;  '((brace-list-open)
                                        ;    (substatement-open after) 
                                        ;    (block-close . c-snug-do-while))) 
                                        ;(setq c-cleanup-list  '(brace-else-brace scope-operator))

;;; **********************************************************************
;;; Scheme
;;; **********************************************************************
;;Gambit
(require 'gambit)
(require 'scheme-complete)
(autoload 'gambit-inferior-mode "gambit" "Hook Gambit mode into cmuscheme.")
(autoload 'gambit-mode "gambit" "Hook Gambit mode into scheme.")
(add-hook 'inferior-scheme-mode-hook (function gambit-inferior-mode))
(add-hook 'scheme-mode-hook (function gambit-mode))
(setq scheme-program-name "gsc -:d-")
;;Scheme Improved!
(autoload 'scheme-smart-complete "scheme-complete" nil t)
(eval-after-load 'scheme
                 '(define-key scheme-mode-map "\t" 'scheme-complete-or-indent))
;; Live Scheme documentation!
(autoload 'scheme-get-current-symbol-info "scheme-complete" nil t)
(add-hook 'scheme-mode-hook
          (lambda ()
            (make-local-variable 'eldoc-documentation-function)
            (setq eldoc-documentation-function 'scheme-get-current-symbol-info)
            (eldoc-mode)))
;;Smarter indentation
;;(setq lisp-indent-function 'scheme-smart-indent-function)



;;; **********************************************************************
;;; Haskel
;;; **********************************************************************
(load "~/.emacs.d/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook '(lambda () (capitalized-words-mode t)))
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(setq haskell-program-name "/usr/bin/ghci")

;;flyspell
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(add-hook 'message-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'c-mode-common-hook 'flyspell-prog-mode)
(add-hook 'tcl-mode-hook 'flyspell-prog-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;;wordcount
(defun wc ()
  (interactive)
  (message "Word count: %s" (how-many "\\w+" (point-min) (point-max))))

;; Ido
(require 'ido)
(ido-mode t)

;; Latex
(load "auctex.el" nil t t)
(require 'tex-mik)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; CUSTOM FACES
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-faces
 '(default ((t (:stipple nil :background "black" :foreground "gray90" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 88 :width normal :foundry "unknown" :family "Envy Code R" :antialias "none"))))
 '(bold ((t (:stipple nil :background "black" :foreground "gray90" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 88 :width normal :foundry "unknown" :family "Envy Code R" :antialias "none")))))
