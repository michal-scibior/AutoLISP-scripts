;			(entget (car (entsel))) - !ENTITY!
;			(setvar "cmdecho" 0) - 

(defun c:qwe ()
	(command "layer" "s" "warstwa" "")
	(command "insert" "qwe123" "_m2p" pause "" "" "")
	)
	
(defun c:CoQ ()
	(setq ss (ssget "X" '((0 . "INSERT") (2 . "qwe123"))))
	(setq count (sslength ss))
	(alert (strcat "Total block in the drawing: " (itoa count)))
(princ)
)

(defun c:LM ()
	(setq newlayer (getstring "\nEnter mew layer name: "))
	(setq ltype (getstring "\nEnter linetype of the layer: "))
	(setq color (getstring "\nEnter color of the layer: "))
	(command "layer" "m" newlayer "lt" ltype "" "c" color "" "")
	(prompt (strcat "\nLayer: " newlayer " created"))
(princ)
)
;licz do dziesięciu
(defun c:PrintNum()
	(setq flag T)
	(setq ctr 1)
	(while flag
		(if (< ctr 11)
			(progn
				(print ctr)
				(setq ctr (1+ ctr))
			)
			(setq flag nil)
		)
	)
(princ)
)

(defun c:Cel2Fah()
	;getreal każe użytkownikowi podać liczbę rzeczywistą
	(setq cel (getreal "\nEnter Celsius: "))
	(setq result (+ 32 (* cel 1.8)))
	;rtos - real to string
	(prompt (strcat "\n" (rtos cel) " Celsius --> " (rtos result) " Fahrenheit."))
(princ)
)

(defun c:DrawText ()
	;pick 1st point
	(setq ptx (getpoint "\nEnter base point: "))
	;assume the angle
	(setq ang (getangle ptx "\nPick direction"))
	;calculate the given degree
	(setq deg (Rad2Deg ang))
	;draw the text
	(command "text" "j" "l" ptx "100" deg "AutoLISP")
(princ)
)
	;how to radians to degrees
	(defun Rad2Deg (ang)
		(/ (* ang -180.0) pi)
	)
	
(defun c:EraseLast ()
	(initget "Y N")
	;getkeyword każe użytkownikowi wybrać i przyjmuje jedną z wartości w nawiasie kwadratowym
	(setq ans (getkword "\nDelete last object [Y/N]?"))
	(if (= ans "Y")
	;progn - wykonuje każdy kolejny ciąg i zwraca ostatni
		(progn
		;entlast zwraca entity name ostatniego, nie-usuniętego elementu
			(command "erase" (entlast) "")
			(prompt "\nLast object deleted.")
		)
		(prompt "\nLast object was spared.")
	)
	(princ)
)

;entsel każe użytkownikowi wybrać element (entity)
(defun c:UsingEntsel ()
	(setq ln (car (entsel "\nSelect the element")))
	(command "list" ln "")
	(princ)
)

;entlast zwraca entity name ostatniego, nie-usuniętego elementu
(defun c:UsingEntlast ()
	(setq elast (entlast))
	(command "list" elast "")
	(princ)
)

;entnext zwraca Entity name następnego elementu (entnext entiy_name)
;jeżeli nie podamy poprzedzającego elementu tylko (entnext) - zwraca pierwszy element w modelu
(defun c:UsingEntnext ()
	(setq obj (entnext))
	(command "chprop" obj "" "c" "red" "")
	(princ)
)

;wyświetl właściwości elementu Entity
(defun c:UsingEntget ()
	;entget potrzebuje entity name do działania
	(setq lprop (entget (car (entsel "\nSelect a line: "))))
	(print lprop)
	(princ)
)

;stwóz zbiory i wykonuj operacje na nich
(defun c:PaintItRed ()
	;ssget - tworzy Selection Set na podstawie w zależności od trybu i filtrów: http://www.lee-mac.com/ssget.html
	;"X" - szukaj wszędzie
	;lista możliwych entities https://www.autodesk.com/techpubs/autocad/acad2000/dxf/index.htm
	(setq lines (ssget "X" '((0 . "LINE"))))
	(setq polylines (ssget "X" '((0 . "LWPOLYLINE"))))
	(setq circles (ssget "X" '((0 . "CIRCLE"))))
	(setq texts (ssget "X" '((0 . "TEXT"))))
	(command "chprop" lines polylines circles texts "" "c" "red" "")
	(prompt "\nPainting in red completed")
	(princ)
)

;dodaje element do zbioru (selection set)
(defun c:AddObject ()
	(setq new (car (entsel "\nSelect a line to be added to the selection set")))
	(setq ss (ssadd new ss))
	(prompt "\nLine object was added")
	;sslength - długość albo liczba elementów
	(setq len (sslength ss))
	;strcat - łączy tekst
	;itoa - integer to ASCII
	(prompt (strcat "\nThere are now " (itoa len) " lines in the drawing."))
	(princ)
)

;usuń element z selection set
(defun c:DelObject ()
	(setq ss (ssget "X" '((0 . "LINE"))))
	(setq len (sslength ss))
	(prompt (strcat "\nThere are " (itoa len) " lines in the selection set."))
	(prompt "\nDeleting one object using ssdel.")
	;ssname - zwraca nazwę danego elementu zbioru
	(setq ename (ssname ss 0))
	;ssdel - usuwa ze zbioru element o danej nazwie
	(setq ss (ssdel ename ss))
	(setq len (sslength ss))
	(prompt (strcat "\nThere are " (itoa len) " lines in the selection set."))
	(princ)
)

;czy element zawiera się w selection set?
(defun c:IsMember ()
	;ssget w podstawowym trybie każe zaznaczyć elementy
	(setq ss (ssget))
	(setq obj (car (entsel "\nSelect an object to verify if it's within the selection set")))
	;ssmemb zwraca nazwę ss jeżeli element znajduję się w tym ss, jeśli nie to nil
	(if (/= (ssmemb obj ss) nil)
		(prompt "\nThe selected object IS part of the selection set")
		(prompt "\nThe selected object is NOT part of the selection set")
	)
	(princ)
)

;wyświetl właściwość elementu - promień
(defun c:GetRadius ()
	(setq ss (ssget "X" '((0 . "CIRCLE"))))
	;ssname zwraca nazwę danego elementu zbioru
	(setq cir1 (ssname ss 0))
	(setq cir1e (entget cir1))
	;assoc szuka i zwraca wartość z danej listy, promień to (40 . promień), assoc zwraca (40 . promień)
	(setq r1 (cdr (assoc 40 cir1e)))
	;rtos - real to string
	(prompt (strcat "\nThe radius of the 1st circle is " (rtos r1 2) " metres."))
	(setq cir2 (ssname ss 1))
	(setq cir2e (entget cir2))
	(setq r2 (cdr (assoc 40 cir2e)))
	(prompt (strcat "\nThe radius of the 2nd circle is " (rtos r2 2) " metres."))
	(princ)
)

;wyświetl ilość elementów
(defun c:GetNumber  ()
	(setq lines (ssget "X" '((0 . "LINE"))))
	(alert (strcat "\nThere are "  (itoa (sslength lines)) " lines in the selection set."))
	
	(setq plines (ssget "X" '((0 . "LWPOLYLINE") (8 . "Road"))))
	(alert (strcat "\nThere are "  (itoa (sslength plines)) " lines in the selection set."))
	
	(princ)
)

(defun c:LayerChange ()
	(setq el (car (entsel "\nSelect an object to have its layer changed to NewLayer: ")))
	(setq elent (entget el))
	
	;subst (substitute) - tworzy nową listę zamieniając wszystkie występujące w innej liście "stare" na "nowe" wartości
	;jeżeli nie znajduje żadnych "starych" to zwraca listę bez zmian
	;(subst czym_zamienić co_zamienić gdzie_szukać)
	
	;cons (construct) - tworzy nową listę dodając element na początek istniejącej listy
	
	;list - tworzy nową listę ze chcianych elementów
	(setq elentnew (subst (cons 8 "NewLayer") (assoc 8 elent) elent))
	;entmod aktualizuje informacje wewnątrz pliku
	(entmod elentnew)
	;entupd aktualizuje wyświetlanie tego elementu po zaktualizowaniu informacji (czy to potrzebne?)
	(entupd el)
	(princ)
)

(defun c:changedim()
	(setq d1 (car (entsel "\nSelect a dimension: ")))
	(setq dp (entget d1))
	(setq dpn (subst (cons 3 "STANDARD") (assoc 3 dp) dp))
	(setq dpn2 (subst (cons 8 "0") (assoc 8 dpn) dpn))
	(entmod dpn2)
	(entupd d1)
	(prompt "\nDone.")
	(princ)
)

(defun c:changedims()
	(setq dims (ssget "X" '((0 . "DIMENSION"))))
	(setq ctr 0)
	(setq ldim (sslength dims))
	(while (/= ctr ldim)
		(setq d1 (ssname dims ctr))
		(setq dp (entget d1))
		(setq dpn (subst (cons 3 "STANDARD") (assoc 3 dp) dp))
		(setq dpn2 (subst (cons 8 "0") (assoc 8 dpn) dpn))
		(entmod dpn2)
		(entupd d1)
		(setq ctr (1+ ctr))
	)
	(prompt "\nDone")
(princ)
)

;DO ZMIANY ATRYBUTÓW W BLOKACH
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
					(if (= tagname "BLAD")
						(progn
							;definiujemy zmienną dla wartości atrybutu
							;atoi przekształci 001 na 1
							(setq blad (atoi (cdr (assoc 1 tablep))))
							
							;filtrujemy wartości atrybutu
							(if (< blad 10)
								;definiujemy nową wartość atrybutu w properties elementu i aktualizujemy
								;itoa przekształci 1 z powrotem na 001 (po dodaniu 1+), strcat złączy dwa stringi
								(progn
									(setq bladn (subst (cons 1 (strcat "00" (itoa (1+ blad)))) (assoc 1 tablep) tablep))
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

;DO ZAZNACZENIA WYMIARÓW, KTÓRE ZOSTAŁY ZEDYTOWANE
(defun c:CDIM()
	;cmdecho wyłącza wyświetlanie akcji lispów z okienka komend
	(setq echo (getvar "cmdecho"))
	(setvar "cmdecho" 0)
	(setq ctr 0)
	(setq dims (ssget "X" '((0 . "DIMENSION"))))
	;jeżeli istnieją jakieś wymiary
	(if (/= dims nil)
		(progn
			;stwórz zbiór na zmienione wymiary
			(setq mdims (ssadd))
			(setq dimcount (sslength dims))
			(while (/= ctr dimcount)
				(setq dnam (ssname dims ctr))
				(setq pnam (entget dnam))
				(setq dimtx (cdr (assoc 1 pnam)))
				;dodaj zmienione wymiary do tego zbioru
				(if (/= dimtx "")
					(setq mdims (ssadd dnam mdims))
				)
				(setq ctr (1+ ctr))
			)
			;jeżeli istnieją zmienione wymiary zmień ich kolor na czerwony
			(if (/= (sslength mdims) 0)
				(progn
					(command "chprop" mdims "" "c" "red" "")
			(prompt (strcat "\nThere are "(itoa (sslength mdims))" modified dimensions found."))
					(prompt "\nPlease verify dimensions in Red color.")
				)
				(prompt "\nNo modified dimensions found.")
			)
		)
		(prompt "\nNo Dimension Entity found.")
	)
(setvar "cmdecho" echo)	
(princ)
)


;DO HURTOWEJ ZMIANY STYLU TEKSTÓW
(defun c:CHSTYLE ()
	(setq oldstyle (getstring "\nEnter the name of the style to be changed: "))
	(setq newstyle (getstring "\nEnter the name of the new style: "))
	(setq flag T)
	;cond - działa jak if, ale z wieloma warunkami. Wszystkie działania, których warunki zostały spełnione zostaną wprowadzone. 
	;dla cond formuła "else" zadziała tak jak "else" przy IF jeżeli zastosuje się: (t (else do this))
	(cond	((= nil (tblsearch "style" oldstyle))
				(princ "\nOld style not found")
				(setq flag nil)
			)
			((= nil (tblsearch "style" newstyle))
				(princ "\nNew style not found")
				(setq flag nil)
			)
			((= T flag)
				;funkcja ChangeStyle - część właściwa całego lispa
				(ChangeStyle oldstyle newstyle)
			)
	)
(princ)
)

(defun Changestyle (oldstyle newstyle / txs ctr tcount tx txp txpn)
	(setq txs (ssget "X" (list (cons 7 oldstyle))))
	(if (/= nil txs)
		(progn
			(setq ctr 0)
			(setq tcount (sslength txs))
			(while (< ctr tcount)
				;\r zastępuję poprzednią linijkę
				(prompt (strcat "\rProcessing object no. " (itoa (1+ ctr)) " of " (itoa tcount) "."))
				(setq tx (ssname txs ctr))
				(setq txp (entget tx))
				(setq txpn (subst (cons 7 newstyle) (assoc 7 txp) txp))
				(entmod txpn)
				(entupd tx)
				(setq ctr (1+ ctr))
			)
			;
			(terpri)
			(princ "\nDone.")
		)
		(princ "\nNo object found in specified style.")
	)
)