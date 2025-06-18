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
