(in-package :graphic-forms.uitoolkit.graphics.default)

(defclass default-data-plugin (gfg:image-data-plugin)
  ((palette
    :accessor palette-of
    :initform nil)
   (pixels
    :accessor pixels-of
    :initform nil))
  (:documentation "Default library plugin for the graphics package."))

(defmacro bitmap-pixel-row-length (width bit-count)
  `(ash (logand (+ (* ,width ,bit-count) 31) (lognot 31)) -3))

(defun load-bmp-data (stream &optional no-header-p half-height-p)
  (unless no-header-p
    (read-value 'BITMAPFILEHEADER stream))
  (let* ((info (read-value 'BASE-BITMAPINFOHEADER stream))
         (data (make-instance 'default-data-plugin :handle info)))
    (unless (= (biCompression info) gfs::+bi-rgb+)
      (error 'gfs:toolkit-error :detail "FIXME: non-RGB not yet implemented"))
    (if half-height-p
      (setf (biHeight info) (/ (biHeight info) 2)))

    ;; load color table
    ;;
    (let ((used (biClrUsed info))
          (rgbs nil))
      (ecase (biBitCount info)
        (1
          (setf rgbs (make-array 2)))
        (4
          (if (or (= used 0) (= used 16))
            (setf rgbs (make-array 16))
            (setf rgbs (make-array used))))
        (8
          (if (or (= used 0) (= used 256))
            (setf rgbs (make-array 256))
            (setf rgbs (make-array used))))
        (16
          (unless (/= used 0)
            (setf rgbs (make-array used))))
        (24
          (unless (/= used 0)
            (setf rgbs (make-array used))))
        (32
          (unless (/= used 0)
            (setf rgbs (make-array used)))))
      (dotimes (i (length rgbs))
        (let ((quad (read-value 'RGBQUAD stream)))
          (setf (aref rgbs i) (gfg:make-color :red   (rgbRed quad)
                                              :green (rgbGreen quad)
                                              :blue  (rgbBlue quad)))))
      (setf (palette-of data) (gfg:make-palette :direct nil :table rgbs)))

    ;; load pixel bits
    ;;
    (let ((row-len (bitmap-pixel-row-length (biWidth info) (biBitCount info))))
      (setf (pixels-of data) (make-array (* row-len (biHeight info)) :element-type '(unsigned-byte 8)))
      (read-sequence (pixels-of data) stream))

    (list data)))

(defun load-icon-data (stream)
  (let ((offsets (loop for i upto (1- (idCount (read-value 'ICONDIR stream)))
                       for entry = (read-value 'ICONDIRENTRY stream)
                       collect (ideImageOffset entry))))
    (loop for offset in offsets
          append (progn
                   (file-position stream offset)
                   (load-bmp-data stream t t)))))

(defun loader (path)
  (let* ((file-type (pathname-type path))
         (helper (cond
                   ((string-equal file-type "bmp") #'load-bmp-data)
                   ((string-equal file-type "ico") #'load-icon-data)
                   ((string-equal file-type "cur") #'load-icon-data)
                   (t                              (return-from loader nil)))))
    (with-open-file (stream path :element-type '(unsigned-byte 8))
      (funcall helper stream))))

(push #'loader gfg::*image-plugins*)

(defmethod gfg:depth ((self default-data-plugin))
  (let ((info (gfs:handle self)))
    (unless info
      (error 'gfs:disposed-error))
    (biBitCount info)))

(defmethod gfs:dispose ((self default-data-plugin))
  (setf (slot-value self 'gfs:handle) nil))

(defmethod cffi:free-translated-object (bi-ptr (name (eql 'gfs::bitmap-info-pointer)) param)
  (declare (ignore param))
  (cffi:foreign-free bi-ptr))

(defmethod gfg:copy-pixels ((self default-data-plugin) pixels-pointer)
  (let ((plugin-pixels (pixels-of self)))
    (dotimes (i (length plugin-pixels))
      (setf (cffi:mem-aref pixels-pointer :uint8 i) (aref plugin-pixels i))))
  pixels-pointer)

(defmethod gfg:size ((self default-data-plugin))
  (let ((info (gfs:handle self)))
    (unless info
      (error 'gfs:disposed-error))
    (gfs:make-size :width (biWidth info) :height (- (biHeight info)))))

(defmethod (setf gfg:size) (size (self default-data-plugin))
  (let ((info (gfs:handle self)))
    (unless info
      (error 'gfs:disposed-error))
    (setf (biWidth info)  (gfs:size-width size)
          (biHeight info) (- (gfs:size-height size))))
  size)

(defmethod cffi:translate-to-foreign ((lisp-obj default-data-plugin)
                                      (type gfs::bitmapinfo-pointer-type))
  (let ((bi-ptr (gfg::make-initial-bitmapinfo lisp-obj))
        (colors (gfg:color-table (palette-of lisp-obj))))
    (let ((ptr (cffi:foreign-slot-pointer bi-ptr '(:struct gfs::bitmapinfo) 'gfs::bmicolors)))
      (dotimes (i (length colors))
        (let ((clr (aref colors i)))
          (cffi:with-foreign-slots ((gfs::rgbblue gfs::rgbgreen
                                     gfs::rgbred gfs::rgbreserved)
                                    (cffi:mem-aptr ptr '(:struct gfs::rgbquad) i) (:struct gfs::rgbquad))
            (setf gfs::rgbreserved 0
                  gfs::rgbblue     (gfg:color-blue clr)
                  gfs::rgbgreen    (gfg:color-green clr)
                  gfs::rgbred      (gfg:color-red clr))))))
    bi-ptr))
