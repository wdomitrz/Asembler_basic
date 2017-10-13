SECTION .data
tekst db 'Hello World', 0x0A, 0x00	; tu zapisałem sobie tekst do wypisania

SECTION .text
global _start

_start:					; tu zaczynam wykonywanie kodu
	mov edx, 12			; wrzucam długość tekstu na edx
	mov ecx, tekst			; wrzucam tekst na ecx
	mov ebx, 1			; wrzucam oznaczenie, że wyjście ma być wrzucone do stdout
	mov eax, 4			; wrzucam kod sys_write na eax
	int 0x80			; wykonuję funkcję z podanymi wcześniej argumentami
	mov ebx, 0			; wrzucam kod wyjścia 0 na ebx (brak błędów)
	mov eax, 1			; wrzucam kod sys_exit na eax
	int 0x80			; uruchamiam funkcję z tymi argumentami


