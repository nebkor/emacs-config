;; stand-in
(global-set-key [C-tab] #'other-window)
(global-set-key [C-S-tab] #'sother-window)
(global-set-key [C-iso-lefttab] #'sother-window)
(global-set-key [f4] #'nebkor/kill-buffer)
(global-set-key [f7] 'revert-buffer)

(setq-default auto-fill-function 'do-auto-fill)
(setq-default fill-column 100)
(turn-on-auto-fill)
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))
(define-key icomplete-fido-mode-map (kbd "SPC") 'self-insert-command)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
(fset 'yes-or-no-p 'y-or-n-p)

(provide 'nebkor-personal)
