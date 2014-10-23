;;; ===================================
;;; Evil mode - Emacs + Vim keybindings
;;; ===================================
(require 'evil)
(require 'evil-leader)

(setq 
 evil-want-C-w-delete nil
 evil-want-C-w-in-emacs-state nil
 evil-ex-complete-emacs-commands t
 evil-want-fine-undo t
 evil-search-module 'evil-search
 evil-magic 'very-magic)

(setq-default
 evil-symbol-word-search t)

(evil-mode +1)
(global-evil-leader-mode +1)
(setq evil-leader/leader "," evil-leader/in-all-states t)

(evil-set-initial-state 'diff-mode 'motion)
(evil-set-initial-state 'backups-mode 'insert)
(evil-set-initial-state 'erc-mode 'emacs)
(evil-set-initial-state 'git-commit-mode 'insert)
(evil-set-initial-state 'backup-walker-mode 'motion)
(evil-set-initial-state 'package-menu-mode 'motion)

(define-key evil-normal-state-map (kbd "<down>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<up>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<down>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<up>") 'evil-previous-visual-line)

(key-chord-define evil-insert-state-map  "jj" 'evil-normal-state)
(key-chord-define evil-replace-state-map "jj" 'evil-normal-state)
(key-chord-define evil-emacs-state-map   "jj" 'evil-normal-state)

(key-chord-define evil-insert-state-map  "kk" 'evil-normal-state)
(key-chord-define evil-replace-state-map "kk" 'evil-normal-state)
(key-chord-define evil-emacs-state-map   "kk" 'evil-normal-state)

(key-chord-define evil-insert-state-map ";'" 'evil-ex)
(key-chord-define evil-emacs-state-map ";'" 'evil-ex)

(global-set-key (kbd "C-<backspace>") 'evil-delete-backward-word)

(key-chord-define evil-normal-state-map " l" 'evil-ace-jump-line-mode)
(key-chord-define evil-normal-state-map " n" 'ace-jump-char-N-lines)
(key-chord-define evil-normal-state-map " b" 'ace-jump-buffer)
(key-chord-define evil-normal-state-map " c" 'evil-ace-jump-char-mode)
(key-chord-define evil-normal-state-map " t" 'evil-ace-jump-char-to-mode)


(defun isearch-exit-chord-worker (&optional arg)
  (interactive "p")
  (execute-kbd-macro (kbd "<backspace> <return>")))

(defun isearch-exit-chord (arg)
  (interactive "p")
  (isearch-printing-char)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (run-at-time 0.3 nil 'keyboard-quit)
  (condition-case e
    (smartrep-read-event-loop
      '(("j" . isearch-exit-chord-worker)
         ("k" . isearch-exit-chord-worker)))
    (quit nil)))

(define-key isearch-mode-map "j" 'isearch-exit-chord)
(define-key isearch-mode-map "k" 'isearch-exit-chord)

;; This function builds a repeatable version of its argument COMMAND.
(defun repeat-command (command)
  "Repeat COMMAND."
  (interactive)
  (let ((repeat-previous-repeated-command command)
         (last-repeatable-command 'repeat))
    (repeat nil)))


(define-key evil-normal-state-map (kbd "C-SPC")
  '(lambda () (interactive)
     (evil-insert-state)
     (execute-kbd-macro (kbd "C-SPC"))))

(define-key evil-normal-state-map (kbd "C-RET")
  '(lambda ()
     (interactive)
     (evil-insert-state)
     (cua-set-rectangle-mark)))

(define-key evil-insert-state-map (kbd "C-e") 'evil-end-of-visual-line)
(setq evil-replace-state-cursor '("#884444" box))

(defun evil-open-below-normal (arg)
  (interactive "p")
  (evil-open-below arg)
  (evil-normal-state)
  (message ""))

(defun evil-open-above-normal (arg)
  (interactive "p")
  (evil-open-above arg)
  (evil-normal-state)
  (message ""))

(define-key evil-normal-state-map (kbd "[ <SPC>") 'evil-open-above-normal)
(define-key evil-normal-state-map (kbd "] <SPC>") 'evil-open-below-normal)

(define-key evil-normal-state-map (kbd "[ e") 'drag-stuff-up)
(define-key evil-normal-state-map (kbd "] e") 'drag-stuff-down)

(define-key evil-normal-state-map (kbd "[ w") 'drag-stuff-left)
(define-key evil-normal-state-map (kbd "] w") 'drag-stuff-right)

(define-key evil-insert-state-map (kbd "C-j") 'evil-normal-state)
(define-key evil-emacs-state-map (kbd "C-j") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-j") 'evil-normal-state)
(define-key evil-replace-state-map (kbd "C-j") 'evil-normal-state)

(defun evil-open-paragraph-full (arg)
  (interactive "p")
  (evil-open-above-normal arg)
  (evil-open-below arg)
  (keyboard-quit))

(defun evil-open-paragraph-empty (arg)
  (interactive "p")
  (evil-open-below arg)
  (evil-previous-line arg)
  (indent-according-to-mode)
  (keyboard-quit))

(defun evil-open-paragraph (arg)
  (interactive "p")
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (run-at-time 0.3 nil 'keyboard-quit)
  (let ((blank-line (string-match "^[[:space:]]*$"
                      (buffer-substring-no-properties
                        (line-beginning-position)
                        (line-end-position)))))
    (evil-open-below arg)
    (run-hooks 'post-command-hook)
    (if blank-line
      (condition-case e
        (smartrep-read-event-loop
          '(("o" . evil-open-paragraph-empty)))
        (quit nil))
      (condition-case e
        (smartrep-read-event-loop
          '(("o" . evil-open-paragraph-full)))
        (quit nil)))))

(define-key evil-normal-state-map "o" 'evil-open-paragraph)

(defun evil-yank-to-end-of-line ()
  (interactive)
  (evil-yank (point) (point-at-eol)))

(define-key evil-normal-state-map "Y" 'evil-yank-to-end-of-line)

(define-key evil-normal-state-map "U" 'undo-tree-visualize)
(define-key evil-normal-state-map (kbd "C-z")
  '(lambda ()
     (interactive)
     (message "use u.")))

(defun my-evil-smart-undo (&rest args)
  (interactive)
  (undo-tree-undo)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (condition-case e
    (smartrep-read-event-loop
      '(("r" . undo-tree-redo)
         ("u" . undo-tree-undo)))
    (quit nil)))

(defun my-evil-smart-redo (&rest args)
  (interactive)
  (undo-tree-redo)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (condition-case e
    (smartrep-read-event-loop
      '(("r" . undo-tree-redo)
         ("u" . undo-tree-undo)))
    (quit nil)))

(define-key evil-normal-state-map (kbd "u")   'my-evil-smart-undo)
(define-key evil-normal-state-map (kbd "C-r") 'my-evil-smart-redo)

(autoload 'evil-exchange        "evil-exchange")
(autoload 'evil-exchange-cancel "evil-exchange")

(define-key evil-normal-state-map "gx" 'evil-exchange)
(define-key evil-visual-state-map "gx" 'evil-exchange)
(define-key evil-normal-state-map "gX" 'evil-exchange-cancel)
(define-key evil-visual-state-map "gX" 'evil-exchange-cancel)
;;; Change modeline color by Evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                               (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
    (lambda ()
      (let ((color (cond ((minibufferp) default-color)
                     ((evil-normal-state-p) '("#586e75" . "#eee8d5"))
                     ((evil-emacs-state-p)  '("#859900" . "#eee8d5"))
                     ((evil-insert-state-p)  '("#93a1a1" . "#073642"))
                     ((evil-visual-state-p) '("#268bd2" . "#eee8d5"))
                     ((evil-replace-state-p) '("#dc322f" . "#eee8d5"))
                     (t '("grey70" . "black")))))
        (set-face-background 'mode-line (first color))
        (set-face-foreground 'mode-line (rest color))
        (set-face-foreground 'mode-line-buffer-id (rest color))))))

;; Evil surround, easily change surrounding chars
(require 'evil-surround)
(global-evil-surround-mode +1)

;; Esc quits from everything
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key evil-motion-state-map [escape] 'evil-normal-state)
(define-key evil-operator-state-map [escape] 'evil-normal-state)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(define-key evil-insert-state-map (kbd "C-M-z") 'evil-emacs-state)
(define-key evil-emacs-state-map (kbd "C-M-z") 'evil-insert-state)
(define-key evil-normal-state-map (kbd "C-M-z") 'evil-insert-state)
(define-key evil-motion-state-map (kbd "C-M-z") 'evil-insert-state)
(define-key evil-visual-state-map (kbd "C-M-z") 'evil-insert-state)

(defun my-normal-smart-undo (&rest args)
  (interactive)
  (undo-tree-undo)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (condition-case e
    (smartrep-read-event-loop
      '(("y" . undo-tree-redo)
         ("z" . undo-tree-undo)))
    (quit nil)))

(defun my-normal-smart-redo (&rest args)
  (interactive)
  (undo-tree-redo)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (condition-case e
    (smartrep-read-event-loop
      '(("y" . undo-tree-redo)
         ("z" . undo-tree-undo)))
    (quit nil)))

(define-key evil-insert-state-map (kbd "C-z") 'my-normal-smart-undo)
(define-key evil-emacs-state-map (kbd "C-z") 'my-normal-smart-undo)

(global-set-key (kbd "<remap> <undo-tree-redo>") 'my-normal-smart-redo)
(global-set-key (kbd "C-S-z") 'my-normal-smart-redo)

;; indent pasted regions in evil
(defadvice evil-paste-before (around auto-indent activate)
  (evil-indent (point) (+ (point) (length ad-do-it))))

(defadvice evil-paste-after (around auto-indent activate)
  (evil-indent (point) (+ (point) (length ad-do-it))))

