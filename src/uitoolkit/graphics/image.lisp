(in-package :graphic-forms.uitoolkit.graphics)

;;;
;;; helper macros and functions
;;;

(defmacro with-image-transparency ((image pnt) &body body)
  (let ((tmp-image (gensym))
        (orig-pnt (gensym)))
    `(let* ((,tmp-image ,image)
            (,orig-pnt (transparency-pixel-of ,tmp-image)))
       (unwind-protect
           (progn
             (setf (transparency-pixel-of ,tmp-image) ,pnt)
             ,@body)
         (setf (transparency-pixel-of ,tmp-image) ,orig-pnt)))))

(defun clone-bitmap (horig)
  (let ((hclone (cffi:null-pointer))
        (screen-dc (gfs::get-dc (cffi:null-pointer)))
        (nptr (cffi:null-pointer)))
    (gfs::with-compatible-dcs (nptr memdc-src memdc-dest)
      (cffi:with-foreign-object (bmp-ptr '(:struct gfs::bitmap))
        (cffi:with-foreign-slots ((gfs::width gfs::height) bmp-ptr (:struct gfs::bitmap))
          (gfs::get-object horig (cffi:foreign-type-size '(:struct gfs::bitmap)) bmp-ptr)
          (setf hclone (gfs::create-compatible-bitmap screen-dc gfs::width gfs::height))
          (gfs::select-object memdc-dest hclone)
          (gfs::select-object memdc-src horig)
          (gfs::bit-blt memdc-dest 0 0 gfs::width gfs::height memdc-src 0 0 gfs::+blt-srccopy+))))
    (unless (gfs:null-handle-p screen-dc)
      (gfs::release-dc (cffi:null-pointer) screen-dc))
    hclone))

(defun copy-image-area (image-src image-dst &key src-x src-y width height dst-x dst-y)
  (let ((gc-src (make-graphics-context image-src))
	(gc-dst (make-graphics-context image-dst)))
    (cffi:with-foreign-slots ((gfs::width gfs::height) (gfs:handle image-src) (:struct gfs::bitmap))
      (gfs::transparent-blt (gfs:handle gc-dst)
			    (or dst-x 0)
			    (or dst-y 0)
			    (or width gfs::width)
			    (or height gfs::height)
			    (gfs:handle gc-src)
			    (or src-x 0)
			    (or src-y 0)
			    (or width gfs::width)
			    (or height gfs::height)
			    (color->rgb *color-black*)))
    (gfs:dispose gc-src)
    (gfs:dispose gc-dst)))

;;; This return should be free via gfs:dispose
(defun make-graphics-context (&optional thing)
  (cond
    ((null thing)
     (make-instance 'gfg:graphics-context))
    ((typep thing 'gfw:widget)
     (make-instance 'gfg:graphics-context :widget thing))
    ((typep thing 'gfg:image)
     (make-instance 'gfg:graphics-context :image thing))
    (t
     (error 'gfs:toolkit-error
	    :detail (format nil "~a is an unsupported type" thing)))))
;;;
;;; methods
;;;

(defmethod gfs:dispose ((im image))
  (let ((hgdi (gfs:handle im)))
    (unless (gfs:null-handle-p hgdi)
      (gfs::delete-object hgdi)))
  (setf (slot-value im 'gfs:handle) nil))

(defmethod data-object ((self image) &optional gc)
  (declare (ignore gc))
  (when (gfs:disposed-p self)
    (error 'gfs:disposed-error))
  (image->data (gfs:handle self)))

(defmethod (setf data-object) ((id image-data) (self image))
  (unless (gfs:disposed-p self)
    (gfs:dispose self))
  (setf (slot-value self 'gfs:handle) (data->image id)))

(defmethod initialize-instance :after ((self image) &key file size &allow-other-keys)
  (cond
    (file
      (load self file))
    (size
      (cffi:with-foreign-object (bih-ptr '(:struct gfs::bitmapinfoheader))
        (gfs::zero-mem bih-ptr (:struct gfs::bitmapinfoheader))
        (cffi:with-foreign-slots ((gfs::bisize gfs::biwidth gfs::biheight gfs::biplanes
                                   gfs::bibitcount gfs::bicompression)
                                  bih-ptr (:struct gfs::bitmapinfoheader))
          (setf gfs::bisize        (cffi:foreign-type-size '(:struct gfs::bitmapinfoheader))
                gfs::biwidth       (gfs:size-width size)
                gfs::biheight      (- (gfs:size-height size))
                gfs::biplanes      1
                gfs::bibitcount    32
                gfs::bicompression gfs::+bi-rgb+)
          (let ((nptr (cffi:null-pointer))
                (hbmp (cffi:null-pointer)))
            (cffi:with-foreign-object (buffer :pointer)
              (gfs::with-compatible-dcs (nptr memdc)
                (setf hbmp (gfs::create-dib-section memdc bih-ptr gfs::+dib-rgb-colors+ buffer nptr 0))))
            (setf (slot-value self 'gfs:handle) hbmp)))))))

(defmethod load ((self image) path)
  (let ((data (make-instance 'image-data)))
    (load data path)
    (setf (data-object self) data)
    data))

(defmethod size ((self image))
  (if (gfs:disposed-p self)
    (error 'gfs:disposed-error))
  (let ((size (gfs:make-size))
        (himage (gfs:handle self)))
    (cffi:with-foreign-object (bmp-ptr '(:struct gfs::bitmap))
      (cffi:with-foreign-slots ((gfs::width gfs::height) bmp-ptr (:struct gfs::bitmap))
        (gfs::get-object himage (cffi:foreign-type-size '(:struct gfs::bitmap)) bmp-ptr)
        (setf (gfs:size-width size) gfs::width
              (gfs:size-height size) gfs::height)))
    size))

(defmethod transparency-mask ((self image))
  (if (gfs:disposed-p self)
    (error 'gfs:disposed-error))
  (let ((pixel-pnt (transparency-pixel-of self))
        (hbmp (gfs:handle self))
        (hmask (cffi:null-pointer))
        (nptr (cffi:null-pointer)))
    (if pixel-pnt
      (progn
        (cffi:with-foreign-object (bmp-ptr '(:struct gfs::bitmap))
          (gfs::get-object (gfs:handle self) (cffi:foreign-type-size '(:struct gfs::bitmap)) bmp-ptr)
          (cffi:with-foreign-slots ((gfs::width gfs::height) bmp-ptr (:struct gfs::bitmap))
            (setf hmask (gfs::create-bitmap gfs::width gfs::height 1 1 (cffi:null-pointer)))
            (if (gfs:null-handle-p hmask)
              (error 'gfs:win32-error :detail "create-bitmap failed"))
            (gfs::with-compatible-dcs (nptr memdc1 memdc2)
              (gfs::select-object memdc1 hbmp)
              (gfs::set-bk-color memdc1 (gfs::get-pixel memdc1
                                                        (gfs:point-x pixel-pnt)
                                                        (gfs:point-y pixel-pnt)))
              (gfs::select-object memdc2 hmask)
              (gfs::bit-blt memdc2 0 0 gfs::width gfs::height memdc1 0 0 gfs::+blt-srccopy+))))
        (make-instance 'image :handle hmask))
      nil)))
