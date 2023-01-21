; *******************************************************************************
; Function	  : AFPurge
; Description : This function purges the drawing file from unnecessary data, elevates clouds and alerts user if there are any lines on the cloud layer.
; Author	  : Michal Scibior
; Date		  : February, 2021
; *******************************************************************************

(defun c:AFPurge ( / ss Layout1 revlay ssrevc revcn ctr ctrelev revc revce ssrevli ssrevlin)

	;Liczę chmurki na zadanej warstwie i podnoszę na Z=100 te, które trzeba
	(setq revlay (cdr (assoc 8 (entget (car (entsel "\nWybierz chmurke aby wskazac warstwe: "))))))
	(setq ssrevc (ssget "X" (list (cons 0 "LWPOLYLINE") (cons 8 revlay))))
	(setq revcn (sslength ssrevc))
	(setq ctr 0)
	(setq ctrelev 0)
	(while (/= ctr revcn)
		(setq revc (ssname ssrevc ctr))
		(setq revce (entget revc))
		(if (/= (cdr (assoc 38 revce)) 100)
			(progn
				(setq ctrelev (1+ ctrelev))
				(command "_change" revc "" "_P" "_E" 100 "")
			)
		)
	
		(setq ctr (1+ ctr))
	)

	;Liczę linie na tej warstwie i daje alert
	(setq ssrevli (ssget "X" (list (cons 0 "LINE") (cons 8 revlay))))
	(setq ssrevlin (sslength ssrevli))
	(alert (strcat (itoa ctrelev) " z " (itoa revcn) " chmurek zostalo zmienionych na wysokosc Z=100." "\nNa rysunku znajduje sie " (itoa ssrevlin) " linii na tej warstwie"))

	;Purge i SetByLayer
	(command "_.Purge" "_All" "*" "_No"
		"_.-purge" "_R" "_All" "_No" 
		"_.Setbylayer" "_All" "" "_Yes" "_No")
	
	;jeżeli Layout nie jest pusty (albo nie zawiera tylko rzutni) to przełącz na Layout
	(setq Layout1 (car (layoutlist)))
	(if (setq ss (ssget "A" (list (cons 410 Layout1) (cons 0 "~VIEWPORT"))))
		(command "_.TILEMODE" "0")
		;to samo co:
		;(command "_.CTAB" Layout1)
		()
	)
	
	;zapisz w wersji ("2000", "2004", "2007", "2010", "2013" lub "2018") - właściwy wpisz w linijce niżej
	(command "_.SAVEAS" "2013" (strcat (getvar "dwgprefix") (getvar "dwgname")) "_Yes")

(princ)
)
(print "Komenda: AFPurge")