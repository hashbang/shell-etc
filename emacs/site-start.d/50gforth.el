(autoload 'forth-mode "gforth" "Mode to edit gforth files" t)
(autoload 'forth-block-mode "gforth" "major mode for editing Forth block source files." t)
(autoload 'run-forth "gforth" "Run an inferior Forth process, input and output via buffer *forth*." t)

(setq auto-mode-alist
  (append '(("\\.fs$" . forth-mode)
    ("\\.4th$" . forth-mode)
    ("\\.fth$" . forth-mode)) auto-mode-alist))
