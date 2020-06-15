;;; ob-latex-as-png.el --- Org-babel functions for latex-as-png evaluation  -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Musa Al-hassy

;; Author: Musa Al-hassy <alhassy@gmail.com>
;; Version: 1.0
;; Package-Requires: ((emacs "26.1") (org "9.1"))
;; Keywords: literate programming, reproducible research, org, convenience
;; URL: https://github.com/alhassy/ob-latex-as-png

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; An Org-babel “language” whose execution produces PNGs from LaTeX snippets;
;; useful for shipping *arbitrary* LaTeX results in HTML.
;;
;; Below is an example of producing a nice diagram;
;; type it in and C-c C-c to obtain the png.
;; Then C-c C-x C-v to inline the resulting image.
;;
;;    #+PROPERTY: header-args:latex-as-png :results raw value replace
;;    #+begin_src latex-as-png :file example :resolution 150
;;    \smartdiagram[bubble diagram]{Emacs,Org-mode, \LaTeX, Pretty Images, HTML}
;;    #+end_src
;;
;;  Hint: Add the following lines to your init to *always* re-display inline images.
;;
;;    ;; Always redisplay images after C-c C-c (org-ctrl-c-ctrl-c)
;;    (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;;; Requirements:

;; Users must have PDFLATEX and PDFTOPPM command line tools.

;;; Code:
(require 'ob)
(require 'ob-ref)
(require 'ob-comint)
(require 'ob-eval)

;; Treat (colour) this “language” as LaTeX
(add-to-list 'org-src-lang-modes '("latex-as-png" . latex))

;; Default header arguments
(defvar org-babel-default-header-args:latex-as-png
  '((:results . "raw value replace")))

;; This is the main function which is called to evaluate a code
;; block.
(defvar ob-latex-as-png-packages '(smartdiagram)
  "The LaTeX packages to be used when executing latex-as-png source blocks.")

(defun org-babel-execute:latex-as-png (body params)
  "Execute a block of latex-as-png code with org-babel.
This function is called by `org-babel-execute-src-block'

Such blocks have two notable header arguments, PARAMS, both optional:
:file       ⇒ The name of the resulting PNG; any extensions are ignored.
:resolution ⇒ The resolution; by default 150.

Argument BODY is the source text of the block."
  (message "executing latex-as-png source code block")
  (let* ((processed-params (org-babel-process-params params))

         ;; Augment usepackage declarations and front-matter for LaTeX
         (full-body (concat "\n\\documentclass[crop]{standalone}\n"
                            (mapconcat (apply-partially #'format
                                                        "\\usepackage{%s}")
                                       ob-latex-as-png-packages
                                       "\n")
                            "\n\\begin{document}\n"
                            body
                            "\n\\end{document}\n"))

         ;; Get resolution argument
         (resolution (or (cdr (assoc :resolution processed-params)) 150))

         ;; The target file
         (file.ext (or (cdr (assoc :file processed-params)) "ob-latex-as-png.pdf"))
         (file (car (split-string file.ext "\\.")))
         (pdflatex (format "pdflatex -shell-escape -jobname=%s " file)))

    ;; ⟨0⟩ Generate the PDF
    (org-babel-eval pdflatex full-body)

    (dolist (cmd (list
                 ;; ⟨1⟩ Transform it to a PNG
                  (format "pdftoppm %s.pdf -png %s -r %s" file file resolution)
                 ;; ⟨2⟩ for some reason pdftoppm produces “OUTPUTNAME-1.png”
                 ;; so I rename away the extra “-1”.
                 (format "mv %s-1.png %s.png" file file)
                 ;; ⟨3⟩ Remove the new PDF
                 (format "rm %s.pdf" file)))
      ;; ⟨4⟩ Handle filenames with spaces or other characters that the shell
      ;; might get caught on; then actually send everything to the shell
      ;; (shell-command  (shell-quote-argument cmd))
      ;; No! This breaks the call to pdftoppm, not sure why.
      (shell-command cmd))

    ;; ⟨5⟩ Return the a raw link to the PNG
    (format "[[file:%s.png]]" file)))

(provide 'ob-latex-as-png)
;;; ob-latex-as-png.el ends here
