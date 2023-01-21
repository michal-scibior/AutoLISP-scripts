; *******************************************************************************
; Function	  : CLRS
; Description : This function deletes every element on listed layers.
; Author	  : Michal Scibior
; Date		  : April, 2019
; *******************************************************************************
(defun c:clrs ()
	(setq soils (ssget "X" '((-4 . "<OR") 
		(8 . "GSC3D-berg939495markpoly") 
		(8 . "GSC3D-Moran") 
		(8 . "GSC3D-Fyllning") 
		(8 . "GSC3D-Sand") 
		(8 . "GSC3D-Torv") 
		(-4 . "OR>"))))
	(command "erase" soils "")
	(NOVA2AG 20)
	(princ)
)