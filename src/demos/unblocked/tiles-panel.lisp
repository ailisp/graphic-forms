(in-package :graphic-forms.uitoolkit.tests)

(defvar *unblocked-dir*       (merge-pathnames "src/demos/unblocked/" *gf-dir*))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defconstant +tile-bmp-width+  24)
  (defconstant +tile-bmp-height+ 24))

(defun tiles->window (pnt)
  (let ((xpos (1+ (* (gfs:point-x pnt) +tile-bmp-width+)))
        (ypos (1+ (* (- (1- +vert-tile-count+) (gfs:point-y pnt)) +tile-bmp-height+)))
        (size (gfw:client-size (get-tiles-panel))))
    (if (or (>= xpos (gfs:size-width size)) (>= ypos (gfs:size-height size)))
      nil
      (gfs:make-point :x xpos :y ypos))))

(defun window->tiles (pnt)
  (let ((xpos (floor (1- (gfs:point-x pnt)) +tile-bmp-width+))
        (ypos (- +vert-tile-count+ (1+ (floor (1- (gfs:point-y pnt)) +tile-bmp-height+)))))
    (if (or (>= xpos +horz-tile-count+) (>= ypos +vert-tile-count+))
      nil
      (gfs:make-point :x xpos :y ypos))))

(defclass tiles-panel-events (double-buffered-event-dispatcher)
  ((tile-image-table
    :accessor tile-image-table-of
    :initform (make-hash-table :test #'equal))
   (shape-kind
    :accessor shape-kind-of
    :initform 0)
   (shape-pnts
    :accessor shape-pnts-of
    :initform nil)))

(defun draw-tiles-directly (panel shape-pnts kind)
  (gfw:with-graphics-context (gc panel)
    (let ((image-table (tile-image-table-of (gfw:dispatcher panel))))
      (loop for pnt in shape-pnts
            do (let ((image (gethash kind image-table)))
                 (gfg:draw-image gc image (tiles->window pnt)))))))

(defmethod dispose ((self tiles-panel-events))
  (let ((table (tile-image-table-of self)))
    (maphash #'(lambda (kind image)
                 (declare (ignore kind))
                 (gfs:dispose image))
             table))
  (setf (tile-image-table-of self) nil)
  (setf (shape-pnts-of self) nil)
  (call-next-method))

(defmethod initialize-instance :after ((self tiles-panel-events) &key buffer-size)
  (declare (ignorable buffer-size))
  (let ((*default-pathname-defaults* (parse-namestring *unblocked-dir*))
        (table (tile-image-table-of self))
        (kind 1))
    (loop for filename in '("blue-tile.bmp" "brown-tile.bmp" "red-tile.bmp"
                            "green-tile.bmp" "pink-tile.bmp" "gold-tile.bmp")
          do (let ((image (make-instance 'gfg:image)))
               (gfg:load image (merge-pathnames filename))
               (setf (gethash kind table) image)
               (incf kind)))))

(defmethod gfw:event-mouse-down ((self tiles-panel-events) panel point button)
  (multiple-value-bind (shape-kind shape-pnts)
      (ctrl-start-selection (shape-pnts-of self) panel point button)
    (if shape-pnts
      (progn
        (setf (shape-kind-of self) shape-kind
              (shape-pnts-of self) shape-pnts)
        (gfw:capture-mouse panel))
      (progn
        (draw-tiles-directly panel (shape-pnts-of self) (shape-kind-of self))
        (setf (shape-kind-of self) 0)
        (setf (shape-pnts-of self) nil)))))

(defmethod gfw:event-mouse-up ((self tiles-panel-events) panel point button)
  (gfw:release-mouse)
  (ctrl-finish-selection (shape-pnts-of self) (shape-kind-of self) panel point button)
  (setf (shape-kind-of self) 0)
  (setf (shape-pnts-of self) nil))

(defmethod update-buffer ((self tiles-panel-events))
  (gfw:with-graphics-context (gc (image-buffer-of self))
    (let ((image-table (tile-image-table-of self)))
      (clear-buffer self gc)
      (map-tiles #'(lambda (pnt kind)
                     (unless (= kind 0)
                       (gfg:draw-image gc (gethash kind image-table) (tiles->window pnt))))
                 (model-tiles)))))

(defclass tiles-panel (gfw:panel) ())

(defmethod gfs:dispose ((self tiles-panel))
  (dispose (gfw:dispatcher self))
  (call-next-method))

(defmethod gfw:preferred-size ((self tiles-panel) width-hint height-hint)
  (declare (ignore width-hint height-hint))
  (let ((size (gfg:size (image-buffer-of (gfw:dispatcher self)))))
    (gfs:make-size :width (+ (gfs:size-width size) 2) :height (+ (gfs:size-height size) 2))))
