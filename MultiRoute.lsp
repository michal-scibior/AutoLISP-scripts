; *******************************************************************************
; Function	  : MultiRoute
; Description : This function utilizes MAGICAD functions to export polylines from cables/conduits on a given layer.
; Author	  : Michal Scibior
; Date		  : April, 2019
; *******************************************************************************
(defun c:MultiRoute ()
	(setq ctr 0)
	(setq layer (getstring "\nPodaj nazwe warstwy z przewodami: "))
	;trzeba użyć list i cons aby zadzialala zmienna w ssget
	(setq secik (ssget "X" (list 
		(cons -4 "<OR") 
		(cons -4 "<AND")(cons 0 "MAGIELECTRICALCABLE")(cons 8 layer)(cons -4 "AND>")
		(cons -4 "<AND")(cons 0 "MAGIELECTRICALCONDUIT")(cons 8 layer)(cons -4 "AND>")
		(cons -4 "<AND")(cons 0 "MAGIELECTRICALCABLEPACKET")(cons 8 layer)(cons -4 "AND>")
		(cons -4 "OR>")))
	)
	(setq ilosc (sslength secik))
	(while (/= ctr ilosc)
		(setq conduitn (ssname secik ctr))
		(setq conduitprop (entget conduitn))
		(setq xyz (cdr (assoc 10 conduitprop)))
		(command "zoom" "c" xyz "50")
		(command "isolateobjects" conduitn "")
		(command "_MAGIESHOWCABLEPATH" xyz)
		(setq ctr (1+ ctr))
	)
	(command "unisolateobjects")
	(alert (strcat "\nZnalazlem "  (itoa (sslength secik)) " przewodow na tej warstwie."))
(princ)
)

(print "Uzyj komendy MultiRoute")	
