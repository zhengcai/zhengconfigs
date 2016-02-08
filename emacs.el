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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-z" 'eshell)
(global-set-key "\ek" 'switch-to-buffer)
(global-set-key "\eo" 'other-window)
(global-set-key "\e0" 'delete-window)
(global-set-key "\e1" 'delete-other-windows)
(global-set-key "\e2" 'split-window)
(global-set-key "\e3" 'split-window-horizontally)
(global-set-key "\e5" 'query-replace-regexp)
(global-set-key "\C-cb" 'bury-buffer)
(global-set-key "\C-c\C-f" 'font-lock-mode)
(global-set-key "\C-xp" 'repeat-complex-command)
(global-set-key "\ep" 'backward-paragraph)
(global-set-key "\en" 'forward-paragraph)
(global-set-key "\e]" 'delete-indentation)
(global-set-key "\ei" 'gid)
(global-set-key "\es" 'query-replace)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-q column width
(setq-default fill-column 79)

;; gid stuff
(autoload 'gid "idutils" nil t)

(add-to-list 'default-frame-alist '(background-color . "#FEF49C"))

(setq line-number-mode t)
(setq column-number-mode t)

(require 'ido)
(ido-mode t)
(defun ido-ignore-non-user-except (name)
  "Ignore all non-user (a.k.a. *starred*) buffers except *ielm*."
  (and (string-match "^\*" name)))
(setq ido-ignore-buffers '("\\` " ido-ignore-non-user-except))

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

;; meta-Enter on the IBM thinkpad in Arora 6 generates meta-return
;; when in an x window, and meta-linefeed when a terminal
(global-set-key '[(meta return)]  'dabbrev-expand)
(global-set-key '[(meta linefeed)]  'dabbrev-expand)

;; Make it so that "C-x h" in text mode views as HTML
;; (by opening a web browser)
(add-hook 'text-mode-hook
	  (lambda nil
	    (local-set-key "\C-xh" 'browse-url-of-buffer)))

(when (featurep 'xemacs)
    (autoload 'filladapt-mode "filladapt" "A better way of indenting text")
      (add-hook 'text-mode-hook 'filladapt-mode))

;; Assign F1-F4 to shells 1-4
(define-key global-map [f1] (lambda () (interactive) (ashell ?1)))
(define-key global-map [f2] (lambda () (interactive) (ashell ?2)))
(define-key global-map [f3] (lambda () (interactive) (ashell ?3)))
(define-key global-map [f4] (lambda () (interactive) (ashell ?4)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
