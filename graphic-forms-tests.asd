;;; -*- Mode: Lisp -*-

;;;;
;;;; graphic-forms-tests.asd
;;;;
;;;; Copyright (C) 2006-2007, Jack D. Unrue
;;;; Copyright (C) 2016, Bo Yao <icerove@gmail.com>
;;;; All rights reserved.
;;;;
;;;; Redistribution and use in source and binary forms, with or without
;;;; modification, are permitted provided that the following conditions
;;;; are met:
;;;; 
;;;;     1. Redistributions of source code must retain the above copyright
;;;;        notice, this list of conditions and the following disclaimer.
;;;; 
;;;;     2. Redistributions in binary form must reproduce the above copyright
;;;;        notice, this list of conditions and the following disclaimer in the
;;;;        documentation and/or other materials provided with the distribution.
;;;; 
;;;;     3. Neither the names of the authors nor the names of its contributors
;;;;        may be used to endorse or promote products derived from this software
;;;;        without specific prior written permission.
;;;; 
;;;; THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND ANY
;;;; EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DIS-
;;;; CLAIMED.  IN NO EVENT SHALL THE AUTHORS AND CONTRIBUTORS BE LIABLE FOR ANY
;;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;;;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;;;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;;;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;;

(defsystem graphic-forms-tests
  :description "Graphic-Forms UI Toolkit Tests"
  :depends-on ("lisp-unit" "graphic-forms-uitoolkit")
  :components
  ((:file "test-package")
   (:module "src"
	    :depends-on ("test-package")
	    :components
	    ((:module "demos"
		      :components
		      ((:file "demo-utils")
		       (:module "textedit"
				:serial t
				:depends-on ("demo-utils")
				:components
				((:file "textedit-document")
				 (:file "textedit-window")))
		       (:module "unblocked"
				:serial t
				:depends-on ("demo-utils")
				:components
				((:file "tiles")
				 (:file "unblocked-model")
				 (:file "unblocked-controller")
				 (:file "double-buffered-event-dispatcher")
				 (:file "scoreboard-panel")
				 (:file "tiles-panel")
				 (:file "unblocked-window")))))
	     (:module "tests"
		      :components
		      ((:module "uitoolkit"
				:serial t
				:components
				(;;; unit tests
				 (:file "test-utils")
				 (:file "mock-objects")
				 (:file "color-unit-tests")
				 (:file "graphics-context-unit-tests")
				 (:file "image-unit-tests")
				 (:file "icon-bundle-unit-tests")
				 (:file "layout-unit-tests")
				 (:file "flow-layout-unit-tests")
				 (:file "widget-unit-tests")
				 (:file "item-manager-unit-tests")
				 (:file "misc-unit-tests")
				 (:file "border-layout-unit-tests")

				 ;;; small examples
				 ;; (:file "hello-world")
				 ;; (:file "event-tester")
				 ;; (:file "layout-tester")
				 ;; (:file "image-tester")
				 ;; (:file "drawing-tester")
				 ;; (:file "widget-tester")
				 ;; (:file "scroll-grid-panel")
				 ;; (:file "scroll-text-panel")
				 ;; (:file "scroll-tester")
				 ;; (:file "windlg")
				 ))))))))

