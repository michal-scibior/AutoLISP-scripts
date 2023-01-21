; *******************************************************************************
; Function	  : AltToPoint
; Description : This function elevates points to Z value based on the closest text element.
; Author	  : Michal Scibior
; Date		  : November, 2020
; *******************************************************************************

(defun c:AltToPoint ()
	
	;twórz grupę z punktami; funkcja while kolejkuje każdy punkt
	(setq points (ssget "X" '((0 . "POINT"))))
	(setq ctr 0)
	(setq lpoints (sslength points))
	
	(vl-cmdf "._zoom" "_E")
	
	(while (/= ctr lpoints)
		;dla każdego punktu wczytuję współrzędne
		(setq point (ssname points ctr))
		(setq pointp (entget point))
		(setq pointx (cadr (assoc 10 pointp)))
		(setq pointy (caddr (assoc 10 pointp)))

		;LIST tworzy listę ze zmiennych, ' tworzy listę z ciągów liczb!!!
		(setq point1 (list (- pointx 0.6) (- pointy 0.6)))
		(setq point2 (list (+ pointx 0.6) (- pointy 0.6)))
		(setq point3 (list (+ pointx 0.6) (+ pointy 0.6)))
		(setq point4 (list (- pointx 0.6) (+ pointy 0.6)))

		(setq ptlist (list point1 point2 point3 point4))
		
		;if zapewnia, że selection set nie jest pusty, a jeżeli jest to entsel 
		(if (setq TEXTS (ssget "_CP" ptlist '((0 . "TEXT"))))
			
			(progn 
				(setq ltexts (sslength texts))
				;dla 1 elementu uruchom automat bez entsel
				(if (= 1 ltexts)
					(progn
						(command "chprop" point "" "c" "red" "")
						(setq text (ssname texts 0))
						(command "chprop" text "" "c" "green" "")
						;Zamień tekst na wartość Z
						(setq textp (entget text))
						(setq alt (cdr (assoc 1 textp)))
						;zmiana tekstu na liczbę rzeczywistą hardkodowana. Lepiej użyć funkcji z VisualLISP do rozdzielania tekstów LeeMaca
						(setq altv (atof (strcat (substr alt 1 1) "." (substr alt 3))))
						(command "_change" point "" "_P" "_E" altv "")
						
					)
					(progn
					;jeżeli w selection set jest więcej niż jeden element to entsel
						(command "zoom" "_window" point1 point3)
						(command "chprop" point "" "c" "red" "")
						;while nil zapętla entsel dopóki nie zostanie wybrany element
						(while (= nil (setq text (car (entsel "\nWybierz tekst odpowiadajacy punktowi: ")))))
						(command "chprop" text "" "c" "green" "")
						(setq textp (entget text))
						(setq alt (cdr (assoc 1 textp)))
						(setq altv (atof (strcat (substr alt 1 1) "." (substr alt 3))))
						(command "_change" point "" "_P" "_E" altv "")
					
					)
				)
			)
			;jeżeli brak elementu w zadanym obrębie to entsel:
			(progn
			(command "zoom" "_window" point1 point3)
			(command "chprop" point "" "c" "red" "")
			(while (= nil (setq text (car (entsel "\nWybierz tekst odpowiadajacy punktowi: ")))))
			(command "chprop" text "" "c" "green" "")
			(setq textp (entget text))
			(setq alt (cdr (assoc 1 textp)))
			(setq altv (atof (strcat (substr alt 1 1) "." (substr alt 3))))
			(command "_change" point "" "_P" "_E" altv "")
			)
		)
	
	(setq ctr (1+ ctr))
	)
	(prompt "\nUdalo sie! Huurrra!")
	(princ)
)
