(add-to-list 'load-path "~/.elisp/") 
(add-to-list 'load-path "~/.elisp/rhtml")
(add-to-list 'load-path "~/.elisp/cucumber.el")
(require 'rhtml-mode)

(require 'lorem-ipsum)
;;(require 'php-mode)

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
(add-to-list 'auto-mode-alist '("\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile.lock$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.html.erb$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\.php$" . php-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.git/COMMIT_EDITMSG$" . diff-mode))


(require 'pabbrev)
(global-pabbrev-mode)

(add-to-list 'load-path
                  "~/.emacs.d/plugins/yasnippet")
    (require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)

(setq yas/root-directory '("~/.emacs.d/plugins/yasnippet/snippets"
                          "~/.emacs.d/mysnippets"))
(mapc 'yas/load-directory yas/root-directory)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js-indent-level 2)
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(standard-indent 2))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )



;; Navigate between windows by using shift and arrow-keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


(show-paren-mode 1)

;; Indent spaces
(setq-default indent-tabs-mode nil)

;; show line numbers 
(global-linum-mode 1)
(column-number-mode 1)
;; highlight current line
(add-hook 'text-mode-hook (lambda () (hl-line-mode 1)))


;; ruby tweaks, don't insert encoding-magic-comment by default
(setq-default ruby-insert-encoding-magic-comment nil)
(require 'ruby-electric)
(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode)))


;; Functions
(defun delete-current-file ()
  "Delete the file associated with the current buffer."
  (interactive)
  (let (currentFile)
    (setq currentFile (buffer-file-name))
    (when (yes-or-no-p (concat "Delete file: " currentFile))
      (kill-buffer (current-buffer))
      (delete-file currentFile)
      (message (concat "Deleted file: " currentFile))
      ) ) )
(put 'downcase-region 'disabled nil)


(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; Ergo emacs
(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "sv")

;; load ErgoEmacs keybinding
(load "~/.elisp/ergoemacs-keybindings/ergoemacs-mode")

;; turn on minor mode ergoemacs-mode
(ergoemacs-mode 1)

;; open keyboard shortcut image with F8 key
(global-set-key (kbd "<f6>")
  (lambda ()
    (interactive)
    (find-file "~/.elisp/ergonomic_emacs_layout_qwerty.png")))

;; removing arrow-keys
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))


;; adding mark-word correctly
(load "~/.elisp/ergoemacs-extensions")
(put 'upcase-region 'disabled nil)

;; Mappings
(global-set-key (kbd "M-9") 'kill-whole-line) 
(global-set-key (kbd "M-4") 'goto-line)
(global-set-key (kbd "M-.") 'repeat)
(global-set-key (kbd "C-t") 'transpose-chars)
(global-set-key (kbd "M-t") 'transpose-words)

;; Reclaim keys
(defun my-orgtbl-mode-hook () 
  (local-set-key ergoemacs-execute-extended-command-key 'execute-extended-command)
)
(add-hook 'orgtbl-mode-hook 'my-orgtbl-mode-hook)
   
 ;; Autoindent open-*-lines
    (defvar newline-and-indent t
      "Modify the behavior of the open-*-line functions to cause them to autoindent.")

;; Behave like vi's o command
    (defun open-next-line (arg)
      "Move to the next line and then opens a line.
    See also `newline-and-indent'."
      (interactive "p")
      (end-of-line)
      (open-line arg)
      (next-line 1)
      (when newline-and-indent
        (indent-according-to-mode)))
    (global-set-key (kbd "M-RET") 'open-next-line)
    ;; Behave like vi's O command
    (defun open-previous-line (arg)
      "Open a new line before the current one. 
     See also `newline-and-indent'."
      (interactive "p")
      (beginning-of-line)
      (open-line arg)
      (when newline-and-indent
        (indent-according-to-mode)))
    (global-set-key [M-S-return] 'open-previous-line)
 
;; Reformat XML
(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (xml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))
(defun rails-migrate-down ()
  "Transform the current line from add_column to remove_column statement"
  (interactive)
  (let (beg end)
    (beginning-of-line)
    (set 'beg (point))
    (end-of-line)
    (set 'end (point))
    (replace-string "add_column" "remove_column" nil beg end)
    (beginning-of-line)
    (search-forward ",")
    (search-forward ",")
    (backward-char)
    (set 'beg (point))
    (end-of-line)
    (set 'end (point))
    (kill-region beg end)
    (next-line)
    ))
;; Delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

