; *******************************************************************************
; Function	  : UpdTbl
; Description : This function changes factor width of a text inside drawing table block.
; Author	  : Michal Scibior
; Date		  : May, 2022
; *******************************************************************************

(defun UpdTbl()
	;zbierz wszystkie bloki do zbioru
	;UWAGA! Niektórych bloków nie da się wyszukać po ich zwykłej nazwie! Są to bloki dynamiczne (Dynamic blocks), szukaj w google!
	(setq tables (ssget "X" '((0 . "INSERT") (2 . "AFRY_Namnruta100_BH90"))))
	;licznik ctr do funkcji while
	(setq ctr 0)
	;ilość bloków w zbiorze
	(setq len (sslength tables))

	;powtórz operacje dla wszystkich elementów
	(while (/= ctr len)
		;elementu zbioru na podstawie licznika
		(setq table (ssname tables ctr))
		;properties dla tego elementu
		(setq tablep (entget table))
		;wartość (cdr) dla argumentu 0 (typ elementu) dla danego elementu aby znaleźć atrybuty ("ATTRIB")
		(setq blktype (cdr (assoc 0 tablep)))
		
		;druga pętla, wyznaczenie działań tylko na atrybutach (SEQEND - element zamykający strukturę bloku (INSERT, ATTRIB, SEQEND))
		;SUBENTITY - ATTRIB/SEQEND; ENTITY - INSERT
		(while (/= blktype "SEQEND")
			;nadpisujemy properties elementu zbioru wskazując na ID elementu następnego po elemencie INSERT (blok). Będzie to ATTRIB
			(setq tablep (entget (entnext (cdr (assoc -1 tablep)))))
			;aktualizujemy zmienną blktype (typ elementu) na rzecz pętli while
			(setq blktype (cdr (assoc 0 tablep)))
			
			;filtrujemy typ elementu tylko na atrybuty
			(if (= blktype "ATTRIB")
				(progn
					;definiujemy TAG atrybutu
					(setq tagname (cdr (assoc 2 tablep)))
					
					;filtrujemy TAG
					(if (= tagname "RITN_NR")
						(progn
							;definiujemy zmienną dla wartości atrybutu
							(setq width (cdr (assoc 41 tablep)))
							
							;filtrujemy wartości atrybutu
							;definiujemy nową wartość SZEROKOŚCI (argument 41) atrybutu w properties elementu i aktualizujemy
							(progn
								(setq widn (subst (cons 41 0.85) (assoc 41 tablep) tablep))
								(entmod widn)
								(entupd table)
							)
						)
					)
				)
			)
		)
	(setq ctr (1+ ctr))
	)
(princ)
)

(UpdTbl)