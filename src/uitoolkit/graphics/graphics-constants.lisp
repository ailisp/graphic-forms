(in-package :graphic-forms.uitoolkit.graphics)

;;; The following are transcribed from WinGDI.h;
;;; specify one of them as the value of the char-set
;;; slot in the font-data structure.
;;; 
(defconstant +ansi-charset+                     0)
(defconstant +default-charset+                  1)
(defconstant +symbol-charset+                   2)
(defconstant +shiftjis-charset+               128)
(defconstant +hangeul-charset+                129)
(defconstant +hangul-charset+                 129)
(defconstant +gb2312-charset+                 134)
(defconstant +chinesebig5-charset+            136)
(defconstant +oem-charset+                    255)
(defconstant +johab-charset+                  130)
(defconstant +hebrew-charset+                 177)
(defconstant +arabic-charset+                 178)
(defconstant +greek-charset+                  161)
(defconstant +turkish-charset+                162)
(defconstant +vietnamese-charset+             163)
(defconstant +thai-charset+                   222)
(defconstant +easteurope-charset+             238)
(defconstant +russian-charset+                204)
(defconstant +mac-charset+                     77)
(defconstant +baltic-charset+                 186)

;;; The following are from WinUser.h; specify one of
;;; them as the value of the :system keyword arg when
;;; creating an icon-bundle
;;;
(defconstant +application-icon+             32512)
(defconstant +error-icon+                   32513)
(defconstant +information-icon+             32516)
(defconstant +question-icon+                32514)
(defconstant +warning-icon+                 32515)


;;; The following are from WinUser.h; specify one of
;;; them as the value of the :system keyword arg when
;;; creating an image.
;;;
(defconstant +app-starting-cursor+ gfs::+ocr-appstarting+)
(defconstant +crosshair-cursor+    gfs::+ocr-cross+)
(defconstant +default-cursor+      gfs::+ocr-normal+)
(defconstant +hand-cursor+         gfs::+ocr-hand+)
(defconstant +help-cursor+         32651)
(defconstant +ibeam-cursor+        gfs::+ocr-ibeam+)
(defconstant +no-cursor+           gfs::+ocr-no+)
(defconstant +size-all-cursor+     gfs::+ocr-sizeall+)
(defconstant +size-nesw-cursor+    gfs::+ocr-sizenesw+)
(defconstant +size-ns-cursor+      gfs::+ocr-sizens+)
(defconstant +size-nwse-cursor+    gfs::+ocr-sizenwse+)
(defconstant +size-we-cursor+      gfs::+ocr-sizewe+)
(defconstant +up-arrow-cursor+     gfs::+ocr-up+)
(defconstant +wait-cursor+         gfs::+ocr-wait+)

;;; Device context color mixing
(defconstant +R2-BLACK+	1)
(defconstant +R2-COPYPEN+	13)
(defconstant +R2-MASKNOTPEN+	3)
(defconstant +R2-MASKPEN+	9)
(defconstant +R2-MASKPENNOT+	5)
(defconstant +R2-MERGENOTPEN+	12)
(defconstant +R2-MERGEPEN+	15)
(defconstant +R2-MERGEPENNOT+	14)
(defconstant +R2-NOP+	11)
(defconstant +R2-NOT+	6)
(defconstant +R2-NOTCOPYPEN+	4)
(defconstant +R2-NOTMASKPEN+	8)
(defconstant +R2-NOTMERGEPEN+	2)
(defconstant +R2-NOTXORPEN+	10)
(defconstant +R2-WHITE+	16)
(defconstant +R2-XORPEN+	7)
