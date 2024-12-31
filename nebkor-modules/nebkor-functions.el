(defun diff-and-set-modified-p ()
  "Diff the current buffer with its associated file and set buffer modified status."
  (let* ((tmpfile (diff-file-local-copy (current-buffer)))
         (cmd (format "diff -q '%s' '%s'" (buffer-file-name) tmpfile))
         (result (call-process-shell-command cmd nil nil)))
    (set-buffer-modified-p (not (zerop result)))))

(defun nebkor/kill-buffer ()
  (interactive)
  (diff-and-set-modified-p)
  (kill-buffer (current-buffer))
  )

(defun sother-window ()
  "shift-other-window"
  (interactive)
  (other-window -1)
  )

;;; From:
;;; https://fluca1978.github.io/2022/04/13/EmacsPgFormatter.html, with
;;; minor modifications to add the function to a `before-save-hook`
(defun pgformatter-on-region ()
  "A function to invoke pg_format as an external program."
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max)))
        (pgfrm (executable-find "pg_format")))
    (when pgfrm
      (let ((p (point)))
        (progn
          (shell-command-on-region b e pgfrm (current-buffer) 1)
          (goto-char p)
          ))
      )
    )
  )

(defun sql-format-buffer-on-save ()
  "When saving an SQL buffer, format it with pg_format."
  (add-hook 'before-save-hook #'pgformatter-on-region -10 t))

(defun nebkor-ksuidgen-p (orig-fn id)
  "Check if an ID is a valid ksuid, and if not, return whatever ORIG-FN does."
  (or (string-match (rx bol (= 27 alnum) eol) id)
      (orig-fn id)))

(defun nebkor-julid-p (orig-fn id)
  "Check if an ID is a valid Julid, and if not, return whatever ORIG-FN does."
  (or (string-match (rx bol (= 26 alnum) eol) id)
      (orig-fn id)))

(defun rotate-windows (arg)
  "Rotate your windows; use the prefix argument to rotate the other direction"
  (interactive "P")
  (if (not (> (count-windows) 1))
      (message "You can't rotate a single window!")
    (let* ((rotate-times (prefix-numeric-value arg))
           (direction (if (or (< rotate-times 0) (equal arg '(4)))
                          'reverse 'identity)))
      (dotimes (_ (abs rotate-times))
        (dotimes (i (- (count-windows) 1))
          (let* ((w1 (elt (funcall direction (window-list)) i))
                 (w2 (elt (funcall direction (window-list)) (+ i 1)))
                 (b1 (window-buffer w1))
                 (b2 (window-buffer w2))
                 (s1 (window-start w1))
                 (s2 (window-start w2))
                 (p1 (window-point w1))
                 (p2 (window-point w2)))
            (set-window-buffer-start-and-point w1 b2 s2 p2)
            (set-window-buffer-start-and-point w2 b1 s1 p1)))))))

(provide 'nebkor-functions)
