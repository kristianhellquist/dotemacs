; -*- mode: lisp -*-
(defun make-local-hook (&rest args))
(setq visible-bell t)
(setq make-backup-files nil)
(setq auto-save-default nil)

(add-to-list 'load-path "~/.elisp/")
(add-to-list 'load-path "~/.elisp/rhtml")
(add-to-list 'load-path "~/.elisp/cucumber.el")
(add-to-list 'load-path "~/icicles")
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
(add-to-list 'auto-mode-alist '("\.rhtml$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\.php$" . php-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\.git/COMMIT_EDITMSG$" . diff-mode))


(require 'pabbrev)
(global-pabbrev-mode)

(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)

(setq yas/root-directory '("~/.emacs.d/plugins/yasnippet/snippets"
                           "~/.emacs.d/mysnippets"))
(mapc 'yas/load-directory yas/root-directory)

;; Navigate between windows by using shift and arrow-keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


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

;; tabs
(add-hook 'ruby-mode-hook (lambda () (setq tab-width 2)))
(add-hook 'css-mode-hook (lambda () (setq tab-width 4)))
(add-hook 'javascript-mode-hook (lambda () (setq tab-width 4)))
(add-hook 'rhtml-mode-hook (lambda () 
                             (setq tab-width 4)
                             (setq sgml-basic-offset 4)))


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
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0123456789")
  (or (looking-at "[0123456789]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "C-c C-+") 'increment-number-at-point)

;; buffer and file manipulation
(load-library "steveyegge.el")
;;(icy-mode 1)

(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)

(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(add-to-list 'load-path "~/.emacs.d/vendor/")
(require 'peepopen)
(textmate-mode)

(ido-mode 0)
(server-start)


;; Ack
(autoload 'ack-same "full-ack" nil t)
(autoload 'ack "full-ack" nil t)
(autoload 'ack-find-same-file "full-ack" nil t)
(autoload 'ack-find-file "full-ack" nil t)

;; ace-jump
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; expand-region
(add-to-list 'load-path "~/.emacs.d/vendor/expand-region.el")
(require 'expand-region)
(global-set-key (kbd "C-c f") 'er/expand-region)
(global-set-key (kbd "C-c C-f") 'er/expand-region)

;;Easier typing
(defun mac-osx-editing-insert-at ()
  "Insert @ at point"
  (interactive)
  (insert-char ?@ 1)
)
(defun mac-osx-editing-insert-curly-left ()
  "Insert { at point"
  (interactive)
  (insert-char ?{ 1)
)
(defun mac-osx-editing-insert-curly-right ()
  "Insert } at point"
  (interactive)
  (insert-char ?} 1)
)

(defun mac-osx-editing-insert-bracket-left ()
  "Insert [ at point"
  (interactive)
  (insert-char ?[ 1)
)

(defun mac-osx-editing-insert-bracket-right ()
  "Insert ] at point"
  (interactive)
  (insert-char ?] 1)
)
(defun mac-osx-editing-insert-dollar ()
  "Insert $ at point"
  (interactive)
  (insert-char ?$ 1)
)
(defun mac-osx-editing-insert-pipe ()
  "Insert | at point"
  (interactive)
  (insert-char ?| 1)
)
(defun mac-osx-editing-insert-back-slash ()
  "Insert \ at point"
  (interactive)
  (insert-char ?\\ 1)
)

(global-set-key (kbd "M-2") 'mac-osx-editing-insert-at)
(global-set-key (kbd "M-4") 'mac-osx-editing-insert-dollar)
(global-set-key (kbd "M-7") 'mac-osx-editing-insert-pipe)
(global-set-key (kbd "M-/") 'mac-osx-editing-insert-back-slash)
(global-set-key (kbd "M-8") 'mac-osx-editing-insert-bracket-left)
(global-set-key (kbd "M-9") 'mac-osx-editing-insert-bracket-right)
(global-set-key (kbd "M-(") 'mac-osx-editing-insert-curly-left)
(global-set-key (kbd "M-)") 'mac-osx-editing-insert-curly-right)
