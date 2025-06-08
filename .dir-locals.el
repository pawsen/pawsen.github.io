;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

;; org-hugo-base-dir should either be absolute or relative to the org-files.
;; Right now it is set to relative to the org-files
((nil . ((org-hugo-base-dir . "../")
         (org-hugo-section . "notes/")))

 ;; https://emacs.stackexchange.com/a/72418/20989
 ;; only append values if they are not in the list
 (org-mode . ((eval . (dolist (ext '("wav" "raw" "epub" "webp" "zip"))
                        (unless (member ext org-hugo-external-file-extensions-allowed-for-copying)
                          (push ext org-hugo-external-file-extensions-allowed-for-copying))))))

 )
