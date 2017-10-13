;Zakładam, że zerowa liczba Fibonacciego to 0, a piersza to 1.

;Aby przywrócić interfejs należy odkomentować liniki 5, 6, 15, 16

;SECTION .data
;instrukcja db 'Prosze podac ktora liczbe Fibonacciego mam wypisac. Zerowa to 0, a pierwsza to 1: '

SECTION .bss
n: resb 255

SECTION .text
global  _start

_start:
	;mov eax, instrukcja
	;call	wypisz
	mov	edx, 255				; długość
	mov	ecx, n				; zarezerwowane miejsce w pamięci
	mov	ebx, 0				; pisz do pliku stdin
	mov	eax, 3				; użyj sys_read
	int	0x80				; użyj opisanej komendy
	mov	eax, n
	call	dlugosc
	mov	ecx, eax
	dec	ecx
	mov	eax, n
	call	str_na_int
	mov	ecx, eax			; którą liczbę mam wypisać
	mov	eax, 0				; zerowa liczba Fibonacciego
	mov	ebx, 1				; pierwsza liczba Fibonacciego
	mov	edx, 0				; która liczba jest przechowywana przez eax
	push	esi				; esi to u mnie zmienna pomocnicza
petla:
	cmp	edx, ecx
	jz	pisz
	mov	esi, ebx
	add	ebx, eax
	mov	eax, esi
	inc	edx
	call	petla
	
	pisz:
	pop	esi
	call	wypisz_int
	call	endl
	call	koniec

; zamiana stringa na inta
str_na_int:
	mov	ebx, 0
kolejna_cyfra:
	movzx	edx, byte[eax]
	inc	eax
	sub	edx, 48
	imul	ebx, 10
	add	ebx, edx
	dec	ecx
	cmp	ecx, 0
	jnz	kolejna_cyfra
	mov	eax, ebx
	ret


; wypisywanie inta
wypisz_int:
	push	eax		
	push	ebx
	push	ecx
	push	edx
	mov	ebx, 10				; do dzielenia z resztą
	mov	ecx, 0				; liczba znaków do wypisani
tnij:
	inc	ecx					; dodaję nowy znak do wypisania
	mov	edx, 0				; opróżniam edx
	idiv	ebx				; dzielę eax przez 10. edx trzyma resztę.
	add	edx, 48				; kody ascii 0-9 są od 48 do 57
	push	edx				; dodaję miejsce na kolejny znak
	cmp	eax, 0				; sprawdzam, czy jest sens jeszcze dzielić
	jnz	tnij
wypiszznaki:
	mov	eax, esp
	call	wypisz
	pop	eax
	dec	ecx
	cmp	ecx, 0
	jnz	wypiszznaki
	pop	eax
	pop	ebx
	pop	ecx
	pop	edx
	ret

; liczenie długości stringa
dlugosc:
	push	ebx				; dodaję miejsce pomocnicze na ebx
	mov     ebx, eax			; i kopiuję na nie eax
petladl:
	cmp     byte [eax], 0			; sprawdzenie, czy już doszliśmy do końca
	jz      zakoncz				; jeśli tak, to idź do koniec
	inc     eax				; zwiększamy eax o 1
	jmp     petladl				; wracamy na początek pętli
zakoncz:
	sub     eax, ebx			; odejmuję od eax (wskazuje na koniec stringa) ebx (wskazuje na początek stringa)
	pop     ebx				; usuwam wartość pomocniczą z ebx
	ret					; kończę funkcję

; wypisywanie stringa
wypisz:
	push	edx				; dodaję dodatkowe pola na eax, ebx, ecx, edx
	push	ecx
	push	ebx
	push	eax
	call	dlugosc				; liczę długość i zapisuję ją w edx
	mov	edx, eax
	pop	eax
	mov	ecx, eax			; dodaję tekst do wypisannia
	mov	ebx, 1				; wybieram stdout jako wyjście
	mov	eax, 4				; eax 4 to sys_write
	int	0x80				; uruchamiam komendę z dantymi parametrami
	pop	ebx				; usuwam nieusunięte pomocnicze pola
	pop	ecx
	pop	edx
	ret					; kończę funkcję

; wypisz endline
endl:
	push	eax				; dodaję dodatkowe pole na eax
	mov	eax, 0x0A			; dodaję znak końca linii na eax
	push	eax				; przesuwam znacznik na eax o 1
	mov	eax, esp			; wracam na miejsce gdzie jest znak końca linii
	call	wypisz				; wypisuję endline
	pop	eax         			; usuwam pomocnicze pola
	pop	eax         
	ret					; kończę funkcję
  
; zakończ program
koniec:
	mov	ebx, 0				; argument 0 to brak błędów
	mov	eax, 1				; 1 z eax to sys_exit
	int	0x80				; uruchamiam funkcję z tymi argumentami
	ret					; kończę funkcję
