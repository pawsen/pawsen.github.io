;; set current dir (where top-level .dir-locals.el is found) to hugo-base-dir
;; https://stackoverflow.com/a/64020275/1121523
((nil . (
         ;;(eval . (set (make-local-variable 'hugo-directory)
         ;;              (locate-dominating-file default-directory
         ;;                                      ".dir-locals.el")))
         ;; (eval . (message "hugo-base-dir set to `%s'." hugo-directory))
         ;; (org-hugo-base-dir . hugo-directory)

         ;; org-hugo-base-dir should either be absolute or relative to the org-files.
         ;; Right now it is set to relative to the org-files
         (org-hugo-base-dir . "../")
         (org-hugo-auto-set-lastmod . t)
         (org-hugo-section . "post/")
         )))

;; ((nil . ((eval . (set (make-local-variable 'my-project-path)
;;                       (file-name-directory
;;                        (let ((d (dir-locals-find-file ".")))
;;                          (if (stringp d) d (car d))))))
;;          (eval . (message "Project directory set to `%s'." my-project-path))
;;          )))
;;((nil . ((eval . (set (make-local-variable 'my-project-path)
;;                      (file-name-directory
;;                       (let ((d (dir-locals-find-file ".")))
;;                         (if (stringp d) d (car d))))))
;;         (cmake-ide-project-dir . my-project-path)
;;         (eval . (setq cmake-ide-build-dir (concat my-project-path "build")))
;;         )))

;; https://emacs.stackexchange.com/a/72418/20989
((org-mode . ((eval . (
              (setq org-hugo-external-file-extensions-allowed-for-copying
                    (append org-hugo-external-file-extensions-allowed-for-copying
                            '("wav" "raw" "epub")))
              )))))
