(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)
(package-install 'ox-hugo)
(package-install 'org-roam)

(require 'ox-hugo)
(require 'org-roam)

(defun collect-backlinks-string (backend)
  (when (org-roam-node-at-point)
    (goto-char (point-max))
    ;; Add a new header for the references
    (let* ((backlinks (org-roam-backlinks-get (org-roam-node-at-point))))
      (when (> (length backlinks) 0)
        (insert "\n\n* Backlinks\n")
        (dolist (backlink backlinks)
          (message (concat "backlink: " (org-roam-node-title (org-roam-backlink-source-node backlink))))
          (let* ((source-node (org-roam-backlink-source-node backlink))
                 (node-file (org-roam-node-file source-node))
                 (file-name (file-name-nondirectory node-file))
                 (title (org-roam-node-title source-node)))
            (insert
             (format "- [[./%s][%s]]\n" file-name title))))))))

(add-hook 'org-export-before-processing-functions #'collect-backlinks-string)

(defun org-hugo--tag-processing-fn-remove-tags-maybe (tags-list info)
  "Remove user-specified tags/categories.
See `org-hugo-tag-processing-functions' for more info."
  ;; Use tag/category string (including @ prefix) exactly as used in Org file.
  (let ((tags-categories-to-be-removed '("DONE" "ATTACH"))) ;"my_tag" "@my_cat"
    (cl-remove-if (lambda (tag_or_cat)
                    (member tag_or_cat tags-categories-to-be-removed))
                  tags-list)))
(add-to-list 'org-hugo-tag-processing-functions
             #'org-hugo--tag-processing-fn-remove-tags-maybe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copy images to the hugo bundle dir
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List the images to copy in the properties drawer using link-img key.
;; :PROPERTIES:
;; :link-img:  some/folder/some*.jpg
;; :link-img:  some/folder/other*.jpg
;; :END:
(defvar my/ox-hugo-copy-verbose t
  "When non-nil, print diagnostics while copying :link-img: files.")

(defun my/ox-hugo--all-link-img-values (&optional subtree-only)
  "Return a list of all :link-img: property values in current subtree."
  (let* ((parse (if subtree-only
                    (org-element-parse-buffer 'element)
                  (org-element-parse-buffer)))
         (vals
          (org-element-map parse 'node-property
            (lambda (np)
              (when (string-equal (downcase (org-element-property :key np))
                                  "link-img")
                (string-trim (org-element-property :value np))))
            nil nil t)))
    (when my/ox-hugo-copy-verbose
      (message "[ox-hugo] link-img patterns: %S" vals))
    vals))

(defun my/ox-hugo-copy-link-img (outfile)
  "Copy all wildcards in :link-img: into the bundle dir of OUTFILE."
  (when (and outfile (file-exists-p outfile))
    (let* ((bundle (file-name-directory outfile))
           (base   (file-name-directory (buffer-file-name))))
      (dolist (pat (my/ox-hugo--all-link-img-values))
        (let* ((abs   (expand-file-name pat base))
               (files (file-expand-wildcards abs t)))
          (when my/ox-hugo-copy-verbose
            (message "[ox-hugo] %s ⇒ %d match(s)" abs (length files)))
          (dolist (src files)
            (let ((dest (expand-file-name (file-name-nondirectory src) bundle)))
              (when my/ox-hugo-copy-verbose
                (message "[ox-hugo] copy %s → %s" src dest))
              (copy-file src dest :ok-if-already-exists t))))))))

(defun my/ox-hugo-copy-wim-advice (orig &rest args)
  "Around-advice: run ORIG, then copy :link-img: files."
  (let ((outfile (apply orig args)))  ; run the real exporter
    (my/ox-hugo-copy-link-img outfile)
    outfile))

(with-eval-after-load 'ox-hugo
  (advice-add 'org-hugo-export-wim-to-md :around
              #'my/ox-hugo-copy-wim-advice))

(defun export-org-roam-files ()
  "Exports Org-Roam files to Hugo markdown."
  (interactive)

  ;; These are needed because .dir-locals.el is not loaded in batch mode
  ;; org-hugo-base-dir should either be absolute or relative to the org-files.
  ;; Right now it is set to relative to the org-files
  (setq org-hugo-base-dir "../")
  (setq org-hugo-section "notes/")
  ;; dont fail on export if a link is broken, just make it visible in the exported file
  ;; https://jeffkreeftmeijer.com/org-export-with-broken-links/
  (setq org-export-with-broken-links 'mark)

  ;; extend the list of file extentions that gets copied to the public/ox-hugo dir
  ;; default is
  ;; ("jpg" "jpeg" "tiff" "png" "svg" "gif" "bmp" "mp4" "pdf" "odt" "doc" "ppt" "xls"
  ;; "docx" "pptx" "xlsx")
  (setq org-hugo-external-file-extensions-allowed-for-copying
        (append org-hugo-external-file-extensions-allowed-for-copying
                '("wav" "raw" "epub" "webp" "py" "mp3" "tgz" "stl")))

  (message "org-hugo-external-file-extensions-allowed-for-copying are '%s'"
           org-hugo-external-file-extensions-allowed-for-copying)

  ;; "Sets up org's attachment system."
  ;; see doom emacs org-attch initialization
  (setq
   org-attach-store-link-p 'attached     ; store link after attaching files
   org-attach-use-inheritance t ; inherit properties from parent nodes
   org-attach-id-dir (expand-file-name ".attach/" default-directory))
  ;; no need to set the org-directory
  ;; (setq-default org-attach-id-dir (expand-file-name ".attach/" org-directory))

  (message "default-directory is '%s'" default-directory)
  (message "org-attach-id-dir set to '%s'" org-attach-id-dir)
  (message "org-hugo-base-dir is '%s'" org-hugo-base-dir)

  (let ((org-id-extra-files (directory-files-recursively default-directory "notes")))
    (dolist (f (append (file-expand-wildcards "org/about.org")
                       (file-expand-wildcards "org/diary/*.org")
                       (file-expand-wildcards "org/fleeting/*.org")
                       (file-expand-wildcards "org/index/*.org")
                       (file-expand-wildcards "org/literature/*.org")
                       (file-expand-wildcards "org/permanent/*.org")
                       (file-expand-wildcards "org/structure/*.org")
                       (file-expand-wildcards "notes/*.org")
                       (file-expand-wildcards "org/poem/*.org")
                       ))
      (with-current-buffer (find-file f)
        (org-hugo-export-wim-to-md)))))
