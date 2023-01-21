; *******************************************************************************
; Function	  : SETPATHS
; Description : This function sets paths of your product's plot setting files.
; Author	  : Michal Scibior
; Date		  : May, 2020
; *******************************************************************************

(vl-load-com)
(defun setpaths ( / *files* doc) 

(setq *files*  (vla-get-files  (vla-get-preferences (vlax-get-Acad-object))))
(setq paths (vla-get-PrinterConfigPath *files*))
(setq XXXpaths "S:\\Library\\AF-Autodesk\\PrinterSupportFiles\\Plotters;")
(setq newpath (strcat XXXpaths paths))
(vla-put-PrinterConfigPath *files* newpath)

; printers style sheet
(setq paths (vla-get-PrinterStyleSheetPath *files*))
(setq XXXpaths "S:\\Library\\AF-Autodesk\\PrinterSupportFiles\\PlotStyles;")
(setq newpath (strcat XXXpaths paths))
(vla-put-PrinterStyleSheetPath *files* newpath)

; printer drv's
(setq paths (vla-get-PrinterDescPath *files*))
(setq XXXpaths "S:\\Library\\AF-Autodesk\\PrinterSupportFiles\\PMP-Files;")
(setq newpath (strcat XXXpaths paths))
(vla-put-PrinterDescPath *files* newpath)

;make new support paths exist + new
(setq paths (vla-get-SupportPath *files*))
(setq XXXpaths "S:\\Library\\AF-Autodesk\\SupportFiles\\Block;S:\\Library\\AF-Autodesk\\SupportFiles\\Font;S:\\Library\\AF-Autodesk\\SupportFiles\\Lin;S:\\Library\\AF-Autodesk\\SupportFiles\\Lisp;S:\\Library\\AF-Autodesk\\SupportFiles\\Script;")
(setq newpath (strcat XXXpaths paths))
(vla-put-SupportPath *files* newpath)

(princ "All Done")
) ; defun

(setpaths)
