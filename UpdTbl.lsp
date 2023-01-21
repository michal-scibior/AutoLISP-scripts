; *******************************************************************************
; Function	  : UpdTbl
; Description : This function replaces sheet numbers in drawing tables with subsequent numbers starting with 001
; Author	  : Michal Scibior
; Date		  : November, 2020
; *******************************************************************************

(defun c:UpdTbl()
	;zbierz wszystkie bloki do zbioru
	;UWAGA! Niektórych bloków nie da się wyszukać po ich zwykłej nazwie! Są to bloki dynamiczne (Dynamic blocks), szukaj w google!
	(setq tables (ssget "X" '((0 . "INSERT") (2 . "AF"))))
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
		;wartość (cdr) dla argumentu 0 (typ elementu) dla danego elementu aby znaleźć atrybuty
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
					(if (= tagname "BLAD")
						(progn
							;definiujemy zmienną dla wartości atrybutu
							;atoi przekształci 001 na 1
							(setq blad (atoi (cdr (assoc 1 tablep))))
							
							;filtrujemy wartości atrybutu
							(if (< blad 9)
								;definiujemy nową wartość atrybutu w properties elementu i aktualizujemy
								;itoa przekształci 1 z powrotem na 001 (po dodaniu 1+), strcat złączy dwa stringi
								(progn
									(setq bladn (subst (cons 1 (strcat "00" (itoa (1+ blad)))) (assoc 1 tablep) tablep))
									(entmod bladn)
									(entupd table)
								)
								(progn
									(setq bladn (subst (cons 1 (strcat "0" (itoa (1+ blad)))) (assoc 1 tablep) tablep))
									(entmod bladn)
									(entupd table)
								)
							)
						)
					)
					(if (= tagname "NASTA_BLAD")
						(progn

							(setq blad (atoi (cdr (assoc 1 tablep))))

							(if (< blad 9)

								(progn
									(setq bladn (subst (cons 1 (strcat "00" (itoa (1+ blad)))) (assoc 1 tablep) tablep))
									(entmod bladn)
									(entupd table)
								)
								(progn
									(setq bladn (subst (cons 1 (strcat "0" (itoa (1+ blad)))) (assoc 1 tablep) tablep))
									(entmod bladn)
									(entupd table)
								)
							)
						)
					)
				)
			)
		)
	(setq ctr (1+ ctr))
	)
	(prompt "\nBlad +1 Done")
(princ)
)
