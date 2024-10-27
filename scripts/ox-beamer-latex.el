;; emacs init file for exporting a orgmode beamer presentation to pdf


(package-initialize)
(require 'org-install)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (python . t)
   (ruby . t)
   (gnuplot . t)
   (emacs-lisp . t)
   (C . t)
   (dot . t)))

(require 'ox-beamer)
(require 'ox-latex)

(setq org-export-allow-bind-keywords t)
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(add-to-list 'org-latex-packages-alist '("" "minted"))

(setq org-src-fontify-natively t)


;; ;; presentation.org
;; #+TITLE: Presentation
;; #+AUTHOR: Paw Møller <pawsen@gmail.com>
;; #+DATE: March 20, 2024
;; #+DESCRIPTION:
;; #+KEYWORDS:
;; #+LANGUAGE:  en
;; #+OPTIONS:   H:1 num:nil ^:{} toc:nil email:nil
;; #+LaTeX_CLASS_OPTIONS: [presentation]
;; #+BEAMER_HEADER: \usepackage{beamerthemeRedHat}
;; #+BIND: org-latex-title-command "\\begin{rhbg}\\maketitle\\end{rhbg}"
;; #+BEAMER_HEADER: \usepackage[utf8]{inputenc}
;; #+BEAMER_HEADER: \usepackage{setspace,amsfonts,calc,upquote,hyperref,graphicx}
;; #+BEAMER_HEADER: \usepackage{colortbl}
;; #+BEAMER_HEADER: \usepackage{tikz}
;; #+BEAMER_HEADER: \usepackage{pgfplots}
;; #+BEAMER_HEADER: \beamertemplatenavigationsymbolsempty
;; #+EXCLUDE_TAGS: noexport
;; #+PROPERTY:  header-args :eval no

;; * Agenda
;; - a bullet


;; ;; Makefile
;; IMGS=
;; DATA=

;; all: umassdpdk.pdf
;; 	echo Done

;; umassdpdk.pdf: $(IMGS) $(DATA) umassdpdk.org Makefile
;; 	emacs presenation.org --batch -l ox-beamer-latex.el. -f org-beamer-export-to-pdf
