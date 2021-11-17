section .data               
;Change Name and Surname for your data.
developer db "_Javier_ _Ruiz_",0

;Constant that is also defined in C.
ARRAYDIM equ 5		

section .text            
;Variables defined in Assembly language.
global developer                        

;Variables defined in C.
extern charac, row, col
extern aSecret, aPlay, pos, state, tries, hX

;Assembly language subroutines called from C.
global posCurBoardP1, updatePosP1, updateArrayP1, checkSecretP1
global checkPlayP1, printHitsP1, printSecretPlayP1, playP1

;C functions that are called from assembly code.
extern clearScreen_C,  gotoxyP1_C, printchP1_C, getchP1_C
extern printBoardP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATTENTION: Remember that in assembly language the variables and parameters 
;; of type 'char' must be assigned to records of type
;; BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;; those of type 'short' must be assigned to records of type
;; WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;; those of type 'int' must be assigned to records of type
;; DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;; those of type 'long' must be assigned to records of type
;; QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; a; ;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; The assembly subroutines you need to implement are:
;;   posCurBoardP1, updatePosP1, updateArrayP1, 
;;   checkSecretP1, printSecretPlayP1, checkPlayP1, printHitsP1.  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Place the cursor at a position on the screen
; calling the gotoxyP1_C function.
; 
; Global variables used:	
; (row) : Row of the screen where the cursor is placed.
; (col) : Column of the screen where the cursor is placed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Show a character on the screen at the cursor position
; calling the printchP1_C fuction.
; 
; Global variables used:	
; (charac) : Character to show.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Read a character from the keyboard without displaying it on the screen
; and store it in the variable (charac) calling the getchP1_C function.
; 
; Global variables used:	
; (charac) : Character read from the keyboard.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp
 
   call getchP1_C

   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Place the cursor inside the board according to the position of 
; the cursor (pos) and the remaining tries (tries). 
; If we are typing the secret code (status==0) we will place 
; the cursor in row 3 (row=3), if we are typing a try (status!=0) 
; the row is calculated with the formula: (row=9+(ARRAYDIM-tries)*2).
; The column is calculated with the formula (col= 8+(pos*2)).
; Place the cursor calling the gotoxyP1 subroutine.
; 
; Global variables used:	
; (state) : State of the game.
; (tries) : Remaining tries.
; (row)   : Row of the screen where the cursor is placed.
; (col)   : Column of the screen where the cursor is placed.
; (pos)   : The place where the cursor is.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurBoardP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	
	mov eax, ARRAYDIM
	mov bx, WORD[state]
	
	cmp bx, 0							;if (state==0)
	je true
	sub eax, DWORD[tries]
	imul eax, 2
	add eax, 9
	mov DWORD[row], eax					;row=9+(ARRAYDIM-tries)*2
	jmp end
	
	true:
		mov DWORD[row], 3				;row=3
	end:
		mov eax, DWORD[pos]
		imul eax, 2
		add eax, 8
		mov DWORD[col], eax				;col=8+(pos*2)
	
	call gotoxyP1
	
	pop rax
	pop rbx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; If we have read (charac=='j') left or (charac=='k') right, update 
; the place of the cursor, index of the array of the combination, 
; checking that does not exit the positions of the array [0..4] and 
; update the index of the array (pos +/-1) as appropriate.
; You cannot go out from the area where we are typing (5 positions).
; 
; Global variables used:	
; (charac) : Character read from the keyboard.
; (pos)    : The place where the cursor is.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updatePosP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx

	mov al, BYTE[charac]
	mov ebx, DWORD[pos]

	cmp al, 'j'					;if (charac=='j')
	je true_j
	cmp ebx, ARRAYDIM - 1		;if(pos < ARRAYDIM - 1)
	jge end_update
	inc ebx						;pos++
	jmp end_update

	true_j:
		cmp ebx, 0				;if(pos > 0)
		jle end_update
		dec ebx					;pos--
		jmp end_update
		
	end_update:
		mov DWORD[pos], ebx
	
	pop rax
	pop rbx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Store the value of the read character ['0' - '9'] in the array and 
; show it on the screen.
; Get the value (val) subtracting 48 (ASCII of '0') to the character (charac).
; If (state==0) store the value (val) at the position (pos) of the 
; array (aSecret) and we will change the character read by a '*' 
; (charac = '*') for which the secret combination we write is not seen.
; If (state!=0) store the value (val) at the position (pos) of the 
; array (aPlay)
; Finally, we show the character (charac) on the screen at the position 
; where is the cursor calling the printchP1 subroutine.
; 
; Global variables used:	
; (charac)  : Character read from the keyboard.
; (state)   : State of the game.
; (aSecret) : Array where we store the secret code value of the character read.
; (aPlay)   : Array where we store the tries value of the character read.
; (pos)     : The place where we store the value read [0..4].
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateArrayP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rcx
	
	mov ax, WORD[state]
	mov bl, BYTE[charac]
	sub bl, 48								;int val = (int)(charac-'0')
	movzx ebx, bl
	mov ecx, DWORD[pos]
	
	cmp ax, 0								;if(state == 0)
	je true_typing_secret
	mov DWORD[aPlay + ecx * 4], ebx			;aPlay[pos] = val
	jmp end_update_array
	
	true_typing_secret:
		mov DWORD[aSecret + ecx * 4], ebx		;aSecret[pos] = val
		mov BYTE[charac], '*'					;charac='*'
	
	end_update_array:
		call printchP1
	
	pop rax
	pop rbx
	pop rcx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verify that the secret code (aSecret) does not have the value -3, 
; (initial value), or repeated numbers.
; For each element of the array (aSecret) check that there is no -3 and 
; that it is not repeated in the rest of the array (from the next 
; position to the current one until the end). 
; To indicate that the secret code is not correct we set (secretError = 1).
; If the secret code is correct, set (state = 1) to read tries.
; If the secret code is incorrect, set (state = 2) to request it again.
;  
; Global variables used:
; (aSecret) : Array where we store the secret code.
; (state)   : State of the game.	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkSecretP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rcx
	
	mov eax, -1			 ;init i = -1
	mov WORD[state], 1	 ;default state = 1
	
	for:
		inc eax
		cmp eax, ARRAYDIM						;for(i=0;i<ARRAYDIM;i++)
		je end_check	
		mov ecx, DWORD[aSecret + eax * 4]		
		cmp ecx, -3								;if(aSecret[i]==-3)
		je check_failed
		mov ebx, eax
		inc ebx									;j = i + 1
		second_for:
			cmp ebx, ARRAYDIM			 ;for(j = i+1;j < ARRAYDIM;j++)
			je for
			cmp ecx, DWORD[aSecret + ebx * 4] ;if(aSecret[i]==aSecret[j)
			je check_failed
			inc ebx
			jmp second_for
			

	check_failed:
		inc WORD[state]						;secretError = 1 -> state=2
	end_check:
	
	pop rax
	pop rbx
	pop rcx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show a combination of the game.
; If (state! = 1) shows the secret code (aSecret) in row 3 (row = 3), 
; if not, it shows the try (aPlay) in the row 
; (row = 9+ (ARRAYDIM-tries); 2), from column 8 (col = 8).
; For each position of the array:
; Place the cursor calling the gotoxyP1 subroutine.
; If (state! = 1) get a value from the secret code (aSecret), 
; if not, get a value from the try (aPlay), add '0' to the value gotten
; from the array to convert it to character and show it calling 
; the printchP1 subroutine.
; Increase the column 2 by 2.
; 
; Global variables used:
; (state)   : State of the game.
; (row)     : Row of the screen where the cursor is placed.
; (col)     : Column of the screen where the cursor is placed.
; (tries)   : Remaining tries.
; (aSecret) : Array where we store the secret code.
; (aPlay)   : Array where we store the tries.
; (charac)  : Character to show.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
printSecretPlayP1:
	push rbp
	mov  rbp, rsp

	push rax		
	push rbx		
	push rcx		
	push rdx		
	push rsi		
	push rdi
	
	mov ax, WORD[state]
	mov ebx, DWORD[row]
	mov ecx, ARRAYDIM
	mov edx, DWORD[col]		
	mov edx, 8						;col=8
	
	cmp ax, 1						;if(state!=1)
	je show_try
	mov ebx, 3						;row=3
	jmp init_i
	
	show_try:
		sub ecx, DWORD[tries]
		imul ecx, 2
		add ecx, 9
		mov ebx, ecx				;row=9+(ARRAYDIM-tries)*2
	
	init_i:
		mov esi, 0					;i=0
		
	for_printSecret:
		cmp esi, ARRAYDIM			;for(i=0;i<ARRAYDIM;i++)
		je end_print_secret
		mov DWORD[row], ebx
		mov DWORD[col], edx
		call gotoxyP1
		cmp ax,1					;if(state!=1)
		je print_play
		mov dil, BYTE[aSecret + esi * 4]
		add dil, '0'						;charac=aSecret[i]+'0'
		jmp print_char
		
		print_play:
			mov dil, BYTE[aPlay + esi * 4]
			add dil, '0'					;charac=aPlay[i]+'0'
		
		print_char:
			mov BYTE[charac], dil
			call printchP1
			add edx, 2						;col=col+2
			inc esi							;i++
			jmp for_printSecret
	
	end_print_secret:
	
	pop rax		
	pop rbx		
	pop rcx		
	pop rdx		
	pop rsi		
	pop rdi
	
	mov rsp, rbp
	pop rbp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Count hits in place of the try (aPlay) with respect to 
; the secret code (aSecret).
; Compare each element of the secret code (aSecret) with the element
; in the same position of the try (aPlay).
; If an element of the secret combination (aSecret[i]) is equal to 
; the element of the same position of the try (aPlay [i]): it will be
; a hit in place 'X' and the hits in place must be increased (hX ++).
; If all positions in the secret code (aSecret) and the try (aPlay) 
; are equals (hX=ARRAYDIM), we have won and the game status must be 
; modified to indicate it (state=3).
; Show the hits in place in the game board
; calling the printHitsP1 subroutine.
; 
; Compta els encerts a lloc de la jug
; Global variables used:	
; (aSecret) : Array where we store the secret code.
; (aPlay)   : Array where we store the tries.
; (state)   : State of the game.
; (tries)   : Remaining tries.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkPlayP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rcx
	
	mov eax, 0									;i=0
	mov WORD[hX], 0								;hX = 0
	
	for_check_play:								;for(i=0;i<ARRAYDIM;i++)
		cmp eax, ARRAYDIM
		je end_for_check_play
		mov ebx, DWORD[aSecret + eax * 4]		
		mov ecx, DWORD[aPlay + eax * 4]
		inc eax								;i++
		cmp ebx, ecx						;if(aSecret[i]==aPlay[i])
		jne for_check_play
		inc WORD[hX]						;hX++
		jmp for_check_play
			
	end_for_check_play:
		cmp WORD[hX], ARRAYDIM				;if(hX==ARRAYDIM)
		jne end_check_play
		mov WORD[state], 3					;state=3
		
	end_check_play:
		call printHitsP1					
		
	pop rax
	pop rbx
	pop rcx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show the hits in place.
; Place the cursor in the row (row=9+(ARRAYDIM-tr)*2) and column (col=22) 
; (right side of the board) to show the hits on the game board.
; Show as many 'X' as there are hits in place (hX).
; To show the hits, position the cursor by calling the gotoxyP1 
; subroutine and show the characters by calling the printchP1 subroutine. 
; Each time a hit is shown, the column must be increased by 2.
; NOTE: (hX must always be smaller or equal than ARRAYDIM).
; 
; Global variables used:	
; (row)    : Row of the screen where the cursor is placed.
; (col)    : Column of the screen where the cursor is placed.
; (tries)  : Remaining tries.
; (charac) : Character to show.
; (hX)     : Hits in place.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printHitsP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx

	mov eax, ARRAYDIM
	sub eax, DWORD[tries]
	imul eax, 2
	add eax, 9
	mov DWORD[row], eax						;row=9+(ARRAYDIM-tries)*2
	
	mov ebx, 22
	mov DWORD[col], ebx							;col=22
	
	mov BYTE[charac], 'X'						;charac='X'
	
	mov ax, WORD[hX]							;i=hX
	for_print_hits:
		cmp ax, 0							;for(i=hX;i>0;i--)
		je end_print_hits
		call gotoxyP1
		call printchP1
		add ebx, 2
		mov DWORD[col], ebx					;col=col+2
		dec ax								;i--
		jmp for_print_hits
	
	end_print_hits:
	
	pop rax
	pop rbx
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Show a message at the bottom right of the game board according to the 
; value of the variable (status)calling the printMessageP1_C function. 
; (state) 0: We are typing the secret code.
;         1: We are typing a tray.
;         2: The secret code has the initial values or repeted values.
;         3: Won, try = secret code.
;         4: The tries have run out.
;         5: Press ESC to exit
; Is expected to press a key to continue. 
; Show a message below on the  game board to indicate this, 
; and pressing a key, it is deleted.
; 
; Global variables used:	
; (row)   : Row of the screen where the cursor is placed.
; (col)   : Column of the screen where the cursor is placed.
; (state) : State of the game.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP1:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call printMessageP1_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Main game function
; Read the secret code and verify that it is correct.
; Then a try is read, compare the try with 
; the secret code to check the hits in place.
; Repeat the process until the secret code is guessed or 
; while there aren't tries left. If 'ESC' key is pressed while reading
; the secret code or a try, exit.
; 
; Pseudo-code:
; The player has 5 tries to guess the secret code, the initial state 
; of the game is 0 and the cursor is set to position 0.
; Show the game board by calling the printBoardP1_C function.
; Show a message to indicate that the secret code must be typed 
; by calling the printMessageP1 subroutine.
; While (state == 0) read the secret code or (state == 2) read
; the secret code because it wasn't correct:
; - Set the initial state of the game to 0 (state = 0).
;   While not pressing [ESC] or [ENTER]:
;   - Place the cursor on the game board calling the posCurBoardP1 subroutine.
;   - Read a key calling the getchP1 subroutine.
;   - If a 'j' (left) or a 'k' (right) has been read, move the cursor 
;     by the 5 positions of the combination, updating the index of 
;     the array (pos +/- 1) calling the  updatePosP1 subroutine.
;     (can't leave the area where we are typing (5 positions)).
;   - If a valid character is read ['0' - '9'] we store it in the 
;     array (aSecret), if (status == 0) we will change the character 
;     read to a '*' so that the secret code we type can't be seen 
;     and show this character on the screen at the position where 
;     the cursor is calling the updateArrayP1 subroutine.
;   - If ESC(27) is read, set (state = 5) to exit.
; 
;   If [ESC] has not been pressed (state! = 5) call the checkSecretP1 
;   subroutine to check if the secret code has a -3 or has repeated 
;   numbers and display a message calling the printMessageP1 subroutine
;   indicating that the tries can now be typed (state = 1) if the secret 
;   code is correct or that the secret code is incorrect (state = 2).
; 
;   While (state == 1) we are typing tries:
;   - Initialize the cursor position to 0 (pos = 0).
;   - Show the remaining tries (tries) to guess the secret code, 
;     place the cursor in row 21, column 5 calling the gotoxyP1 
;     subroutine and show the character associated with the value of the 
;     variable (tries) adding '0' and calling the printchP1.
;   - Show the try we have in the array (aPlay), initially it will be 
;     ("00000") and can be modified.
; 
;     While [ESC] or [ENTER] aren't pressed:
;     - Place the cursor on the game board by calling the 
;       posCurBoardP1.
;     - Read a key calling the getchP1.
;     - If a 'j' (left) or a 'k' (right) has been read, move the cursor 
;       by the 5 positions of the combination, updating the index of 
;       the array (pos +/- 1) calling the  updatePosP1 subroutine.
;       (can't leave the area where we are typing (5 positions)).
;     - If a valid character is read ['0' - '9'] we store it in the 
;       array (aPlay) and show the character on the screen at 
;       the position where the cursor is calling 
;       the updateArrayP1 subroutine.
;     - If an ESC(27) has been read, set (state = 5) to exit.
; 
;    If [ESC] is not pressed (state! = 5) call the chekPlaysP1 
;    subroutine to count the hits in place of the try (aPlay) 
;    with respect to the secret code (aSecret), 
;    if the try is equal, position by position, to the secret code, 
;    we won the game (state = 3).
;    We decrease the tries (tries), and if there are no tries left 
;    (tries == 0) and we didn't guess the secret code (state == 1), 
;    we lost the game (state = 4).
; 
; Finally, show the secret code calling the printSecretPlayP1 
; subroutine. In addition, show the remaining tries (tries) to guess the  
; secret code, place the cursor in row 21, column 5 by calling the 
; gotoxyP1 subroutine and show the character associated with the 
; value of the variable (tries) by adding '0' and calling the 
; printchP1 subroutine, finally show the message indicating the 
; reason calling the printMessageP1 subroutine.
; Game over.
; 
; Global variables used:	
; (state)  : State of the game.
; (tries)  : Remaining tries.
; (charac) : Character read from the keyboard and to show.
; (pos)    : The place where the cursor is.
; (row)    : Row of the screen where the cursor is placed.
; (col)    : Column of the screen where the cursor is placed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
playP1:
   push rbp
   mov  rbp, rsp 
   
   push rcx
   
   mov  WORD[state], 0
   mov  DWORD[tries], 5
   mov  DWORD[pos], 0
   
   call printBoardP1_C        ;printBoardP1_C();
   call printMessageP1        ;printMessageP1_C();

   P1_while1:
   cmp WORD[state], 0         ;while (state == 0 
   je  P1_while1ok
   cmp WORD[state], 2         ;|| state==2) {
   jne P1_endwhile1
     P1_while1ok:
     mov WORD[state], 0       ;state=0;
     P1_do1:                  ;do {
       call posCurBoardP1     ;posCurBoardP1_C();
       call getchP1           ;charac = getchP1_C();
       mov  cl, BYTE[charac]
   
       cmp cl, 'j'            ;if ((charac=='j') 
       je  P1_if11
       cmp cl, 'k'            ;|| (charac=='k')){
       jne P1_endif11        
       P1_if11:
         call updatePosP1     ;pos = updatePosP1_C();
       P1_endif11:            ;}
       
       cmp cl, '0'            ;if (charac>='0' 
       jl P1_endif12
       cmp cl, '9'            ;&& charac<='9'){  
       jg P1_endif12
         call updateArrayP1   ;updateArrayP1_C();
       P1_endif12:            ;}
       
       cmp cl, 27             ;if (charac== 27) {
       jne P1_endif13
         mov WORD[state], 5   ;state = 5;    
       P1_endif13:            ;}
       
     cmp cl,10                ;} while ((c!=10) 
     je  P1_enddo1
     cmp cl, 27               ;&& (charac!=27)); 
     jne P1_do1
     P1_enddo1:              
     
     cmp WORD[state], 5       ;if (state!=5) {
     je  P1_endif14
       call checkSecretP1     ;checkSecretP1_C();
       call printMessageP1    ;printMessageP1_C();
     P1_endif14:              ;}
     
   jmp P1_while1 
   P1_endwhile1:              ;}
     
   P1_while2:                 ;while (state == 1)
   cmp WORD[state], 1                
   jne  P1_endwhile2
     mov  DWORD[pos], 0       ;pos=0;
     mov  DWORD[row], 21
     mov  DWORD[col], 5
     call gotoxyP1            ;gotoxyP1_C();
     mov  edi, DWORD[tries]
     add  dil, '0'
     mov  BYTE[charac], dil   ;charac=tries + '0';
     call printchP1           ;printchP1_C();
     call printSecretPlayP1   ;printSecretPlayP1_C();

     P1_do2:                  ;do {
       call posCurBoardP1     ;posCurBoardP1_C();
       call getchP1           ;getchP1_C();
	   mov  cl, BYTE[charac]
	   
       cmp cl, 'j'            ;if ((charac=='j') 
       je  P1_if21
       cmp cl, 'k'            ;|| (charac=='k')){
       jne P1_endif21        
       P1_if21:
         call updatePosP1     ;pos = updatePosP1_C();     
       P1_endif21:            ;}
       
       cmp cl, '0'            ;if (charac>='0' 
       jl P1_endif22
       cmp cl, '9'            ;&& charac<='9'){  
       jg P1_endif22
         call updateArrayP1   ;updateArrayP1_C();
       P1_endif22:            ;}
       
       cmp cl, 27             ;if (charac == 27) {
       jne P1_endif23
         mov WORD[state], 5   ;state = 5;    
       P1_endif23:            ;}
       
     cmp cl,10                ;} while ((charac!=10) 
     je  P1_enddo2
     cmp cl, 27               ;&& (charac!=27)); 
     jne P1_do2
     P1_enddo2:              
     
     cmp WORD[state], 5              ;if (state!=5) {
     je  P1_endif24
       call checkPlayP1       ;checkPlayP1_C();
	   dec DWORD[tries]       ;tries--;
	   cmp DWORD[tries], 0    ;if (tries == 0 
	   jne P1_endif25
	   cmp WORD[state], 1     ;&& state == 1) {
	   jne P1_endif25
         mov WORD[state], 4   ;state = 4;   
       P1_endif25:            ;}
     P1_endif24:              ;}
     
   jmp P1_while2
   P1_endwhile2:              ;} 
   
   mov  DWORD[row], 21
   mov  DWORD[col], 5
   call gotoxyP1              ;gotoxyP1_C();
   mov  edi, DWORD[tries]
   add  dil, '0'
   mov  BYTE[charac], dil     ;charac=tries + '0';
   call printchP1             ;printchP1_C();
   call printSecretPlayP1     ;printSecretPlayP1_C();
   call printMessageP1        ;printMessage_C();
   P1_end:
   
   pop rcx
   
   mov rsp, rbp
   pop rbp
   ret
