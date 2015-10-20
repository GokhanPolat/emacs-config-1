;; -*- lexical-binding: t -*-

(with-eval-after-load 'evil
  (eval-when-compile
    (with-demoted-errors "Load error: %s"
      (require 'evil)))

  (evil-define-key 'motion undo-tree-visualizer-mode-map (kbd "t")
    #'undo-tree-visualizer-toggle-timestamps)
  (evil-define-key 'motion  undo-tree-visualizer-mode-map (kbd "d")
    #'undo-tree-visualizer-toggle-diff))

(with-eval-after-load 'undo-tree
  (eval-when-compile
    (with-demoted-errors "Load error: %s"
      (require 'undo-tree)))

  (diminish 'undo-tree-mode " μ")
  (defalias 'redo #'undo-tree-redo)
  (defalias 'undo #'undo-tree-undo)

  ;; keep undo-tree from overriding C-x r
  (define-key undo-tree-map (kbd "C-x r u") nil)
  (define-key undo-tree-map (kbd "C-x r U") nil)
  (define-key undo-tree-map (kbd "C-x r") nil)

  (key-chord-define evil-emacs-state-map "uu" #'undo-tree-visualize)
  (key-chord-define evil-insert-state-map "uu" #'undo-tree-visualize)

  (define-key evil-visual-state-map "u" #'undo-tree-undo)

  (global-set-key (kbd "M-_") #'undo-tree-redo)
  (setq undo-tree-auto-save-history t)

  (add-to-list 'evil-overriding-maps '(undo-tree-visualizer-mode-map))

  ;; visual line wrapping breaks the 
  (add-hook 'undo-tree-visualizer-mode-hook
            (lambda ()
              (visual-line-mode -1)))

  (evil-define-key 'motion undo-tree-visualizer-mode-map
    "C-g" #'undo-tree-visualizer-quit)
  (evil-define-key 'motion undo-tree-visualizer-mode-map
    (kbd "<escape>") #'undo-tree-visualizer-quit)
  (evil-define-key 'motion undo-tree-visualizer-mode-map
    (kbd "<return>") #'undo-tree-visualizer-quit)
  (evil-define-key 'motion undo-tree-visualizer-mode-map
    (kbd "<up>") #'undo-tree-visualize-undo)
  (evil-define-key 'motion undo-tree-visualizer-mode-map
    (kbd "<down>") #'undo-tree-visualize-redo)

  ;; compress undo with xz
  (when (executable-find "xz")
    (defun nadvice/undo-tree-make-history-save-file-name (_ret)
      (let ((auto-save-file-name-transforms
             '((".*" "/home/pythonnut/.emacs.d/data/undo-backups/" t))))
        (concat (make-auto-save-file-name) ".undo.xz")))

    (defun nadvice/undo-tree-load-history (old-fun &rest args)
      (let ((jka-compr-verbose nil))
        (apply old-fun args)))

    (advice-add 'undo-tree-make-history-save-file-name
                :filter-return
                #'nadvice/undo-tree-make-history-save-file-name)
    (advice-add 'undo-tree-load-history
                :around
                #'nadvice/undo-tree-load-history))

  ;; Keep region when undoing in region
  (defun nadvice/undo-tree-undo (old-fun &rest args)
    (if (use-region-p)
        (let ((m (set-marker (make-marker) (mark)))
              (p (set-marker (make-marker) (point))))
          (apply old-fun args)
          (goto-char p)
          (set-mark m)
          (set-marker p nil)
          (set-marker m nil))
      (apply old-fun args)))

  (advice-add 'undo-tree-undo :around #'nadvice/undo-tree-undo))

(provide 'config-undo)
