
; (list-fontsets "DejaVu Sans-10")

; (message "%S" (font-family-list))

; (setq 'fonts (font-family-list))

; (mapc (lambda (font) (message "%s" font)) (font-family-list))

; (mapc 'message (font-family-list))

(setq max-specpdl-size 10000)
(setq max-lisp-eval-depth 10000)

; (defun steshaw-filter (condp xs)
;   (if (consp xs)
;     (let
;       ((hd (car xs)) (tl (cdr xs)))
;       (if (funcall condp hd) 
;         (cons hd (steshaw-filter 'condp tl))
;         (steshaw-filter 'condp tl)))
;     nil))

(defun string/ends-with (s ending)
  "return non-nil if string S ends with ENDING."
  (let ((elength (length ending)))
    (string= (substring s (- 0 elength)) ending)))

(defun string/starts-with (s arg)
  "returns non-nil if string S starts with ARG.  Else nil."
  (cond ((>= (length s) (length arg))
        (string-equal (substring s 0 (length arg)) arg))
        (t nil)))

(message "%s" (remove-if-not (lambda (e) (string/starts-with e "Menlo")) (font-family-list))) 

(print max-lisp-specpdl-size)
(print max-lisp-eval-depth)

(remove-if-not (lambda (x) (> x 2)) '(1 2 3))

