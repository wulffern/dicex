;;; spectre-mode.el --- major mode providing a spectre mode hook for fontification
;;; $Id: spectre-mode.el,v 1.25 2007/01/03 16:59:23 vdplasg Exp $

;; Emacs Lisp Archive Entry
;; Author: Wouter De Cock <wouter.decock@esat.kuleuven.ac.be>
;;         Geert Van der Plas <geert_vanderplas@email.com>
;; Keywords: spectre files, affirma
;; Filename: spectre-mode.el
;; Description: emacs lisp mode for editing spectre files.

;; Copyright (C) 2002-2003 Wouter De Cock & Geert A. M. Van der Plas

;; *insert GPL here*

;; INSTALL:
;; ========

;; byte compile spectre-mode.el to spectre-mode.elc (see `byte-compile-file')
;; put these two files in an arbitrary, but accesible directory
;; for example: $HOME/emacs, /usr/lib/emacs/site-lisp/ or 
;; /usr/local/lib/emacs/site-lisp/

;; If you chose a non-standard place to put the files add the following
;; line to your Emacs start-up file (`.emacs') or custom `site-start.el'
;; file (replace <directory-name> by the directory where you placed 
;; spectre-mode.el and spectre-mode.elc):
;; (setq load-path (cons (expand-file-name "<directory-name>") load-path))

;; To use spectre-mode, add either the following to your `.emacs' file. This
;; assumes that you will use the .sp, .cir, .ckt, .mod, ... extensions for 
;; your spice source decks and output files:
;; (autoload 'spectre-mode "spectre-mode" "Spectre Editing Mode" t)
;; (setq auto-mode-alist (append (list (cons "\\.scs$" 'spectre-mode)
;; 				       (cons "\\.inp$" 'spectre-mode))
;; 				 auto-mode-alist))

;; This mode requires the supporting packages ntlst-aux.el and ntlst-section.el
;; byte compile and install them in the same directory where you've put 
;; spectre-mode.el.

;; Optional:
;; - install active-file.el to get full file loading functionality (copy to
;;   a directory in the emacs load path).
;; - install speedbar.el (if not already in the distribution) to get speedbar
;;   functionality.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; COMMENTARY:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Most of the code of this mode was shamelessly stolen from eldo-mode
;; (Manu Rouat & GVdP) and spice-mode (Geert Van der Plas & Manu). Language
;; syntax was provided by Wouter, code and regexps written by Geert.

;; TODO/WISH LIST:

;; - highlight functions: syntax "builtin-function\\s-*(" and/or "name\\s-*("
;; - add a spectre menu ? 
;; - add include links as in eldo- and spice-mode ? active-file !
;; - automatic indentation "({", strings, comments ? First version is in !
;; - also make it work in emacs 20.7 ? Requires font-lock regexps to be 
;;   "shy" clean (using regexp-opt-depth !!)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ntlst-aux)

(defconst spectre-version "1.2.12 (3 January 2007)"
  "Current version of spectre mode.")

(defconst spectre-developer 
  "Wouter De Cock & Geert Van der Plas (<geert_vanderplas@email.com> & <wouter.decock@esat.kuleuven.ac.be>)"
  "Current developer/maintainer of spectre-mode.")

(defgroup spectre nil
  "Customizations for Spectre mode."
  :prefix "spectre-"
  :link  '(url-link "http://spice-mode.4t.com/")
;;  :link  '(url-link "http://www.esat.kuleuven.ac.be/~vdplas/emacs/")
  :group 'languages
  )

;;;###autoload
(defcustom spectre-mode-hook nil
  "*List of hook functions run by `spectre-mode' (see `run-hooks')."
  :type 'hook
  :group 'spectre)

(defcustom spectre-simulator-switches ""
  "Spectre command switches, used when simulating buffer with `compile-mode'"
  :type  'string
  :group 'spectre)

(defcustom spectre-indent-level 4
  "*Indentation of Spectre statements with respect to containing { block."
  :group 'spectre
  :type 'integer)

(require 'font-lock)

(defgroup spectre-faces nil
  "Customizations for highlighting."
  :group 'spectre)

;; We try to use usual/standard font-lock faces, plus a few specific ones:
(custom-add-to-group
 'spectre-faces 'font-lock-comment-face 'custom-face)
(custom-add-to-group
 'spectre-faces 'font-lock-keyword-face 'custom-face)
(custom-add-to-group
 'spectre-faces 'font-lock-type-face 'custom-face)
(custom-add-to-group
 'spectre-faces 'font-lock-function-name-face 'custom-face)
(custom-add-to-group
 'spectre-faces 'font-lock-variable-name-face 'custom-face)
(custom-add-to-group
 'spectre-faces 'font-lock-string-face 'custom-face)

(if (not ntlst-aux-running-xemacs)
    (custom-add-to-group
     'spectre-faces 'font-lock-warning-face 'custom-face)

  (defface spectre-warning-face
    '((((class grayscale) (background light)) (:foreground "DimGrey"))
      (((class grayscale) (background dark)) (:foreground "DarkGrey"))
      (((class color) (background light)) (:foreground "Red" :bold t))
      (((class color) (background dark)) (:foreground "Red" :bold t))
      (t (:bold t)))
    "Spectre mode face used for warnings."
    :group 'spectre-faces))

(defvar spectre-warning-face	 (if ntlst-aux-running-xemacs
				     'spectre-warning-face
				   'font-lock-warning-face)
  "Face name for builtin types.")

(if (not ntlst-aux-running-xemacs)
  (custom-add-to-group
   'spectre-faces 'font-lock-builtin-face 'custom-face)
  
  (defface spectre-builtin-face
    '((((class grayscale) (background light)) (:foreground "LightGray"))
      (((class grayscale) (background dark)) (:foreground "DimGray"))
      (((class color) (background light)) (:foreground "Orchid" :bold t))
      (((class color) (background dark)) (:foreground "LightBlue" :bold t))
      (t (:bold t)))
    "Spectre mode face used for builtin types."
    :group 'spectre-faces))

(defvar spectre-builtin-face	 (if ntlst-aux-running-xemacs
				     'spectre-builtin-face
				   'font-lock-builtin-face)
  "Face name for builtin types.")

(if (not ntlst-aux-running-xemacs)
    (custom-add-to-group
     'spectre-faces 'font-lock-doc-face 'custom-face)
  
  (defface spectre-doc-face
    '((((class color) (background light)) (:foreground "blue1"))
      (((class color) (background dark)) (:foreground "blue1"))
      (t (:inverse-video t)))
    "Face name to highlight spectrenetlist documentation."
    :group 'spectre-faces)
  )

(defvar spectre-doc-face	(if ntlst-aux-running-xemacs
				    'spectre-doc-face
				   'font-lock-doc-face)
  "Face name to highlight eldo netlist documentation.")

(defvar spectre-instance-name-face	 'spectre-instance-name-face
  "Face name for spectre instances.")

(defface spectre-instance-name-face
  '((((class grayscale) (background light)) (:foreground "LightGray" :bold t))
    (((class grayscale) (background dark)) (:foreground "DimGray" :bold t))
    (((class color) (background light)) (:foreground "ForestGreen" :bold t))
    (((class color) (background dark)) (:foreground "Yellow" :bold t))
    (t (:bold t)))
  "Spectre mode face used to highlight instances."
  :group 'spectre-faces)

(defvar spectre-model-name-face	 'spectre-model-name-face
  "Face name for spectre model names.")

(defface spectre-model-name-face
  '((((class grayscale) (background light)) (:foreground "LightGray"))
    (((class grayscale) (background dark)) (:foreground "DimGray"))
    (((class color) (background light)) (:foreground "Red3"))
    (((class color) (background dark)) (:foreground "LightSteelBlue"))
    (t (:bold t)))
  "Spectre mode face used to highlight instances."
  :group 'spectre-faces)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun spectre-about ()
  (interactive)
  (sit-for 0)
  (message "spectre-mode version %s, © %s" spectre-version spectre-developer))


(defconst spectre-name "\\(\\(?:[a-zA-Z_]\\|\\\\[^_a-zA-Z\n]\\)\\(?:\\sw\\|\\\\[^_a-zA-Z0-9\n]\\)*\\)" 
  "Regexp that describes a syntactically correct name")

(defconst spectre-line-break "\\(?:\\\\\n\\|\n+\\)?"
  "Regexp that matches a (possible) line break (\\\n)")

(defconst spectre-library-regexp   
  "^\\s-*\\(\\(ahdl_\\)?include\\)\\s-+"
  "Regexp that matches the beginning of library filename")

(defconst spectre-general-keywords ;; never use these as name:
  '("altergroup" "correlate" "else" "end" "ends" "export" "for"
    "function" "global" "ic" "if" "inline" "library" "local" "march"
    "model" "nodeset" "parameters" "paramset" "plot" "print" "real"
    "return" "save" "sens" "statistics" "subckt" "to" "truncate" "vary")
  "List of Spectre general keywords (spectre -help keywords | grep Keyword)")

(defconst spectre-prefix-keywords ;; keywords that are prefix
  '("ahdl_include" "endlibrary" "ends" "endsection" "export" "global"
    "ic" "include" "inline" "library" "model" "nodeset" "parameter"
    "parameters" "return" "save" "section" "simulator" "subckt" )
  "List of Spectre prefix keywords")

(defconst spectre-postfix-keywords ;; keywords that are postfix
  '("paramset" "ac" "alter" "altergroup" "check" "dc" "info"
    "montecarlo" "noise" "options" "pac" "pdisto" "pnoise" "pss" "pxf"
    "set" "shell" "sp" "sweep" "tdr" "tran" "xf" )
  "List of Spectre prefix keywords")

(defconst spectre-constant-keywords
  '("M_1_PI" "M_2_PI" "M_2_SQRTPI" "M_DEGPERRAD" "M_E" "M_LN10" "M_LN2"
    "M_LOG10E" "M_LOG2E" "M_PI" "M_PI_2" "M_PI_4" "M_SQRT1_2" "M_SQRT2"
    "M_TWO_PI" "P_C" "P_CELSIUS0" "P_EPS0" "P_H" "P_K" "P_Q" "P_U0")
  "List of constants (spectre -help keywords | grep Constant)")

(defconst spectre-function-keywords
  '("abs" "acos" "acosh" "asin" "asinh" "atan" "atan2" "atanh" "ceil"
    "cos" "cosh" "exp" "floor" "hypot" "int" "log" "log10" "max" "min"
    "pow" "sin" "sinh" "sqrt" "tan" "tanh")
  "List of functions (spectre -help keywords | grep Function)")

(defconst spectre-master-keywords
  '("a2d" "bjt" "bjt301" "bjt500" "bjt503" "bsim1" "bsim2" "bsim3"
    "bsim3v3" "btasoi" "capacitor" "cccs" "ccvs" "cktrom" "core" "d2a"
    "delay" "dio500" "diode" "ekv" "fourier" "gaas" "hbt" "hvmos"
    "inductor" "intcap" "iprobe" "isource" "jfet" "juncap" "misnan" "mos0"
    "mos1" "mos2" "mos3" "mos15" "mos30" "mos705" "mos902" "mos903"
    "mos3002" "msline" "mutual_inductor" "nodcap" "node" "nport"
    "paramtest" "pcccs" "pccvs" "phy_res" "port" "pvccs" "pvcvs"
    "quantity" "rdiff" "relay" "resistor" "scccs" "sccvs" "svccs" "svcvs"
    "switch" "tline" "tom2" "transformer" "vbic" "vccs" "vcvs" "vsource"
    "winding" "zcccs" "zccvs" "zvccs" "zvcvs")
  "List of Spectre builtin models keywords")

(defconst spectre-master-keywords-regexp
  (regexp-opt spectre-master-keywords)
  "master keywords regexp")

(defconst spectre-master-keywords-regexp-depth
  (regexp-opt-depth spectre-master-keywords-regexp)
  "master keywords regexp depth")

(defconst spectre-master-name
  (concat "\\(\\(" spectre-master-keywords-regexp "\\)\\|\\(" spectre-name "\\)\\)")
  "master name")

(defconst spectre-model-keywords ;; these can be masters or names
  '(
   "npn" "pnp" "nmos" "pmos" "pch" "nch"
   )
  "List of Spectre model keywords")

(defconst spectre-instance-regexp
  (concat "^\\s-*" spectre-name
;;	  "\\(\\([ \t]+(?[ \t]*[^ /*:(=\t\n][^ :(=\t\n/]*\\|[ \t]*\\(\n?\\([*]\\|//\\|;;\\).*\\)?\\(\\\\\n\\|\n[+]\\)\\)*)?\\s-*\\)" 
	  "\\(\\([ \t(]+[ \t]*[^ /*:(=\t\n\\][^ :(=\t\n/]*\\|[ \t]*\\(\n?\\([*]\\|//\\|;;\\).*\\)?\\(\\\\\n\\|\n[+]\\)\\)*)?\\s-+\\)" 
	  spectre-master-name
;;	  "\\<" spectre-master-name "\\>"
	  "\\(\\s-*\n\\|\\s-+[^=\n]\\)"
	  )
  "Instance matching regexp")

(defconst spectre-postfix-keywords-regexp
  (regexp-opt spectre-postfix-keywords)
  "postfix keywords regexp")

(defconst spectre-postfix-keywords-regexp-depth
  (regexp-opt-depth spectre-postfix-keywords-regexp)
  "postfix keywords regexp depth")

;; (defconst spectre-postfix-regexp
;;   (concat "^\\s-*" spectre-name
;; 	  "\\(\\([ \t]+(?[ \t]*[^ /*:(=\t\n][^ :(=\t\n/]*\\|[ \t]*\\(\n?\\([*]\\|//\\|;;\\).*\\)?\\(\\\\\n\\|\n[+]\\)\\)*)?\\s-*\\)" 
;; 	  "\\<\\(" spectre-postfix-keywords-regexp "\\)\\>"
;; 	  "\\(\\s-*\n\\|\\s-+[^=\n]\\)"
;; 	  )
;;   "Postfix statement matching regexp")

(defconst spectre-postfix-regexp
  (concat "^\\s-*" spectre-name
	  "\\(\\([ \t]+(?[ \t]*[^ /*:(=\t\n][^ :(=\t\n/]*\\|[ \t]*\\(\n?\\([*]\\|//\\|;;\\).*\\)?\\(\\\\\n\\|\n[+]\\)\\)\\{0,20\\})?\\s-*\\)" 
	  "\\<\\(" spectre-postfix-keywords-regexp "\\)\\>"
	  "\\(\\s-*\n\\|\\s-+[^=\n]\\)"
	  )
  "Postfix statement matching regexp")

(defconst spectre-scale-factors
  '("T" "G" "M" "K" "k" "_" "%" "c" "m" "u" "n" "p" "f" "a")
  "list of scale factors in spectre, different from standard spice !")

(defconst spectre-prefix-regexp
  (concat "\\<\\(" (regexp-opt spectre-prefix-keywords) "\\)\\>")
  "Prefix keyword regexp")

(defun spectre-match-no-prefix-keyword-regexp (limit re)
  "match complicated regexps not starting with prefix keyword"
  (let (pos found)
    (setq found nil)
    (setq pos 
	  (re-search-forward 
	   re
	   limit 'end)) ;
    (while (and pos
		(not found))
      (goto-char (match-beginning 1))
      (if (save-match-data (looking-at spectre-prefix-regexp))

	  (progn 
	    (goto-char pos)
	    (setq pos (re-search-forward 
		       re
		       limit 'end)))
	(progn
	  (goto-char pos)
	  (setq found t))))
    found))

;; instance name matcher
(defun spectre-match-instance (limit)
  "match instance statement"
  (spectre-match-no-prefix-keyword-regexp limit spectre-instance-regexp))

(defconst spectre-net-name-regexp
  (concat 
   "\\([ \t]+\\|\\s-*\\(\n[+]\\|\\\\\n\\)\\s-*\\)\\(\\(" 
   spectre-master-keywords-regexp
   "\\)\\|\\([^ /*;:=\t\n\\][^ :(=\t\n\\]*\\)\\)\\(\\s-*[\\]?\n\\|\\s-+[^=\n]\\)")
  "Net regexp")

(defconst spectre-instance-name-regexp
  (concat "^\\s-*" spectre-name)
  "Instance regexp")

(defun spectre-match-instance-tryout (limit) ;; much slower than regexp, but more accurate
  "match instance statement"
  (let ((result nil) match-start 
	(instance-name spectre-instance-name-regexp)
	(net-name spectre-net-name-regexp))
    (while 
	(and (not result)
	     (re-search-forward instance-name limit 'end)) ;; should be checked ?
      (goto-char (match-beginning 1))
      (if (save-match-data (looking-at spectre-prefix-regexp))
	  (progn
	    ;; (message "Ignoring %s" (match-string 1))
	    (goto-char (match-end 1))
	    )
	(setq match-start (match-data))
	;;(message "match-start is %s" match-start)
	(goto-char (match-end 1))
	(while 
	    (or 
	     (and (looking-at net-name)
		  (progn 
		    ;;(message "matching %s, %s" (match-string 3) (match-string 4))
		    (goto-char (match-end 3))
		    (setq result t)))
	     (save-match-data 
	       (and 
		(looking-at "\\(\\([ \t]+\\|\\s-*\n\\s-*\\)\\(?://\\|;;\\|[*]\\).*\\)")
		(progn
		  (goto-char (match-end 1))
		  t)))
	     )
	  nil)))
    (when result (set-match-data 
		  (append (list (car match-start) (car (cdr (match-data)))) 
			  (cdr (cdr match-start)) (cdr (cdr (match-data))))))
    ;;(when result (message "Matched %s[%d]" (match-string 3) (match-end 3)))
    (when result (when (< limit (match-end 4)) (setq result nil)))
    result))

;; other statement matcher
(defun spectre-match-postfix-statement (limit)
  "match postfix statement"
  (spectre-match-no-prefix-keyword-regexp limit spectre-postfix-regexp))

(defconst spectre-font-lock-keywords-1
  (list

   ;; docs - lines starting with ';;' are ignored by spectre ?
   '("\\s-*;;.*$" 0 spectre-doc-face)

   ;; comments - lines starting with '*' are ignored by spectre
   '("^\\s-*\\*.*$" 0 font-lock-comment-face t) ;; * spectre: lines are also commented out

   ;; all general keywords
   (list
    (concat
     "\\<\\("
     (regexp-opt spectre-general-keywords)
     "\\)\\>" )
    '(0 font-lock-keyword-face))
   
   ;; subckt, ends and global statement
   (list   
    (concat
     "^\\s-*"
     "\\(\\(inline\\s-+\\)?subckt\\|ends\\|global\\)"
     "\\s-+" spectre-name "\\>")
    '(1 font-lock-keyword-face)
    '(3 font-lock-function-name-face nil t))

   ;; model statement
   (list   
    (concat
     "^\\s-*"
     "model"
     "\\s-+" spectre-name "\\s-+" 
     spectre-master-name "\\>")
    '(1 font-lock-function-name-face)
    '(3 spectre-builtin-face nil t)
    '(4 spectre-model-name-face nil t))

   ;; assignments (xx=zz) 
   '("\\(\\<\\w*\\(\\s(\\w*\\s)\\)*\\)\\s-*=" 1 font-lock-variable-name-face)
	    
   ;; labels (num:) 
   '("\\([0-9]+\\)\\s-*:" 1 font-lock-type-face)
	    
   ;; include....
   (list
    (concat spectre-library-regexp "\"\\([^\"\n]+\\)\"" )
    '(1 font-lock-keyword-face)   
    '(3 font-lock-string-face nil t))

   ;; all prefix keywords
   (list
    (concat
     "^\\s-*\\<\\("
     (regexp-opt spectre-prefix-keywords)
     "\\)\\>" )
    '(0 font-lock-keyword-face))

   ;; all postfix keywords
;;   (list
;;    (concat
;;     "\\<\\("
;;     (regexp-opt spectre-postfix-keywords)
;;     "\\)\\>" )
;;    '(0 font-lock-keyword-face))
   (list 'spectre-match-postfix-statement
    '(1 font-lock-function-name-face)
    '(7 font-lock-keyword-face))

   ;; instances
;;   (list 'spectre-match-instance
;;    '(1 spectre-instance-name-face)
;;    '(6 spectre-builtin-face nil t)
;;    '(7 spectre-model-name-face nil t))
   (list 'spectre-match-instance
	 '(1 spectre-instance-name-face)
	 '(8 spectre-builtin-face nil t)
	 ;; emacs 20 compatibility
	 (list (+ 9 spectre-master-keywords-regexp-depth) 
	       spectre-model-name-face nil t))
   
   ;; constants
   (list
    (concat "\\<\\(" (regexp-opt spectre-constant-keywords) "\\)\\>")
    '(1 font-lock-constant-face))

   ;; changelog entries
   (list
    "^//\\s-+\\([A-Z].*[0-9]\\)\\s-+\\([a-zA-Z].*\\)<\\(.*@.*\\)>$"
    '(1 font-lock-string-face t)
    '(2 font-lock-type-face t)
    '(3 font-lock-variable-name-face t))

   )
  "Regexp describing fontification syntax of Spectre keywords"
)

(defconst spectre-font-lock-keywords-2
  (append spectre-font-lock-keywords-1
   (eval-when-compile
     (list
      ;; \ continuation check
      ;; '("\\(\\\\\\)\n" 1 font-lock-keyword-face) ; OK
      '("[^\\]\\(\\\\\\)\\s-+[\n]" 1 'font-lock-warning-face) ; not OK !
      
      ;; scale factors or is this overkill ? BTW, they're different from spice !!
      ;; first catch erronous scale factors:
      (list (concat "[0-9.][eE][-+]?[0-9]+\\(" 
		    (regexp-opt spectre-scale-factors)
		    "\\)") 1 'font-lock-warning-face) ; not OK !
     ;; then highlight remaining good ones
      (list "[0-9.]\\([eE]\\)[-+]?[0-9]+\\>" 1 'font-lock-type-face) ; OK !
      (list (concat 
	     "\\<[-+]?[0-9.]+\\(\\(" 
	     (regexp-opt spectre-scale-factors)
	     "\\)[a-zA-Z]*\\)\\>") 
	    '(2 font-lock-type-face))
      ;; then highlight remaining bad ones
      (list "\\<[-+]?[0-9.]+\\([a-zA-Z]\\)" '(1 font-lock-warning-face))
      )
     )
   )
  )

(defvar spectre-font-lock-keywords spectre-font-lock-keywords-1
  "Default expressions to highlight in Spectre modes.")

;;------------------------------------------------------------
;; netlist section interface
;;------------------------------------------------------------
(condition-case ()
    (require 'ntlst-section)
  (error nil))
(when (featurep 'ntlst-section)
  (defgroup spectre-section nil
    "Customizations for sections."
    :group 'spectre)
  
  ;; sections (entirely different implementation but sections idea has
  ;; been taken from eldo-mode.el)
;;;###autoload
  (defcustom spectre-section-alist
    '(
      ;; Libraries
      ("Libraries"     "LIBRARIES"              nil) ; 
      ;; Netlist
      ("Netlist"       "NETLIST"                nil) ;   
      ;; Main Circuit
      ("Main Circuit"  "MAIN CIRCUIT"           nil) ;   
      ;; Options	     
      ("Options"       "SIMULATION OPTIONS"     nil) ;
      ;; Supplies	     
      ("Supplies"      "SUPPLIES/REFERENCES"    nil) ;
      ;; Input Signals
      ("Input Signals" "INPUT SIGNALS"          nil) ;
      ;; DC Analysis
      ("DC Analysis"   "DC ANALYSIS"            nil) ;
      ;; AC Analysis
      ("AC Analysis"   "AC ANALYSIS"            nil) ;
      ;; Transient Analysis
      ("Transient Analysis" "TRANSIENT ANALYSIS" nil) ;
    ;;; Add your site-local spectre sections here:
      ;; 
      )
    "*List of valid sections in a Spectre file and their options.
Each list entry specifies the following items for a section:
Section:
  Section Name     : name used in to select/create find section, make this 
                     name short and descriptive.
  Section String   : string used in file to start section (usually all 
                     uppercase variant of name). 
  Extra switches   : extra switches for a section, unspecified for now."
    :type '(repeat (list :tag "Section" :indent 2
			 (string :tag "Section Name        ")
			 (string :tag "Section String      ")
			 (sexp   :tag "Extra Switches (nil)")))
    ;;  :set (lambda (variable value)
    ;;         (spectre-custom-set variable value
    ;;			   'spectre-keywords-init
    ;;			   'spectre-font-lock-init
    ;;			   'spectre-menu-init
    ;;			   'spectre-imenu-init
    ;;			   'spectre-update-existing-buffers))
    :group 'spectre-section)
  
  (defun spectre-ntlst-section-init ()
    "Initialize ntlst-section-defaults in local buffer"
    (set (make-local-variable 'ntlst-section-defaults)
	 (list 'spectre-section-alist "^\\s-*\\(?://\\|;;\\|\\*\\)\\s-*" "//" nil t))
    (ntlst-section-set-defaults))

  )


;; compile wrapper
(defun spectre-compile ()
  "spectre wrapper function for compile."
  (interactive)
  (unless buffer-file-name
    (error 
     "You have to save buffer into a file before running a simulator on it"))
  (setq compile-command 
	(concat 
	 "spectre " spectre-simulator-switches " "
	 (file-name-nondirectory buffer-file-name)
	 ))
  (call-interactively 'compile nil))

;;------------------------------------------------------------
;; Spectre-mode menu (using `easy-menu.el')
;;------------------------------------------------------------

(defun spectre-create-mode-menu ()
  "Create ELDO Mode menu."
  (append
   '("Spectre")
   (list 
    ["Comment Region"		comment-region (mark)]
    ["Uncomment Region"	spectre-uncomment-region (mark)]
    "--"
    ["Fontify..."		font-lock-fontify-buffer t])
   (when (fboundp 'ntlst-section-add-changelog-entry)
     (list 
      ["Add Changelog Entry"    ntlst-section-add-changelog-entry (not buffer-read-only)]))
   (when (featurep 'active-file)
     (list 
      ["Load include/lib files"	active-file-load-include-files t]  
      ["Same but recursively"	active-file-load-include-files-recursively t]
      ["Unload all other spectre files" active-file-unload-other-files (fboundp 'active-file-unload-other-files)]))
   (append 
    (list 
    ;;    "--"
    ;;    ["Search .subckt def"	spectre-search-subckt t]
    ;;    ["Add Changelog Entry"	spectre-add-changelog-entry t]
    ;;    )
    "------"
    '("Simulate"
      ["Run Spectre"		spectre-compile  t]
      ["Quit simulation"		kill-compilation  t]
      )
    "------")
    (when (featurep 'ntlst-section)
      (ntlst-section-menu-alist))
    (list 
     (append
      '("Settings")
      (list
       ["Customize..."		(customize-browse 'spectre) t]
       ["Spectre Faces"	        (customize-group  'spectre-faces) t]
       (ntlst-aux-speedbar-menu-entry)))
     "------"
     ["About Spectre-Mode"		spectre-about t]))
   )
  )

(defvar spectre-menu-list nil
  "Spectre Mode menu.")

(defun spectre-update-mode-menu ()
  "Update Spectre mode menu."
  (interactive)
  (easy-menu-remove spectre-menu-list) ; for XEmacs
  (setq spectre-menu-list (spectre-create-mode-menu))
  (easy-menu-add spectre-menu-list)	; for XEmacs
  (easy-menu-define spectre-menu spectre-mode-map
		    "Menu keymap for Spectre Mode." spectre-menu-list))

;;------------------------------------------------------------
;; Spectre mode syntax table
;;------------------------------------------------------------

(defvar spectre-mode-syntax-table nil
  "Syntax table used in spectre-mode buffers.")

(if spectre-mode-syntax-table
    ()
  (setq spectre-mode-syntax-table (make-syntax-table))
  ;; Give CR the same syntax as newline, for selective-display
  (modify-syntax-entry ?$  "w"  spectre-mode-syntax-table)
  (modify-syntax-entry ?!  "w"  spectre-mode-syntax-table)
  (modify-syntax-entry ?\;  "w"  spectre-mode-syntax-table)
  (modify-syntax-entry ?\" "\"" spectre-mode-syntax-table) 
  (modify-syntax-entry ?_  "w"  spectre-mode-syntax-table) ;; was "_"
  (modify-syntax-entry ?@  "w"  spectre-mode-syntax-table)
  (if ntlst-aux-running-xemacs
      (modify-syntax-entry ?/  ". 1456" spectre-mode-syntax-table) ; xemacs
    (modify-syntax-entry ?/  ". 124b" spectre-mode-syntax-table)) ; emacs
  (modify-syntax-entry ?*  ". 23" spectre-mode-syntax-table) ; not < !!!!
  (modify-syntax-entry ?\^m "> b" spectre-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" spectre-mode-syntax-table) ;; 
  )


;;------------------------------------------------------------
;; imenu expression
;;------------------------------------------------------------

(defvar spectre-imenu-generic-expression
  (list
   (list
    "Sections"   
    (concat "^\\s-*section\\s-+" spectre-name "\\>")
    1)
   (list
    "Models"   
    (concat "^\\s-*model\\s-+" spectre-name "\\>")
    1)
   (list 
    nil ; "Subckts"
    (concat "^\\s-*\\(inline\\s-+\\)?subckt\\s-+" spectre-name "\\>")
    2)
  )
  "Imenu generic expression for Spectre Mode. See `imenu-generic-expression'."
)

;; ======================================================================
;; indentation

(defun spectre-indent-line ()
  "Indent line function for spectre mode."
  (interactive "P")
  ;;(interactive)
  (let (state beg shift-amt closing-brace 
	      (indent 0 ) (pos (- (point-max) (point))))
    (beginning-of-line)
    (setq closing-brace (looking-at "\\s-*}"))
    (setq beg (point))
    (setq state (save-excursion (parse-partial-sexp (point-min) (point))))
    (cond 
     ((nth 3 state) ;; a string
      (setq indent 0))
     ((nth 4 state) ;; inside a comment
      (save-excursion
	(forward-line -1)
	(skip-chars-forward " \t")
	(setq indent (current-column))))
     ((nth 1 state)
      (save-excursion
	(goto-char (nth 1 state))
	(when (looking-at "{")
	  (beginning-of-line)
	  (skip-chars-forward " \t")
	  (setq indent (current-column))
	  (unless closing-brace (setq indent (+ indent spectre-indent-level))))
	(when (looking-at "(")
	  (setq indent (1+ (current-column)))))
      )
     (t)
     )
    ;; (message "indent to %d [%s]" indent state)
    ;; do the actual indenting here:
    (goto-char beg)
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
    (if (zerop shift-amt)
	nil
      (delete-region beg (point))
      (indent-to indent))
    ;; If initial point was within line's indentation,
    ;; position after the indentation.  Else stay at same point in text.
    (if (> (- (point-max) pos) (point))
	(goto-char (- (point-max) pos)))
    indent) ; let
  ) ; defun


;;------------------------------------------------------------
;; active file interface
;;------------------------------------------------------------
(condition-case ()
    (require 'active-file)
  (error nil))
(when (featurep 'active-file)
  (defconst spectre-active-file-alist
    (list
     (list
      ;;"^\\s-*\\(?:ahdl_\\)?include\\s-+\"\\([^\"\n]+\\)\""
      (concat spectre-library-regexp "\"\\([^\"\n]+\\)\"")
      nil
      3
      nil ;; function
      "mouse-2, RET: load include file"
      nil ;; highlighting face
      t)
     (list    ;; sensfiles, writes and writefinals
      (concat "\\(sensfile\\|write\\|writefinal\\|file\\)\\s-*=\\s-*" 
	      "\"\\([^\"\n]+\\)\"")
      nil
      2
      nil ;; function
      "mouse-2, RET: load file"
      nil ;; highlighting face
      t))
    "List of active file links in Spectre mode"
    )
  
  (defun spectre-active-file-init ()
    (active-file-init spectre-active-file-alist))
  
  (add-hook 'spectre-mode-hook 'spectre-active-file-init)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mode map

;; uncomment function, should work for any case now:
(defun spectre-uncomment-region (beg end)
  "Uncomment selected region - comment symbol is '//"
  (interactive "*r")
  (comment-region beg end '(2))) ; 2 is arbitrary, can be any value

(defvar spectre-mode-map nil
  "Keymap used in Spectre mode.") ;; no mode map for now

(if spectre-mode-map
    ()
  (let ((map (make-sparse-keymap)))  

    ;; comment region, use auctex-mode bindings...
    (define-key map "\C-c;"    'comment-region)
    (define-key map "\C-c:"    'spectre-uncomment-region)
    
    ;; include file loading as in eldo-mode
    (when (featurep 'active-file)
      (define-key map "\C-cl"    'active-file-load-include-files)
      (define-key map "\C-crl"   'active-file-load-include-files-recursively)
      )

    ;; compile keys
    (define-key map "\C-c\C-s" 'spectre-compile)
    (define-key map "\C-c\C-k" 'kill-compilation)

    ;; changelog entry, if supported with ntlst-section
    (when (featurep 'ntlst-section)
      (define-key map "\C-cac"   'ntlst-section-add-changelog-entry))

    ;; fontification
    (when ntlst-aux-running-xemacs
      (define-key map "\C-c\C-f" 'font-lock-fontify-buffer))
  
    (setq spectre-mode-map map)))


;;------------------------------------------------------------
;; spectre-mode starts here
;;------------------------------------------------------------
;;;###autoload
(defun spectre-mode ()
  "Major mode for editing files written in Spectre syntax. 

Entry to Spectre mode calls the value of the variable `spectre-mode-hook' 
with no args, if that value is non-nil after initialization is finished.

Key bindings:
-------------

\\{spectre-mode-map}
"
  (interactive)
  (kill-all-local-variables)

  (setq major-mode 'spectre-mode
        mode-name "Spectre")

  (use-local-map spectre-mode-map)
  (set-syntax-table spectre-mode-syntax-table)

  (set (make-local-variable 'comment-start) "//")
  (set (make-local-variable 'comment-padding) 1)

  (set (make-local-variable 'indent-line-function) 'spectre-indent-line)

  ;; font lock start-up
  (set (make-local-variable 'font-lock-defaults)
       (list '(spectre-font-lock-keywords 
	       spectre-font-lock-keywords-1 
	       spectre-font-lock-keywords-2) 
	     nil nil '((?_ . "w")))) ;; first nil -> t, don't do strings; second nil is case-folding...
  (set (make-local-variable 'font-lock-multiline) t) ; we have multiline regexps!
  (font-lock-set-defaults) ; required to make revert-buffer function properly

  ;; ntlst-section startup
  (when (fboundp 'spectre-ntlst-section-init)
    (spectre-ntlst-section-init))

  ;; imenu
  (when (fboundp 'imenu)
    (set (make-local-variable 'imenu-generic-expression)
	 spectre-imenu-generic-expression)
    (set (make-local-variable 'imenu-case-fold-search) t)
    (imenu-add-to-menubar "Index")
    ;; & speedbar, requires imenu anyway
    (when (fboundp 'ntlst-aux-speedbar-initialize)
      (ntlst-aux-speedbar-initialize)))

  ;; add mode menu
  (if (not spectre-menu-list)
      (setq spectre-menu-list (spectre-create-mode-menu)))
  (easy-menu-add spectre-menu-list)	; for XEmacs
  (easy-menu-define spectre-menu spectre-mode-map
    "Menu keymap for Spectre Mode." spectre-menu-list)

  ;; msb fix, run only once
  (and (featurep 'msb) 
       (ntlst-aux-msb-fix (quote 'spectre-mode) "Spectre Files (%d)"))

  (run-hooks 'spectre-mode-hook)
  (spectre-about))


(provide 'spectre-mode)

;;; spectre-mode.el ends here

;;; Local Variables:
;;; mode:Emacs-lisp
;;; End:
