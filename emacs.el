;; Rememver where the cursor was last time.
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t) ;; activate it for all buffers
(require 'saveplace) ;; get the package

;; Move autosave and backup files to ~/.emacs-backup.
(defvar user-temporary-file-directory "~/.emacs-backup")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
            `(("." . ,user-temporary-file-directory)
                      (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
            (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Set bash script indentation to be 2 spaces.
(setq sh-basic-offset 2)
(setq sh-indentation 2)

(load "~/zhengconfigs/clang-format")

;;;;;;;;;;;;;;;;; isearch-forward-symbol-at-point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun copy-symbol-at-point ()
  "Copy the symbol found near point to the clipboard."
  (interactive)
  (let ((bounds (find-tag-default-bounds)))
    (cond
     (bounds
      (when (< (car bounds) (point))
	(goto-char (car bounds)))
      (kill-new
       (buffer-substring-no-properties (car bounds) (cdr bounds)))
      (message "%s copied to the clipboard!"
	       (buffer-substring-no-properties (car bounds) (cdr bounds))))
     (t
      (error "No symbol at point")))))


(defun isearch-forward-symbol-at-point ()
  "Do incremental search forward for a symbol found near point.
Like ordinary incremental search except that the symbol found at point
is added to the search string initially as a regexp surrounded
by symbol boundary constructs \\_< and \\_>.
See the command `isearch-forward-symbol' for more information."
  (interactive)
  (isearch-forward-symbol nil 1)
  (let ((bounds (find-tag-default-bounds)))
    (cond
     (bounds
      (when (< (car bounds) (point))
	(goto-char (car bounds)))
      (isearch-yank-string
       (buffer-substring-no-properties (car bounds) (cdr bounds))))
     (t
      (setq isearch-error "No symbol at point")
      (isearch-update)))))

(defun find-tag-default-bounds ()
  "Determine the boundaries of the default tag, based on text at point.
Return a cons cell with the beginning and end of the found tag.
If there is no plausible default, return nil."
  (let (from to bound)
    (when (or (progn
		;; Look at text around `point'.
		(save-excursion
		  (skip-syntax-backward "w_") (setq from (point)))
		(save-excursion
		  (skip-syntax-forward "w_") (setq to (point)))
		(> to from))
	      ;; Look between `line-beginning-position' and `point'.
	      (save-excursion
		(and (setq bound (line-beginning-position))
		     (skip-syntax-backward "^w_" bound)
		     (> (setq to (point)) bound)
		     (skip-syntax-backward "w_")
		     (setq from (point))))
	      ;; Look between `point' and `line-end-position'.
	      (save-excursion
		(and (setq bound (line-end-position))
		     (skip-syntax-forward "^w_" bound)
		     (< (setq from (point)) bound)
		     (skip-syntax-forward "w_")
		     (setq to (point)))))
      (cons from to))))

;;;;;;;;;;;; Indent to 4 spaces from the previous line's beginning ;;;;;;;;;;;;

(defun indent-4-spaces ()
  "Indent to 4 spaces from the previous line's beginning."
  (interactive)
  (forward-line -1)
  (back-to-indentation)
  (let ((indent-str (make-string (+ 4 (current-column)) ? )))
    (forward-line 1)
    (back-to-indentation)
    (delete-horizontal-space)
    (insert indent-str)))

(defun break-and-indent-4-spaces ()
  "Create a new line and indent to 4 spaces from the previous line's beginning"
  (interactive)
  (newline)
  (indent-4-spaces))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-z" 'eshell)
(global-set-key "\C-cb" 'bury-buffer)
(global-set-key "\C-c\C-f" 'font-lock-mode)
(global-set-key "\C-xp" 'repeat-complex-command)

(global-set-key "\ek" 'next-line)
(global-set-key "\ei" 'previous-line)
(global-set-key "\el" 'forward-char)
(global-set-key "\ej" 'backward-char)

(global-set-key "\e " 'switch-to-buffer)
;(global-set-key "\e " 'buffer-menu)
(global-set-key "\eo" 'other-window)
(global-set-key "\e0" 'ido-kill-buffer)
(global-set-key "\et"
 '(lambda () (interactive) (delete-other-windows) (split-window-right 81)))
;(global-set-key "\e0" 'delete-window)
;(global-set-key "\e1" 'delete-other-windows)
(global-set-key "\e5" 'query-replace-regexp)
(global-set-key "\ep" 'backward-paragraph)
(global-set-key "\en" 'forward-paragraph)
(global-set-key "\e]" 'delete-indentation)
(global-set-key "\eh" 'gid)
(global-set-key "\es" 'query-replace)
(global-set-key "\e{" 'shrink-window-horizontally)
(global-set-key "\e}" 'enlarge-window-horizontally)
(global-set-key "\e;" 'isearch-forward-symbol-at-point)
(global-set-key "\ea" 'back-to-indentation)
(global-set-key "\ee" 'move-end-of-line)
(global-set-key "\em" 'goto-line)
(global-set-key "\e." 'forward-sexp)
(global-set-key "\e," 'backward-sexp)
(global-set-key "\ec" 'copy-symbol-at-point)
(global-set-key "\ev" 'yank)
(global-set-key "\ez" 'undo)
(global-set-key "\en" 'scroll-up)
(global-set-key "\eu" 'scroll-down)
(global-set-key "\ey" 'clang-format-region)
(global-set-key "\e/" 'comment-region)
(global-set-key "\e'" 'uncomment-region)

(global-set-key (kbd "M-RET") 'break-and-indent-4-spaces)
(global-set-key (kbd "C-M-\\") 'indent-4-spaces)
(global-set-key (kbd "C-M-u") 'upcase-word)

;;;;;;;;;;;;;;;;;;;;;;;;; Modes for different languages ;;;;;;;;;;;;;;;;;;;;;;;

;; Add the load path for emacs
(add-to-list 'load-path "~/zhengconfigs")

;; c++ mode for .h file.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; spaces for tab in c++ mode.
(defun my-c++-mode-hook ()
  (setq-default indent-tabs-mode nil))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; Don't indent inside c++ namespace.
(c-set-offset 'innamespace 0)

;; cmake mode for emacs
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("CMakeLists\\.txt\\.otop\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

(autoload 'cmake-mode "cmake-mode" t)

;; golang mode for emacs
(require 'go-mode-autoloads)

;; protobuf mode for emacs
(setq auto-mode-alist
      (append
       '(("\\.proto\\'" . protobuf-mode))
       auto-mode-alist))
(autoload 'protobuf-mode "protobuf-mode" t)

;; power-shell mode for emacs
(setq auto-mode-alist
      (append
       '(("\\.ps1\\'" . powershell-mode))
       '(("\\.psm1\\'" . powershell-mode))
       auto-mode-alist))
(autoload 'powershell-mode "powershell-mode" t)

;; python hooks
(add-hook 'python-mode-hook
	  (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-q column width
(setq-default fill-column 79)

;; gid stuff
(autoload 'gid "idutils" nil t)

;; buffer-move
(load-library "buffer-move")
(defalias 'mr 'buf-move-right)
(defalias 'ml 'buf-move-left)

;; revert-buffer alias
(defalias 'rb 'revert-buffer)

;; delete-trainling-whitespace
(defalias 'dt 'delete-trailing-whitespace)

;(add-to-list 'default-frame-alist '(background-color . "#FEF49C"))

(setq line-number-mode t)
(setq column-number-mode t)

(require 'ido)
(ido-mode t)
(defun ido-ignore-non-user-except (name)
  "Ignore all non-user (a.k.a. *starred*) buffers except *ielm*."
  (and (string-match "^\*" name)))
(setq ido-ignore-buffers '("\\` " ido-ignore-non-user-except))

(setq recenter-positions '(top middle bottom))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Windows specific settings.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-face-attribute 'default nil :height 130)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'column-marker)
(add-hook 'c++-mode-hook (lambda () (interactive)(column-marker-3 79)))
(global-auto-revert-mode t)

;; Old unused stuff

;; Switch RET and LF. Makes <return> indent.
;(defvar tmp (global-key-binding "\C-m"))
;(global-set-key "\C-m" (global-key-binding "\C-j"))
;(global-set-key "\C-j" tmp)

;; Better buffer switch. M-k to switch buffer. Deprecated.
;;(iswitchb-mode 1)
;;(setq iswitchb-buffer-ignore '("^ " "*Completions*" "*Shell Command Output*"
;;			       "*Messages*" "Async Shell Command" "*scratch*"))

;; python-pylint.el
;(require 'compile)
;(require 'tramp)
;(load-library "python-pylint")
;(global-set-key (kbd "C-x y") 'python-pylint)

;; ;; meta-Enter on the IBM thinkpad in Arora 6 generates meta-return
;; ;; when in an x window, and meta-linefeed when a terminal
;; (global-set-key '[(meta return)]  'dabbrev-expand)
;; (global-set-key '[(meta linefeed)]  'dabbrev-expand)

;; ;; Make it so that "C-x h" in text mode views as HTML
;; ;; (by opening a web browser)
;; (add-hook 'text-mode-hook
;; 	  (lambda nil
;; 	    (local-set-key "\C-xh" 'browse-url-of-buffer)))

;; (when (featurep 'xemacs)
;;     (autoload 'filladapt-mode "filladapt" "A better way of indenting text")
;;       (add-hook 'text-mode-hook 'filladapt-mode))

;; ;; Assign F1-F4 to shells 1-4
;; (define-key global-map [f1] (lambda () (interactive) (ashell ?1)))
;; (define-key global-map [f2] (lambda () (interactive) (ashell ?2)))
;; (define-key global-map [f3] (lambda () (interactive) (ashell ?3)))
;; (define-key global-map [f4] (lambda () (interactive) (ashell ?4)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
