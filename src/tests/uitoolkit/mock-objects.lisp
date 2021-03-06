(in-package :graphic-forms.uitoolkit.tests)

(defconstant +max-widget-size+          5000)
(defconstant +default-container-width+   300)
(defconstant +default-container-height+  200)

(defvar *default-hwnd* (cffi:make-pointer #xFFFFFFFF))

;;;
;;; stand-in for a window, used as parent of mock-widget
;;;

(defclass mock-container (gfw:layout-managed)
  ((location
    :accessor location-of
    :initarg :location
    :initform (gfs:make-point))
   (size
    :accessor size-of
    :initarg :size
    :initform (gfs:make-size :width +default-container-width+ :height +default-container-height+))
   (visibility
    :accessor visibility-of
    :initarg :visibility
    :initform t)))

(defvar *mock-container* (make-instance 'mock-container))

(defmethod gfw:visible-p ((self mock-container))
  (visibility-of self))

;;;
;;; stand-in for widgets that would be children of windows, to be organized
;;; via layout managers
;;;

(defclass mock-widget (gfw:widget)
  ((visibility
    :accessor visibility-of
    :initform t)
   (actual-size
    :accessor actual-size-of
    :initarg :actual-size
    :initform (gfs:make-size))
   (max-size
    :initarg :max-size
    :initform (gfs:make-size :width +max-widget-size+ :height +max-widget-size+))
   (min-size
    :initarg :min-size
    :initform (gfs:make-size))))

(defmethod initialize-instance :after ((self mock-widget) &key handle &allow-other-keys)
  (setf (slot-value self 'gfs:handle) (or handle *default-hwnd*)))

(defmethod gfw:location ((self mock-widget))
  (gfs:make-point))

(defmethod gfw:minimum-size ((self mock-widget))
  (gfs:make-size :width (gfs:size-width (slot-value self 'min-size))
                 :height (gfs:size-height (slot-value self 'min-size))))

(defmethod gfw:preferred-size ((self mock-widget) width-hint height-hint)
  (let ((size (gfs:make-size))
        (min-size (slot-value self 'min-size)))
    (if (< width-hint 0)
      (setf (gfs:size-width size) (gfs:size-width min-size))
      (setf (gfs:size-width size) width-hint))
    (if (< height-hint 0)
      (setf (gfs:size-height size) (gfs:size-height min-size))
      (setf (gfs:size-height size) height-hint))
    size))

(defmethod gfw:text-baseline ((self mock-widget))
  (floor (* (gfs:size-height (slot-value self 'min-size)) 3) 4))

(defmethod gfw:visible-p ((self mock-widget))
  (visibility-of self))

;;;
;;; infrastructure for item-manager unit tests
;;;

(defclass mock-item (gfw:item) ())

(defclass mock-item-manager (gfw:widget gfw:item-manager) ())

(defmethod initialize-instance :after ((self mock-item-manager) &key handle items &allow-other-keys)
  (setf (slot-value self 'gfs:handle) (or handle *default-hwnd*))
  (if items
    (setf (slot-value self 'gfw::items) (gfw::copy-item-sequence (gfs:handle self) items 'mock-item))))

(defmethod gfw:append-item ((self mock-item-manager) thing (disp gfw:event-dispatcher) &optional checked disabled classname)
  (declare (ignore disabled checked classname))
  (let ((item (gfw::create-item-with-callback (gfs:handle self) 'mock-item thing disp)))
    (vector-push-extend item (slot-value self 'gfw::items))
    item))

(defmethod (setf gfw:items-of) (new-items (self mock-item-manager))
  (setf (slot-value self 'gfw::items) (gfw::copy-item-sequence (gfs:handle self) new-items 'mock-item)))
