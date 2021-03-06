(in-package :graphic-forms.uitoolkit.widgets)

;;;
;;; helper functions
;;;

(defun obtain-chosen-files (dlg)
  (let ((ofn-ptr (gfs:handle dlg)))
    (if (cffi:null-pointer-p ofn-ptr)
      (error 'gfs:disposed-error))
    (cffi:with-foreign-slots ((gfs::ofnfile) ofn-ptr (:struct gfs::openfilename))
      (if (or (cffi:null-pointer-p gfs::ofnfile) (= (cffi:mem-ref gfs::ofnfile :char) 0))
        nil
        (let* ((raw-list (extract-foreign-strings gfs::ofnfile))
               (dir-str (first raw-list)))
          (if (rest raw-list)
            (loop for filename in (rest raw-list)
                  collect (parse-namestring (concatenate 'string dir-str "\\" filename)))
            (list (parse-namestring dir-str))))))))

(defmacro with-file-dialog ((owner style paths &key default-extension filters initial-directory initial-filename text) &body body)
  (let ((dlg (gensym)))
   `(let ((,paths nil)
          (,dlg (make-instance 'file-dialog
                               :default-extension ,default-extension
                               :filters ,filters
                               :initial-directory ,initial-directory
                               :initial-filename ,initial-filename
                               :owner ,owner
                               :style ,style
                               :text ,text)))
      (unwind-protect
          (progn
            (show ,dlg t)
            (setf ,paths (obtain-chosen-files ,dlg))
            ,@body)
        (gfs:dispose ,dlg)))))

;;;
;;; methods
;;;

(defmethod compute-style-flags ((self file-dialog) &rest extra-data)
  (declare (ignore extra-data))
  (let ((std-flags (logior gfs::+ofn-dontaddtorecent+ gfs::+ofn-hidereadonly+
                           gfs::+ofn-notestfilecreate+ gfs::+ofn-overwriteprompt+
                           gfs::+ofn-explorer+)))
    (loop for sym in (style-of self)
          do (cond
               ((eq sym :add-to-recent)
                  (setf std-flags (logand std-flags (lognot gfs::+ofn-dontaddtorecent+))))
               ((eq sym :multiple-select)
                  (setf std-flags (logior std-flags gfs::+ofn-allowmultiselect+)))
               ((eq sym :path-must-exist)
                  (setf std-flags (logior std-flags gfs::+ofn-filemustexist+)))
               ((eq sym :show-hidden)
                  (setf std-flags (logior std-flags gfs::+ofn-forceshowhidden+)))))
    (values std-flags 0)))

(defmethod gfs:dispose ((self file-dialog))
  (let ((ofn-ptr (gfs:handle self)))
    (unless (cffi:null-pointer-p ofn-ptr)
      (cffi:with-foreign-slots ((gfs::ofnfile gfs::ofnfilter gfs::ofntitle
                                 gfs::ofninitialdir gfs::ofndefext)
                                ofn-ptr (:struct gfs::openfilename))
        (cffi:foreign-free gfs::ofnfile)
        (cffi:foreign-free gfs::ofnfilter)
        (unless (cffi:null-pointer-p gfs::ofntitle)
          (cffi:foreign-free gfs::ofntitle))
        (unless (cffi:null-pointer-p gfs::ofninitialdir)
          (cffi:foreign-free gfs::ofninitialdir))
        (unless (cffi:null-pointer-p gfs::ofndefext)
          (cffi:foreign-free gfs::ofndefext)))
      (cffi:foreign-free ofn-ptr)
      (setf (slot-value self 'gfs:handle) nil))))

(defmethod initialize-instance :after ((self file-dialog) &key default-extension filters initial-directory initial-filename owner style text)
  ;; FIXME: implement an OFNHookProc to process CDN_SELCHANGE
  ;; so that the file buffer can be resized as needed for
  ;; multi-select mode.
  ;;
  (if (null owner)
    (error 'gfs:toolkit-error :detail ":owner initarg is required"))
  (if (gfs:disposed-p owner)
    (error 'gfs:disposed-error))
  (let ((ofn-ptr (cffi:foreign-alloc '(:struct gfs::openfilename)))
        (filters-buffer (if filters
                          (collect-foreign-strings (loop for entry in filters
                                                         append (list (car entry) (cdr entry))))
                          (cffi:null-pointer)))
        (title-buffer (cffi:null-pointer))
        (dir-buffer (cffi:null-pointer))
        (ext-buffer (cffi:null-pointer))
        (file-buffer (cffi:foreign-alloc :char :count 1024 :initial-element 0))) ; see FIXME above
    (if text
      (setf title-buffer (collect-foreign-strings (list text))))
    (if initial-directory
      (setf dir-buffer (collect-foreign-strings (list initial-directory))))
    (if default-extension
      (setf ext-buffer (collect-foreign-strings (list (remove #\. default-extension)))))
    (if initial-filename
      (cffi:with-foreign-string (tmp-str (namestring initial-filename))
        (gfs::strncpy file-buffer tmp-str 1023))
      (setf (cffi:mem-ref file-buffer :char) 0))
    (multiple-value-bind (std-style ex-style)
        (compute-style-flags self)
      (cffi:with-foreign-slots ((gfs::ofnsize gfs::ofnhwnd gfs::ofnhinst gfs::ofnfilter
                                 gfs::ofncustomfilter gfs::ofnmaxcustfilter gfs::ofnfilterindex
                                 gfs::ofnfile gfs::ofnmaxfile gfs::ofnfiletitle gfs::ofnmaxfiletitle
                                 gfs::ofninitialdir gfs::ofntitle gfs::ofnflags gfs::ofnfileoffset
                                 gfs::ofnfileext gfs::ofndefext gfs::ofncustdata gfs::ofnhookfn
                                 gfs::ofntemplname gfs::ofnpvreserved gfs::ofndwreserved gfs::ofnexflags)
                                ofn-ptr (:struct gfs::openfilename))
        (setf gfs::ofnsize          (cffi:foreign-type-size '(:struct gfs::openfilename))
              gfs::ofnhwnd          (gfs:handle owner)
              gfs::ofnhinst         (cffi:null-pointer)
              gfs::ofnfilter        filters-buffer
              gfs::ofncustomfilter  (cffi:null-pointer)
              gfs::ofnmaxcustfilter 0
              gfs::ofnfilterindex   1 ; first pair of filter strings is identified by index 1 not 0
              gfs::ofnfile          file-buffer
              gfs::ofnmaxfile       1024
              gfs::ofnfiletitle     (cffi:null-pointer)
              gfs::ofnmaxfiletitle  0
              gfs::ofninitialdir    dir-buffer
              gfs::ofntitle         title-buffer
              gfs::ofnflags         std-style
              gfs::ofnfileoffset    0
              gfs::ofnfileext       0
              gfs::ofndefext        ext-buffer
              gfs::ofncustdata      0
              gfs::ofnhookfn        (cffi:null-pointer)
              gfs::ofntemplname     (cffi:null-pointer)
              gfs::ofnpvreserved    (cffi:null-pointer)
              gfs::ofndwreserved    0
              gfs::ofnexflags       ex-style)))
    (setf (slot-value self 'gfs:handle) ofn-ptr)
    (setf (slot-value self 'open-mode) (find :open style))))

(defmethod show ((self file-dialog) flag)
  (declare (ignore flag))
  (if (open-mode self)
    (show-common-dialog self #'gfs::get-open-filename)
    (show-common-dialog self #'gfs::get-save-filename)))
