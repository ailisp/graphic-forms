;;;;
;;;; packages.lisp
;;;;
;;;; Copyright (C) 2006-2007, Jack D. Unrue
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

(in-package #:cl-user)

;;;
;;; destination for unique symbols generated by GENTEMP
;;;
(defpackage #:graphic-forms.generated
  (:nicknames #:gfgen)
  (:use #:common-lisp))

;;;
;;; package for system-level functionality
;;;
(defpackage #:graphic-forms.uitoolkit.system
  (:nicknames #:gfs)
  (:shadow #:atom #:boolean)
  (:use #:common-lisp)
  (:export

;; classes and structs
    #:native-object
    #:point
    #:rectangle
    #:size
    #:span

;; constants

;; methods, functions, macros
    #:copy-rectangle
    #:copy-point
    #:copy-size
    #:copy-span
    #:create-rectangle
    #:detail
    #:dispose
    #:disposed-p
    #:empty-span-p
    #:equal-size-p
    #:flatten
    #:handle
    #:location
    #:make-point
    #:make-rectangle
    #:make-size
    #:make-span
    #:null-handle-p
    #:obtain-system-metrics
    #:point-x
    #:point-y
    #:point-z
    #:size
    #:size-depth
    #:size-height
    #:size-width
    #:span-start
    #:span-end
    #:zero-mem

;; conditions
    #:comdlg-error
    #:disposed-error
    #:toolkit-error
    #:toolkit-warning
    #:win32-error
    #:win32-warning))

;;;
;;; package for graphics functionality
;;;
(defpackage #:graphic-forms.uitoolkit.graphics
  (:nicknames #:gfg)
  (:shadow #:load #:type)
  (:use #:common-lisp)
  (:export

;; classes and structs
    #:color
    #:cursor
    #:font
    #:font-data
    #:font-metrics
    #:graphics-context
    #:icon-bundle
    #:image
    #:image-data
    #:image-data-plugin
    #:palette
    #:pattern
    #:transform

;; constants
    #:*color-alice-blue* #:*color-antique-white* #:*color-aqua* #:*color-aquamarine*
    #:*color-azure* #:*color-beige* #:*color-bisque* #:*color-black* #:*color-blanched-almond*
    #:*color-blue* #:*color-blue-violet* #:*color-brown* #:*color-burlywood*
    #:*color-cadet-blue* #:*color-chartreuse* #:*color-chocolate* #:*color-coral*
    #:*color-cornflower-blue* #:*color-cornsilk* #:*color-crimson* #:*color-cyan*
    #:*color-dark-blue* #:*color-dark-cyan* #:*color-dark-goldenrod* #:*color-dark-gray*
    #:*color-dark-green* #:*color-dark-khaki* #:*color-dark-magenta* #:*color-dark-olive-green*
    #:*color-dark-orange* #:*color-dark-orchid* #:*color-dark-red* #:*color-dark-salmon*
    #:*color-dark-sea-green* #:*color-dark-slate-blue* #:*color-dark-slate-gray*
    #:*color-dark-turquoise* #:*color-dark-violet* #:*color-deep-pink*
    #:*color-deep-sky-blue* #:*color-dim-gray* #:*color-dodger-blue* #:*color-firebrick*
    #:*color-floral-white* #:*color-forest-green* #:*color-fuchsia* #:*color-gainsboro*
    #:*color-ghost-white* #:*color-gold* #:*color-goldenrod* #:*color-gray*
    #:*color-green* #:*color-green-yellow* #:*color-honey-dew* #:*color-hot-pink*
    #:*color-indian-red* #:*color-indigo* #:*color-ivory* #:*color-khaki* #:*color-lavender*
    #:*color-lavender-blush* #:*color-lawn-green* #:*color-lemon-chiffon*
    #:*color-light-blue* #:*color-light-coral* #:*color-light-cyan*
    #:*color-light-goldenrod-yellow* #:*color-light-gray* #:*color-light-green*
    #:*color-light-pink* #:*color-light-salmon* #:*color-light-sea-green*
    #:*color-light-sky-blue* #:*color-light-sky-gray* #:*color-light-steel-blue*
    #:*color-light-yellow* #:*color-lime* #:*color-lime-green* #:*color-linen*
    #:*color-magenta* #:*color-maroon* #:*color-medium-aquamarine* #:*color-medium-blue*
    #:*color-medium-orchid* #:*color-medium-purple* #:*color-medium-sea-green*
    #:*color-medium-slate-blue* #:*color-medium-spring-green* #:*color-medium-turquoise*
    #:*color-medium-violet-red* #:*color-midnight-blue* #:*color-mint-cream*
    #:*color-misty-rose* #:*color-moccasin* #:*color-navajo-white* #:*color-navy*
    #:*color-old-lace* #:*color-olive* #:*color-olive-drab* #:*color-orange*
    #:*color-pale-turquoise* #:*color-pale-violet-red* #:*color-papaya-whip*
    #:*color-peach-puff* #:*color-peru* #:*color-pink* #:*color-plum* #:*color-powder-blue*
    #:*color-purple* #:*color-red* #:*color-rosy-brown* #:*color-royal-blue*
    #:*color-saddle-brown* #:*color-salmon* #:*color-sandy-brown* #:*color-sea-green*
    #:*color-sea-shell* #:*color-sienna* #:*color-silver* #:*color-sky-blue*
    #:*color-slate-blue* #:*color-snow* #:*color-spring-green* #:*color-steel-blue*
    #:*color-tan* #:*color-teal* #:*color-thistle* #:*color-tomato* #:*color-turquoise*
    #:*color-violet* #:*color-wheat* #:*color-white* #:*color-white-smoke*
    #:*color-yellow-green*
    #:*color-3d-dark-shadow* #:*color-3d-face* #:*color-3d-highlight* #:*color-3d-light*
    #:*color-3d-shadow* #:*color-active-border* #:*color-active-caption*
    #:*color-active-caption-gradient* #:*color-app-workspace* #:*color-background*
    #:*color-button-face* #:*color-button-highlight* #:*color-button-shadow*
    #:*color-button-text* #:*color-caption-text* #:*color-destktop* #:*color-gray-text*
    #:*color-highlight* #:*color-highlight-text* #:*color-hotlight*
    #:*color-inactive-border* #:*color-inactive-caption* #:*color-inactive-caption-gradient*
    #:*color-inactive-caption-text* #:*color-menu* #:*color-menu-bar*
    #:*color-menu-highlight* #:*color-menu-text* #:*color-scroll-bar*
    #:*color-tooltip-background* #:*color-tooltip-text* #:*color-window*
    #:*color-window-frame* #:*color-window-text*
        
    #:+app-starting-cursor+
    #:+application-icon+
    #:+crosshair-cursor+
    #:+default-cursor+
    #:+error-icon+
    #:+hand-cursor+
    #:+help-cursor+
    #:+ibeam-cursor+
    #:+information-icon+
    #:+no-cursor+
    #:+question-icon+
    #:+size-all-cursor+
    #:+size-nesw-cursor+
    #:+size-ns-cursor+
    #:+size-nwse-cursor+
    #:+size-we-cursor+
    #:+up-arrow-cursor+
    #:+wait-cursor+
    #:+warning-icon+

;; methods, functions, macros
    #:accepts-file-p
    #:alpha
    #:anti-alias
    #:ascent
    #:average-char-width
    #:background-color
    #:background-pattern
    #:blue-mask
    #:blue-shift
    #:clear
    #:clipped-p
    #:clipping-rectangle
    #:color->rgb
    #:color-blue
    #:color-green
    #:color-red
    #:color-table
    #:copy-area
    #:copy-color
    #:copy-font-data
    #:copy-font-metrics
    #:copy-pixels
    #:data-object
    #:depth
    #:descent
    #:draw-arc
    #:draw-bezier
    #:draw-chord
    #:draw-ellipse
    #:draw-filled-arc
    #:draw-filled-chord
    #:draw-filled-ellipse
    #:draw-filled-pie-wedge
    #:draw-filled-polygon
    #:draw-filled-rectangle
    #:draw-filled-rounded-rectangle
    #:draw-focus
    #:draw-image
    #:draw-line
    #:draw-pie-wedge
    #:draw-point
    #:draw-poly-bezier
    #:draw-polygon
    #:draw-polyline
    #:draw-rectangle
    #:draw-rounded-rectangle
    #:draw-text
    #:fill-rule
    #:font
    #:font-data-char-set
    #:font-data-face-name
    #:font-data-point-size
    #:font-data-style
    #:foreground-color
    #:foreground-pattern
    #:green-mask
    #:green-shift
    #:height
    #:icon-bundle-length
    #:icon-image-ref
    #:invert
    #:leading
    #:line-cap-style
    #:line-dash-style
    #:line-join-style
    #:line-style
    #:line-width
    #:load
    #:make-color
    #:make-font-data
    #:make-image-data
    #:make-palette
    #:matrix
    #:maximum-char-width
    #:metrics
    #:multiply
    #:pen-style
    #:pen-width
    #:push-icon-image
    #:rgb->color
    #:red-mask
    #:red-shift
    #:rotate
    #:scale
    #:size
    #:text-anti-alias
    #:text-extent
    #:transform
    #:transform-coordinates
    #:translate
    #:transparency
    #:transparency-pixel-of
    #:transparency-mask
    #:with-image-transparency
    #:xor-mode-p

;; conditions
    ))

;;;
;;; package for UI objects
;;;
(defpackage #:graphic-forms.uitoolkit.widgets
  (:nicknames #:gfw)
  (:shadow #:step)
  (:use #:common-lisp)
#+sbcl
  (:import-from :sb-mop :ensure-generic-function)
#-sbcl
  (:import-from :clos :ensure-generic-function)
  (:export

;; classes and structs
    #:button
    #:caret
    #:color-dialog
    #:control
    #:dialog
    #:display
    #:edit
    #:event-dispatcher
    #:event-source
    #:file-dialog
    #:font-dialog
    #:flow-layout
    #:heap-layout
    #:item
    #:item-manager
    #:layout-managed
    #:layout-manager
    #:list-box
    #:menu
    #:menu-item
    #:panel
    #:root-window
    #:scrollbar
    #:scrolling-helper
    #:slider
    #:status-bar
    #:timer
    #:top-level
    #:widget
    #:window

;; constants
    #:+default-widget-height+
    #:+default-widget-width+
    #:+vk-break+
    #:+vk-backspace+
    #:+vk-tab+
    #:+vk-clear+
    #:+vk-return+
    #:+vk-shift+
    #:+vk-control+
    #:+vk-alt+
    #:+vk-pause+
    #:+vk-caps-lock+
    #:+vk-escape+
    #:+vk-page-up+
    #:+vk-page-down+
    #:+vk-end+
    #:+vk-home+
    #:+vk-left+
    #:+vk-up+
    #:+vk-right+
    #:+vk-down+
    #:+vk-insert+
    #:+vk-delete+
    #:+vk-help+
    #:+vk-left-win+
    #:+vk-right-win+
    #:+vk-applications+
    #:+vk-numpad-0+
    #:+vk-numpad-1+
    #:+vk-numpad-2+
    #:+vk-numpad-3+
    #:+vk-numpad-4+
    #:+vk-numpad-5+
    #:+vk-numpad-6+
    #:+vk-numpad-7+
    #:+vk-numpad-8+
    #:+vk-numpad-9+
    #:+vk-numpad-*+
    #:+vk-numpad-++
    #:+vk-numpad--+
    #:+vk-numpad-.+
    #:+vk-numpad-/+
    #:+vk-numpad-f1+
    #:+vk-numpad-f2+
    #:+vk-numpad-f3+
    #:+vk-numpad-f4+
    #:+vk-numpad-f5+
    #:+vk-numpad-f6+
    #:+vk-numpad-f7+
    #:+vk-numpad-f8+
    #:+vk-numpad-f9+
    #:+vk-numpad-f10+
    #:+vk-numpad-f11+
    #:+vk-numpad-f12+
    #:+vk-num-lock+
    #:+vk-scroll-lock+
    #:+vk-left-shift+
    #:+vk-right-shift+
    #:+vk-left-control+
    #:+vk-right-control+
    #:+vk-left-alt+
    #:+vk-right-alt+

;; methods, functions, macros
    #:accelerator
    #:activate
    #:alignment
    #:ancestor-p
    #:append-item
    #:append-separator
    #:append-submenu
    #:auto-hscroll-p
    #:auto-vscroll-p
    #:background-color
    #:background-pattern
    #:bar-position
    #:border-layout
    #:border-width
    #:bottom-margin-of
    #:capture-mouse
    #:caret
    #:center-on-owner
    #:center-on-parent
    #:check
    #:check-all
    #:checked-p
    #:clear-selection
    #:clear-selection-span
    #:client-size
    #:close-obj
    #:code
    #:column-at
    #:column-count
    #:column-index
    #:column-order
    #:columns
    #:compute-layout
    #:compute-outer-size
    #:compute-size
    #:copy-area
    #:copy-text
    #:cut-text
    #:current-font
    #:cursor-of
    #:data-of
    #:default-message-filter
    #:default-widget
    #:defmenu
    #:defmenu2
    #:delay-of
    #:delete-all
    #:delete-item
    #:delete-selection
    #:delete-span
    #:disabled-image
    #:dispatcher
    #:display-to-object
    #:echo-char
    #:enable
    #:enable-auto-scrolling
    #:enable-layout
    #:enable-redraw
    #:enable-scrollbars
    #:enabled-p
    #:event-activate
    #:event-arm
    #:event-close
    #:event-collapse
    #:event-deactivate
    #:event-deiconify
    #:event-dispose
    #:event-expand
    #:event-focus-gain
    #:event-focus-loss
    #:event-hide
    #:event-iconify
    #:event-key-down
    #:event-key-traverse
    #:event-key-up
    #:event-modify
    #:event-mouse-double
    #:event-mouse-down
    #:event-mouse-enter
    #:event-mouse-exit
    #:event-mouse-hover
    #:event-mouse-move
    #:event-mouse-up
    #:event-move
    #:event-paint
    #:event-pre-modify
    #:event-pre-move
    #:event-pre-resize
    #:event-resize
    #:event-scroll
    #:event-select
    #:event-session
    #:event-timer
    #:expand
    #:expanded-p
    #:focus-index
    #:focus-p
    #:foreground-color
    #:give-focus
    #:grid-line-width
    #:header-height
    #:header-visible-p
    #:iconify
    #:iconified-p
    #:id-of
    #:initial-delay-of
    #:horizontal-policy-of
    #:image
    #:inner-limits
    #:item-count
    #:item-height
    #:item-id
    #:item-index
    #:items-of
    #:key-down-p
    #:key-toggled-p
    #:label
    #:layout
    #:layout-attribute
    #:layout-of
    #:layout-p
    #:left-margin-of
    #:line-count
    #:lines-visible-p
    #:location
    #:lock
    #:locked-p
    #:make-menu
    #:mapchildren
    #:maximize
    #:maximized-p
    #:maximum-size
    #:menu
    #:menu-bar
    #:message-loop
    #:minimum-size
    #:mouse-over-image
    #:move-above
    #:move-below
    #:moveable-p
    #:obtain-chosen-color
    #:obtain-chosen-files
    #:obtain-chosen-font
    #:obtain-displays
    #:obtain-event-time
    #:obtain-horizontal-scrollbar
    #:obtain-pointer-location
    #:obtain-primary-display
    #:obtain-vertical-scrollbar
    #:outer-limit
    #:owner
    #:pack
    #:page-increment
    #:parent
    #:paste-text
    #:peer
    #:preferred-size
    #:primary-p
    #:process-events
    #:progress-bar
    #:redraw
    #:redrawing-p
    #:release-mouse
    #:reparentable-p
    #:replace-selection
    #:resizable-p
    #:retrieve-span
    #:right-margin-of
    #:scroll
    #:select
    #:select-all
    #:selected-count
    #:selected-items
    #:selected-p
    #:selected-span
    #:show
    #:show-cursor
    #:show-column
    #:show-header
    #:show-item
    #:show-lines
    #:show-selection
    #:shutdown
    #:size
    #:spacing-of
    #:startup
    #:status-bar-of
    #:step
    #:step-increment
    #:step-increments
    #:style-of
    #:sub-menu
    #:text
    #:text-baseline
    #:text-for-pasting-p
    #:text-height
    #:text-limit
    #:text-modified-p
    #:thumb-position
    #:thumb-track-position
    #:tooltip-text
    #:top-child-of
    #:top-index
    #:top-margin-of
    #:translate-point
    #:traverse
    #:traverse-order
    #:trim-sizes
    #:undo-available-p
    #:update
    #:update-scrolling-state
    #:vertical-policy-of
    #:visible-item-count
    #:visible-p
    #:with-color-dialog
    #:with-cursor
    #:with-drawing-disabled
    #:with-file-dialog
    #:with-font-dialog
    #:with-graphics-context
    #:with-root-window
    #:with-wait-cursor

;; conditions
  ))
