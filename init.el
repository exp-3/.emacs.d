;; --------------------------------------------------------------
;;; package.el
(require 'package)

;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))

;; 初期化
(package-initialize)

;; ------------------------------------------------------------------
;;general

;;テーマの設定
(setq custom-theme-directory "~/.emacs.d/themes/")
(load-theme 'ns-milk t)

;;背景色の設定
(set-face-background 'default "ivory")

;;スタートアップ非表示
(setq inhibit-startup-screen t)

;;ツールバー非表示
(tool-bar-mode -1)

;;メニューバー非表示
(menu-bar-mode -1)

;;スクロールバー非表示
(scroll-bar-mode -1)

;;行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)

;;行番号フォーマット
;;(setq linum-format "%4d")

;;括弧の中を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;;括弧の範囲色
(set-face-background 'show-paren-match-face "#ccc")

;;行末の空白を強調表示?
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#aaa")

;;タブの設定
(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)

;;フレームの透明度
(set-frame-parameter (selected-frame) 'alpha '(0.85))

;;C-Retで矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;M-↑←↓→でwindow移動
(windmove-default-keybindings 'meta)

;;セーブ時にtime stampを押す
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern nil)

;;新しくファイルを作成時にテンプレートを自動挿入
(add-hook 'find-file-hooks 'auto-insert)

;; ------------------------------------------------------------------------
;;modeline

;;モードラインに行番号表示
;;(line-number-mode t)

;;モードラインに列番号表示
;;(column-number-mode t)

;;モードラインに時刻表示
(display-time)

;;モードラインに行、列番号を表示
(line-number-mode 0)
(column-number-mode 0)
(size-indication-mode 0)
(setq mode-line-position
      '(:eval (format "Line:%%l/%d, Column:%%c"
                      (count-lines (point-max)
                                   (point-min)))))

;; -------------------------------------------------------------------
;; haskell-mode

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; --------------------------------------------------------------------
;; auto-complete

;; auto-complete有効化
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-show-menu 0)

;; --------------------------------------------------------------------
;; flycheck

(require 'flycheck)

;; flycheck有効化
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Define a c/c++ checker
(flycheck-define-checker my-c/c++-clang
  "A C/C++ checker using clang++."
  :command ("clang++-3.5"
            "-std=c++14"
            "-Wall"
            "-Wextra"
            "-Wconversion"
            "-fsyntax-only"
            "-fno-color-diagnostics" ; Do not include color codes in output
            "-fno-caret-diagnostics" ; Do not visually indicate the source
                                        ; location
            "-fno-diagnostics-show-option" ; Do not show the corresponding
                                        ; warning group
            ;(option-list "-I" flycheck-clang-include-path)
            source)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column
            ": warning: " (message) line-end)
   (error line-start (file-name) ":" line ":" column
          ": " (or "fatal error" "error") ": " (message) line-end))
  :modes (c-mode c++-mode))

(add-to-list 'flycheck-checkers 'my-c/c++-clang)

;; --------------------------------------------------------------------
;; smartparens

;; smartparens標準設定
(require 'smartparens-config)

;; smartparens有効化
(smartparens-global-mode t)

;; delete, backspaceで対応する括弧を自動削除
(define-key sp-keymap (kbd "M-<delete>") 'sp-unwrap-sexp)
(define-key sp-keymap (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)

(sp-pair "/*" "*/")
;;(sp-pair "<" ">")

;; --------------------------------------------------------------------
;; helm

;; helm
(require 'helm-config)

;; helm有効化
(helm-mode t)

;; 補完をタブで実行
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action)

;; ------------------------------------------------------------------------
;; expand-region

;; C-@で範囲を拡大
(global-set-key (kbd "C-@") 'er/expand-region)

;; C-M-@で範囲を縮小
(global-set-key (kbd "C-M-@") 'er/contract-region)

;; expand-region有効化
(transient-mark-mode t)

;; ------------------------------------------------------------------------
;; magit
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

;; ------------------------------------------------------------------------
;; helm-gtags

(require 'helm-gtags)

;;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)

;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-auto-update t))

;; key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))


;; ------------------------------------------------------------------------
(provide 'init)
;;; init.el ends here
