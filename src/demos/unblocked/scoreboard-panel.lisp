(in-package :graphic-forms.uitoolkit.tests)

(defparameter *level-label*            "Level:")
(defparameter *points-needed-label*    "Points Needed:")
(defparameter *score-label*            "Score:")

(defconstant +scoreboard-text-margin+ 2)

(defvar *text-color* (gfg:make-color :red 237 :green 232 :blue 14))

(defvar *scoreboard-label-font-data* (gfg:make-font-data :face-name "Tahoma"
                                                         :point-size 14
                                                         :style '(:bold)))
(defvar *scoreboard-value-font-data* (gfg:make-font-data :face-name "Tahoma"
                                                         :point-size 14))

(defclass scoreboard-panel-events (double-buffered-event-dispatcher)
  ((label-font
    :accessor label-font-of
    :initform nil)
   (value-font
    :accessor value-font-of
    :initform nil)))

(defmethod dispose ((self scoreboard-panel-events))
  (let ((tmp-font (label-font-of self)))
    (unless (null tmp-font)
      (gfs:dispose tmp-font)
      (setf (label-font-of self) nil))
    (setf tmp-font (value-font-of self))
    (unless (null tmp-font)
      (gfs:dispose tmp-font)
      (setf (label-font-of self) nil)))
  (call-next-method))

(defun compute-scoreboard-size ()
  (let* ((gc (make-instance 'gfg:graphics-context))
         (font (make-instance 'gfg:font :gc gc :data *scoreboard-label-font-data*))
         (metrics (gfg:metrics gc font))
         (buffer-size (gfs:make-size)))
    (unwind-protect
        (progn
          (setf (gfs:size-width buffer-size) (* (+ (length *points-needed-label*)
                                                   2   ; space between label and value
                                                   9)  ; number of value characters
                                                (gfg:average-char-width metrics)))
          (setf (gfs:size-height buffer-size) (* (gfg:height metrics) 4)))

      (gfs:dispose font)
      (gfs:dispose gc))
    buffer-size))

(defmethod initialize-instance :after ((self scoreboard-panel-events) &key buffer-size)
  (declare (ignorable buffer-size))
  (gfw:with-graphics-context (gc)
    (setf (label-font-of self) (make-instance 'gfg:font :gc gc :data *scoreboard-label-font-data*))
    (setf (value-font-of self) (make-instance 'gfg:font :gc gc :data *scoreboard-value-font-data*))))

(defmethod draw-scoreboard-row (gc row image-size label-font label-text value-font value)
  (let* ((metrics (gfg:metrics gc label-font))
         (text-pnt (gfs:make-point :x +scoreboard-text-margin+ :y (* row (gfg:height metrics))))
         (value-text (format nil "~:d" value)))
    (setf (gfg:font gc) label-font)
    (setf (gfg:foreground-color gc) *text-color*)
    (gfg:draw-text gc label-text text-pnt)
    (setf (gfg:font gc) value-font)
    (setf (gfs:point-x text-pnt) (- (- (gfs:size-width image-size) +scoreboard-text-margin+)
                                    (gfs:size-width (gfg:text-extent gc value-text))))
    (gfg:draw-text gc value-text text-pnt)))

(defmethod update-buffer ((self scoreboard-panel-events))
  (let ((gc (make-instance 'gfg:graphics-context :image (image-buffer-of self)))
        (label-font (label-font-of self))
        (value-font (value-font-of self))
        (image-size (gfg:size (image-buffer-of self))))
    (unwind-protect
        (progn
          (clear-buffer self gc)
          (draw-scoreboard-row gc 1 image-size label-font *score-label* value-font (model-score))
          (draw-scoreboard-row gc 0 image-size label-font *level-label* value-font (model-level))
          (draw-scoreboard-row gc 2 image-size label-font *points-needed-label* value-font (game-points-needed)))
      (gfs:dispose gc))))

(defclass scoreboard-panel (gfw:panel) ())

(defmethod gfw:preferred-size ((self scoreboard-panel) width-hint height-hint)
  (declare (ignore width-hint height-hint))
  (let ((size (gfg:size (image-buffer-of (gfw:dispatcher self)))))
    (gfs:make-size :width (+ (gfs:size-width size) 2) :height (+ (gfs:size-height size) 2))))
