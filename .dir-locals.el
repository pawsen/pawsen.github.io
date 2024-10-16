((nil . ((org-hugo-base-dir . "~/git/org/")
         (org-hugo-auto-set-lastmod . t)
         (org-hugo-section . "post/")
         )))

;; https://emacs.stackexchange.com/a/72418/20989
((org-mode . ((eval . (
              (setq org-hugo-external-file-extensions-allowed-for-copying
                    (append org-hugo-external-file-extensions-allowed-for-copying
                            '("wav" "raw" "epub")))
              )))))
