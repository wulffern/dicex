
(add-to-list 'load-path (expand-file-name "~/elisp/"))

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)



;;---------------------------------------------------
;; Misc Options
;;---------------------------------------------------

(add-hook 'python-mode-hook
    (lambda ()
        (setq indent-tabs-mode nil)
        (infer-indentation-style)))



(setq ns-pop-up-frames 'nil)

(global-set-key "\C-xg" 'goto-line)

;; Don't make backup files
(setq make-backup-files nil)

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Enable wheelmouse support by default
(cond (window-system
       (mwheel-install)
       ))

;;Autochange lines
(setq initial-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda ()
         (turn-on-auto-fill)))


(setq-default ispell-program-name "/usr/bin/aspell")

(setq ns-pop-up-frames 'nil)

;;---------------------------------------------------
;; Header definition
;;---------------------------------------------------

(require 'auto-header)
(setq header-email-address user-mail-address)
(setq header-comment-strings
      (cons '(octave-mode . ("#" "" "###" "#")) header-comment-strings))
(setq header-comment-strings
      (cons '(spice-mode . ("*" "" "**" "*")) header-comment-strings))
(setq header-comment-strings
      (cons '(verilog-mode . ("//" "" "//" "=")) header-comment-strings))
(setq header-comment-strings
      (cons '(go-mode . ("//" "" "//" "=")) header-comment-strings))
(setq header-comment-strings
      (cons '(js2-mode . ("//" "" "//" "=")) header-comment-strings))
(setq header-comment-strings
      (cons '(javascript-mode . ("//" "" "//" "=")) header-comment-strings))
(setq header-comment-strings
      (cons '(xrdb-mode . ("!" "" "!!" "!")) header-comment-strings))
(setq header-comment-strings
      (cons '(perl-mode . ("#" "" "##" "#")) header-comment-strings))
(setq header-comment-strings
      (cons '(javascript-mode . ("//" "" "//" "=")) header-comment-strings))

(setq header-fields
      '(
        ("created" .     ("Created       : " (concat  (user-login-name)  " at "
                                                      (number-to-string (nth 5 (decode-time))) "-"
                                                      (number-to-string (nth 4 (decode-time))) "-"
                                                      (number-to-string (nth 3 (decode-time)))
                                                      ) ))
        ("copyr" .       (nil (concat "       Copyright (c) "
                                      (number-to-string (nth 5 (decode-time)))
                                      " NTNU, Norway "
                                      ) ))
        ("blank" .       (nil     (make-string (- header-line-width 3) (string-to-char header-comment-char))))
        ("modified" .    ("Modified      : " "$Author$ $Date$"))
        ("version" .    ("Version       : " "$Revision$ $HeadURL$"))
        ("description" . ("Description   : " " "))

 		("license" . (nil "\
 The MIT License (MIT)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the \"Software\"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 "))
;;        ("license" . (nil "\
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>."))
        ))

(setq header-field-list
      '(
        copyr
        blank
        created
		blank
		license
        )
      )



;;---------------------------------------------------
;; Indent the whole buffer
;;---------------------------------------------------
(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


;; Setup c++-mode
; style I want to use in c++ mode
(c-add-style "my-style"
	     '("stroustrup"
	       (indent-tabs-mode . nil)        ; use spaces rather than tabs
	       (c-basic-offset . 4)            ; indent by four spaces
	       (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
				   (brace-list-open . 0)
				   (statement-case-open . +)))))

;;---------------------------------------------------
;; Use cperl-mode as the default
;;---------------------------------------------------
;;; cperl-mode is preferred to perl-mode
;;; "Brevity is the soul of wit" <foo at acm.org>
(defalias 'perl-mode 'cperl-mode)

;;---------------------------------------------------
;; Setup matlab mode
;;---------------------------------------------------
(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)

(autoload 'javascript-mode "json" "Json mode." t)
(setq auto-mode-alist (cons '("\\.json\\'" . javascript-mode) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . javascript-mode))

(add-to-list 'auto-mode-alist '("\\.il\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ocn\\'" . emacs-lisp-mode))

;;---------------------------------------------------
;; Setup spice mode
;;---------------------------------------------------
(autoload 'spice-mode "spice-mode" "Spice/Layla Editing Mode" t)
(setq auto-mode-alist (append (list (cons "\\.sp$" 'spice-mode)
                                    (cons "\\.spi$" 'spice-mode)
                                    (cons "\\.par$" 'spice-mode)
                                    (cons "\\.nspice$" 'spice-mode)
                                    (cons "\\.cir$" 'spice-mode)
                                    (cons "\\.ckt$" 'spice-mode)
                                    (cons "\\.mod$" 'spice-mode)
                                    (cons "\\.cdl$" 'spice-mode)
                                    (cons "\\.chi$" 'spice-mode) ;eldo outpt
                                    (cons "\\.inp$" 'spice-mode)
                                    )
                              auto-mode-alist))
(normal-erase-is-backspace-mode 1)
