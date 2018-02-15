;;; pickle.el --- Major mode for editing cucumber gherkin files.  -*- lexical-binding: t -*-

;; Copyright (C) 2018 Matthew Carter <m@ahungry.com>

;; Author: Matthew Carter <m@ahungry.com>
;; Maintainer: Matthew Carter <m@ahungry.com>
;; URL: https://github.com/ahungry/pickle-mode
;; Version: 0.0.1
;; Date: 2018-02-15
;; Keywords: languages, cucumber, gherkin
;; Package-Requires: ((emacs "25.1") (cl-lib "0.6.1"))

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; The dart-mode that exists doesn't properly indent, so give this a try.
;;
;; Much of this mode is derived from the js.el package.
;;
;; General Remarks:
;;
;; XXX: This mode assumes that block comments are not nested inside block
;; XXX: comments
;;
;; Exported names start with "pickle-"; private names start with
;; "pickle--".

;;; Code:

(require 'cl-lib)

(defvar pickle-mode-hook nil)
(defvar pickle-mode-default-tab-width 2)

(defvar pickle-mode-compile-function
  (lambda (module-name)
    (cl-concatenate 'string "mmc --make " module-name))
  "Command that when given MODULE-NAME (hello.m module-name would be hello) will compile the mercury file.")

(defvar pickle-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    (define-key map (kbd "C-c C-c") 'pickle-mode-compile)
    (define-key map (kbd "C-c C-r") 'pickle-mode-runner)
    map)
  "Keymap for metal mercury major mode.")

(defconst pickle-mode-font-lock-keywords-1
  (list
   '(" \"\\(.*?\\)\" " . font-lock-variable-name-face)
   '("\\(When\\|Then\\|Given\\)" . font-lock-keyword-face)
   '("\\(\\w+\\)(" 1 font-lock-function-name-face)
   '("Feature: \\(.*\\)" 1 font-lock-variable-name-face)
   '("Scenario: \\(.*\\)" 1 font-lock-preprocessor-face)
   '("\\(.*?\\): " . font-lock-type-face)
   '(") is \\(\\w+\\)" 1 font-lock-preprocessor-face)
   ))

(defun pickle-mode ()
  "Major mode for editing mercury files."
  (interactive)
  (kill-all-local-variables)
  ;; (set-syntax-table pickle-mode-syntax-table)
  (use-local-map pickle-mode-map)
  (set (make-local-variable 'font-lock-defaults)
       '(pickle-mode-font-lock-keywords-1))
  ;; (set (make-local-variable 'indent-line-function)
  ;;      'pickle-mode-indent-line)
  (setq major-mode 'pickle-mode)
  (setq mode-name "pickle")
  (run-hooks 'pickle-mode-hook))

;;;###autoload
(progn
  (add-to-list 'auto-mode-alist '("\\.feature\\'" . pickle-mode))
  )

(provide 'pickle)

;;; pickle.el ends here
