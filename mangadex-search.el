(require 'request)
(require 'json)
(require 'cl-lib)
(require 'widget)

(defconst mangadex-tag-mode-opts '("AND" "OR"))

(defconst mangadex-status-opts '("ongoing" "completed" "hiatus" "cancelled"))

(defconst mangadex-demographic-opts '("shounen" "shoujo" "josei" "seinen" "none"))

(defconst mangadex-content-rating-opts '("safe" "suggestive" "erotica" "pornographic"))

(defvar search-title)
(defvar search-status)
(defvar search-demographic)
(defvar search-content-rating)

(defun mangadex-search-buffer ()
  (get-buffer-create "*mangadex-search*"))

(defun mangadex-search-mode ()
  (interactive)
  (switch-to-buffer (mangadex-search-buffer))
  (kill-all-local-variables)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  ;(use-local-map mangadex-search-mode-map)
  (setq major-mode 'mangadex-search-mode
	mode-name "mangadex-search"
	truncate-lines t
	desktop-save-buffer #'mangadex-search-desktop-save)
  (make-local-variable 'search-title)
  (make-local-variable 'search-status)
  (make-local-variable 'search-demographic)
  (make-local-variable 'search-content-rating)
  (widget-insert "Search Mangadex\n\n")
  (setq search-title (widget-create 'editable-field
				    :size 30
				    :format "Title: %v " ""))
  (widget-insert "\t")
  (setq search-year (widget-create 'editable-field
				   :size 5
				   :valid-regexp "^[:digit:]{4}$"
				   :format "Year: %v " ""))
  (widget-insert "\n\nUpdate Status\n ")
  (setq search-status (widget-create 'checklist
				     :entry-format "%b %v "
				     '(item "ongoing") '(item "completed") '(item "hiatus") '(item "cancelled")
				     ;TODO: figure out how to do this properly
				     ;(mapcar (lambda (x) (cons 'item (list x))) mangadex-status-opts)
				     ))
  (widget-insert "\n\nDemographic\n ")
  (setq search-demographic (widget-create 'checklist
				     :entry-format "%b %v "
				     '(item "shounen") '(item "shoujo") '(item "josei") '(item "seinen") '(item "none")
				     ))
  (widget-insert "\n\nContent Rating\n ")
  (setq search-content-rating (widget-create 'checklist
				     :entry-format "%b %v "
				     '(item "safe") '(item "suggestive") '(item "erotica") '(item "pornographic")
				     ))
  (widget-insert "\n")
  (widget-create 'push-button "Search" :notify (lambda (&rest ignore) (mangadex-search-manga)))
  (use-local-map widget-keymap)
  (widget-setup)
  (run-mode-hooks 'mangadex-search-mode-hooks))

(defun mangadex-search-manga ()
  (message "TODO"))

(provide 'mangadex-search)
