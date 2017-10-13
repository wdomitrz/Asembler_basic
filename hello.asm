SECTION .data
tekst    db      'Hello world', 0x00	; tekst do wypisania
 
SECTION .text
global  _start

_start:
	mov	eax, tekst
	call	wypisz
	call	endl
	call	koniec

; liczenie długości stringa
dlugosc:
	push	ebx				; dodaję miejsce pomocnicze na ebx
	mov     ebx, eax			; i kopiuję na nie eax
petla:
	cmp     byte [eax], 0			; sprawdzenie, czy już doszliśmy do końca
	jz      zakoncz				; jeśli tak, to idź do koniec
	inc     eax				; zwiększamy eax o 1
	jmp     petla				; wracamy na początek pętli
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
