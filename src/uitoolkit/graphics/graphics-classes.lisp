(in-package :graphic-forms.uitoolkit.graphics)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defstruct color
    (red 0)
    (green 0)
    (blue 0))

  (defstruct font-data
    (char-set 0)
    (face-name "")
    (point-size 10)
    (style nil))

  (defstruct font-metrics
    (ascent 0)
    (descent 0)
    (leading 0)
    (avg-char-width 0)
    (max-char-width 0))

  (defmacro ascent (metrics)
    `(gfg::font-metrics-ascent ,metrics))

  (defmacro descent (metrics)
    `(gfg::font-metrics-descent ,metrics))

  (defmacro leading (metrics)
    `(gfg::font-metrics-leading ,metrics))

  (defmacro height (metrics)
    (let ((tmp-metrics (gensym)))
      `(let ((,tmp-metrics ,metrics))
         (+ (gfg::font-metrics-ascent  ,tmp-metrics)
            (gfg::font-metrics-descent ,tmp-metrics)))))

  (defmacro average-char-width (metrics)
    `(gfg::font-metrics-avg-char-width ,metrics))

  (defmacro maximum-char-width (metrics)
    `(gfg::font-metrics-max-char-width ,metrics))

  (defstruct palette
    (red-mask 0)
    (green-mask 0)
    (blue-mask 0)
    (red-shift 0)
    (green-shift 0)
    (blue-shift 0)
    (direct nil)
    (table nil)) ; vector of COLOR structs

  (defmacro color-table (data)
    `(gfg::palette-table ,data)))

(defclass cursor (gfs:native-object)
  ((shared
    :reader sharedp
    :initarg :shared
    :initform nil))
  (:documentation "This class wraps a native cursor handle."))

(defclass image-data-plugin (gfs:native-object) ()
  (:documentation "Base class for image data plugin implementations."))

(defclass image-data ()
  ((data-plugin
    :reader data-plugin-of
    :initarg :data-plugin
    :initform nil))
  (:documentation "This class maintains image attributes, color, and pixel data."))

(defclass font (gfs:native-object) ()
  (:documentation "This class wraps a native font handle."))

(defclass graphics-context (gfs:native-object)
  ((dc-destructor
    :accessor dc-destructor-of
    :initform nil)
   (widget-handle
    :accessor widget-handle-of
    :initform nil)
   (surface-size
    :accessor surface-size-of
    :initarg :surface-size
    :initform nil)
   (logbrush-style
    :accessor logbrush-style-of
    :initform gfs::+bs-solid+)
   (logbrush-color
    :accessor logbrush-color-of
    :initform 0)
   (logbrush-hatch
    :accessor logbrush-hatch-of
    :initform gfs::+hs-bdiagonal+)
   (miter-limit
    :accessor miter-limit
    :initform 10.0)
   (pen-style
    :accessor pen-style
    :initform '(:solid))
   (pen-width
    :accessor pen-width
    :initform 1)
   (pen-handle
    :accessor pen-handle-of
    :initform (cffi:null-pointer)))
  (:documentation "This class represents the context associated with drawing primitives."))

(defclass icon-bundle (gfs:native-object) ()
  (:documentation "This class encapsulates a set of Win32 icon handles."))

(defclass image (gfs:native-object)
  ((transparency-pixel
    :accessor transparency-pixel-of
    :initarg :transparency-pixel
    :initform nil))
  (:documentation "This class encapsulates a Win32 bitmap handle."))

(defmacro blue-mask (data)
  `(gfg::palette-blue-mask ,data))

(defmacro blue-shift (data)
  `(gfg::palette-blue-shift ,data))

(defmacro direct (data flag)
  `(setf (gfg::palette-direct ,data) ,flag))

(defmacro green-mask (data)
  `(gfg::palette-green-mask ,data))

(defmacro green-shift (data)
  `(gfg::palette-green-shift ,data))

(defmacro red-mask (data)
  `(gfg::palette-red-mask ,data))

(defmacro red-shift (data)
  `(gfg::palette-red-shift ,data))

(defclass pattern (gfs:native-object) ()
  (:documentation "This class represents a pattern to be used with a brush."))

(defclass transform (gfs:native-object) ()
  (:documentation "This class specifies how coordinates are transformed."))
