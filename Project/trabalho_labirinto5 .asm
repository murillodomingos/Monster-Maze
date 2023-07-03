; Hello World - Escreve mensagem armazenada na memoria na tela


; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 preto						1111 0000


jmp main

resp: var #1          ; Resposta do jogador se quer ir de novo
Letra: var #1		; Contem a letra que foi digitada
posJogador: var #1			; Contem a posicao atual do jogador
posAntJogador: var #1		; Contem a posicao anterior do jogador
posDino: var #1;		; Contem a posicao do dinossauro
posAntDino: var #1		; Contem a posicao anterior do dinossauro
IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos

	


mensagem2 : string "Ola Mundo!"

;---- Inicio do Programa Principal -----
main:
	loadn r0, #0
	store posJogador, r0		; Zera Posicao Atual do Jogador
	store posAntJogador, r0	; Zera Posicao Anterior do Jogador
	loadn r0, #0
	store posDino, r0
	store posAntDino, r0
	loadn r1, #0
	store IncRand, r1
	loadn r1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn r2, #0  			; cor branca!

	;call ImprimeTela 
	loadn r7, #tela0Linha0 ; Endereço do mapa onde o jogador está
	call loop
	;halt
	
loop:
	loadn r1, #10
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/10)==0
		ceq MoveJogador	; Chama Rotina de movimentacao do Jogador
	
		loadn r1, #10
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/30)==0
		ceq MoveDino	; Chama Rotina de movimentacao do Dino
	; call MoveJogador
	; call MoveDino
	call Fog
	call CondicaoVitoria
	call Delay
	inc r0 	;c++
	call Dinocomeu
	jmp loop
	;halt	; Fim do programa -> qd ele é comido ou qd ele ganha
	
;---- Fim do Programa Principal -----
	
;---- Inicio das Subrotinas -----
Dinocomeu:
	push r0
	push r1
	load r0, posJogador	
	load r1, posDino
	cmp r0, r0
	jeq Dinopositivo
	pop r0
	pop r1
	rts

Dinopositivo:
	push r1
	loadn r1, #tela1Linha0
	call Delay3
	call ImprimeTela
	call Delay3
	pop r1
	push r1
	loadn r1, #tela2Linha0
	call Delay3
	call ImprimeTela
	call Delay3
	pop r1
	push r1
	loadn r1, #tela3Linha0
	call Delay3
	call ImprimeTela
	call Delay3
	pop r1
	push r1
	loadn r1, #tela4Linha0
	call Delay3
	call ImprimeTela
	call Delay3
	pop r1
	push r1
	loadn r1, #tela5Linha0
	call Delay3
	call ImprimeTela
	call Delay3
	pop r1
	push r1
	loadn r1, #tela6Linha0
	call ImprimeTela
	call Delay2
	pop r1
	jmp FimDeJogoWinLoop
	rts
	
	
MoveJogador:
	push r0
	push r1
	
	call MoveJogador_RecalculaPos		; Recalcula Posicao da Jogador

; So' Apaga e Redesenha se (pos != posAnt)
;	If (posJogador != posAntJogador)	{	
	load r0, posJogador
	load r1, posAntJogador
	cmp r0, r1
	jeq MoveJogador_Skip
		call MoveJogador_Apaga
		call ApagaTela
		call MoveJogador_Desenha
		 ;call Fog		;}
  MoveJogador_Skip:
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveJogador_Apaga:		; Apaga a Jogador preservando o Cenario!
	push r0
	push r1
	load r0, posAntJogador	; R0 = posAnt
	loadn r1, #' '	; R5 = Char (Tela(posAnt))
	outchar r1, r0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	pop r1
	pop r0
	rts
;----------------------------------	
	
MoveJogador_RecalculaPos:		; Recalcula posicao da Jogador em funcao das Teclas pressionadas
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6

	load r0, posJogador
	inchar r1; Le Teclado para controlar a Jogador
	loadn r2, #'a'
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_A
	
	loadn r2, #'d'
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_D
		
	loadn r2, #'w'
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_W
		
	loadn r2, #'s'
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_S

  MoveJogador_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posJogador, r0
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

  MoveJogador_RecalculaPos_A:	; Move Jogador para Esquerda
	loadn r1, #40
	loadn r2, #0
	mod r1, r0, r1		; Testa condicoes de Contorno 
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_Fim
	loadn r4, #' '
	loadn r6, #1
	sub r6, r7, r6
	loadi r5, r6 ; r6 = posição onde o personagem quer mover
	cmp r5, r4 ; verifica se mapa[posição_futura] =  ' '
	jne MoveJogador_RecalculaPos_Fim
	dec r0	; pos = pos -1
	dec r7  ; mapa[pos] = mapa[pos] - 1
	jmp MoveJogador_RecalculaPos_Fim
	
	
		
  MoveJogador_RecalculaPos_D:	; Move Jogador para Direita	
	loadn r1, #40
	loadn r2, #39
	mod r1, r0, r1
			; Testa condicoes de Contorno 
	cmp r1, r2
	jeq MoveJogador_RecalculaPos_Fim
	loadn r4, #' '
	loadn r6, #1
	add r6, r7, r6
	loadi r5, r6 ; r6 = posição onde o personagem quer mover
	cmp r5, r4 ; verifica se mapa[posição_futura] =  ' '
	jne MoveJogador_RecalculaPos_Fim
	inc r0	; pos = pos + 1
	inc r7  ; mapa[pos] = mapa[pos] + 1
	jmp MoveJogador_RecalculaPos_Fim
	
  MoveJogador_RecalculaPos_W:	; Move Jogador para Cima
	loadn r1, #40
	loadn r2, #41
	cmp r0, r1
			; Testa condicoes de Contorno 
	jle MoveJogador_RecalculaPos_Fim
	loadn r4, #' '
	sub r6, r7, r2
	loadi r5, r6 ; r6 = posição onde o personagem quer mover
	cmp r5, r4 ; verifica se mapa[posição_futura] =  ' '
	jne MoveJogador_RecalculaPos_Fim
	sub r0, r0, r1 ; pos = pos - 40
	sub r7, r7, r2 ; ; mapa[pos] = mapa[pos] - 41
	jmp MoveJogador_RecalculaPos_Fim

  MoveJogador_RecalculaPos_S:	; Move Jogador para Baixo
	loadn r1
	, #1159
	loadn r2, #41
	cmp r0, r1
			; Testa condicoes de Contorno 
	jgr MoveJogador_RecalculaPos_Fim
	loadn r4, #' '
	add r6, r7, r2
	loadi r5, r6 ; r6 = posição onde o personagem quer mover
	cmp r5, r4 ; verifica se mapa[posição_futura] =  ' '
	jne MoveJogador_RecalculaPos_Fim
	loadn r1, #40
	
	add r0, r0, r1 ; pos = pos + 40
	add r7, r7, r2 ; mapa[pos] = mapa[pos] + 41
	jmp MoveJogador_RecalculaPos_Fim	
	
;----------------------------------
MoveJogador_Desenha:	; Desenha caractere da Jogador
	push r0
	push r1
	loadn r1 , #'}'	; Jogador
	load r0, posJogador
	outchar r1
	, r0
	store posAntJogador, r0	; Atualiza Posicao Anterior da Jogador = Posicao Atual
	
	pop r1
	
	pop r0
	rts



CondicaoVitoria:
	push r0
	push r1
	load r0, posJogador
	loadn r1, #1198
	cmp r0, r1
	jeq FimDeJogoWin
	pop r1
	pop r0
	rts


FimDeJogoWin:
	push r1
	loadn r1, #tela7Linha0
	call Delay1
	call ImprimeTela
	call Delay1
	pop r1
	call Telapergunta
	call FimDeJogoWinLoop
	

FimDeJogoWinLoop:
	push r0
	push r1
	loadn r1, #255
	call Telapergunta
	RespLoop:
		inchar r0
		cmp r0, r1
		jeq FimDeJogoWinLoop
	store resp, r0
	pop r1
	pop r0
	jmp Verifica


Verifica:
	push r0
	push r1
	push r2
	loadn r0, #'s'
	loadn r1, #'n'
	load r2, resp
	cmp r0, r2
	jeq Telasim
	cmp r0, r2
	jne FimDeJogoWinEnd
	jmp FimDeJogoWinLoop
	pop r2
	pop r1
	pop r0	
	
Telapergunta:
	push r1
	loadn r1, #tela8Linha0
	call Delay1
	call ImprimeTela
	call Delay1
	pop r1 
	call ApagaTela
	push r1
	loadn r1, #tela9Linha0
	call Delay1
	call ImprimeTela
	call Delay1
	pop r1
	rts
	
Telasim:
	push r1
	loadn r1, #tela10Linha0
	call ImprimeTela
	call Delay2
	call ApagaTela
	pop r1
	jmp main



FimDeJogoWinEnd:
	push r1
	loadn r1, #tela11Linha0
	call ImprimeTela
	call Delay2
	call ApagaTela
	pop r1
	halt





	
Imprimestr:		;  Rotina de Impresao de Mensagens:    
				; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
				; r1 = endereco onde comeca a mensagem
				; r2 = cor da mensagem
				; Obs: a mensagem sera' impressa ate' encontrar "/0"
				
;---- Empilhamento: protege os registradores utilizados na subrotina na pilha para preservar seu valor				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

ImprimestrLoop:	
	loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
	cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
	jeq ImprimestrSai	; goto Final da rotina
	add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
	outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
	inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
	inc r1				; incrementa o ponteiro para a mensagem na memoria
	jmp ImprimestrLoop	; goto Loop
	
ImprimestrSai:	
;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts		; retorno da subrotina
	
ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn r0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn r3, #40  	; Incremento da posicao da tela!
	loadn r4, #41  	; incremento do ponteiro das linhas da tela
	loadn r5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call Imprimestr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts


	
	; Declara uma tela vazia para ser preenchida em tempo de execussao:
	
Fog:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	load r0, posJogador ;coloca a posição nova do jogador no r0
	loadn r1, #tela0Linha0 ;posição inicial da matriz do labirinto
	loadn r2, #18 ;maximo de números do vetor
	loadn r3, #0 ;atual posição no vetor
	loadn r4, #posFog ;vetor de posições para imprimir
	loadn r7, #40 ;total de caracteres por linha
	
	Fog_loop_soma:
		loadi r5, r4 ;r5 recebe o que está no endereço de memória r5 = posFog[i]
		add r5, r0, r5 ;soma a posição do jogador com posFog[i]
		div r6, r5, r7 ;divide a soma por 40 para ver quantas linhas abaixo está a nova posição
		add r6, r6, r5 ;soma a quantidade de linhas com r5 pois matrizes tem 41 caractéres por linha
		add r6, r6, r1 ;r6 = &tela0linha0[r6]
		call Fog_loop_print
		inc r3 ;r3++ para comparar com o número de atributos no vetor posFog
		inc r4 ;r4++ para pegar o próximo número de posFog
		cmp r3, r2 ;compara para ver se o r3 eh igual a 18
		jle Fog_loop_soma
	
	loadn r4, #posFog ;vetor de posições para imprimir
	loadn r3, #0 ;atual posição no vetor
		
	Fog_loop_sub:
		loadi r5, r4 ;r5 recebe o que está no endereço de memória r5 = posFog[i]
		sub r5, r0, r5 ;substrai a posição do jogador com posFog[i]
		div r6, r5, r7 ;divide a soma por 40 para ver quantas linhas abaixo está a nova posição
		add r6, r6, r5 ;soma a quantidade de linhas com r5 pois matrizes tem 41 caractéres por linha
		add r6, r6, r1 ;r6 = &tela0linha0[r6]
		call Fog_loop_print
		inc r3 ;r3++ para comparar com o número de atributos no vetor posFog
		inc r4 ;r4++ para pegar o próximo número de posFog
		cmp r3, r2 ;compara para ver se o r3 eh igual a 18
		jle Fog_loop_sub
		
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
Fog_loop_print:
			push r0
			push r1
			push r3
			push r4
			load r0, posDino
			loadn r4, #256
			loadi r3, r6 ;r3 = *r6
			cmp r0, r5
			jeq Fog_loop_printDino
			jmp Else_printDino
			

Fog_loop_printDino:
	
	loadn r1, #'~'	; Dino
	outchar r1, r0
	store posAntDino, r0
	pop r4
	pop r3
	pop r1
	pop r0
	rts

Else_printDino:
	add r3, r3, r4
	outchar r3, r5 ;imprime o r3 na posição r5

	pop r4
	pop r3
	pop r1
	pop r0
	rts

ApagaTela:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	load r2, posJogador
	loadn r3, #0
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		cmp r0, r2
		jeq ApagaTela_Loop_Skip
		outchar r1, r0
		cmp r0, r3
		jne ApagaTela_Loop
		
		ApagaTela_Loop_Skip:
		cmp r0, r3
		jne ApagaTela_Loop
 
	pop r3
	pop r2
	pop r1
	pop r0
	rts	

MoveDino:
	push r0
	push r1
	
	call MoveDino_RecalculaPos
	
; So' Apaga e Redezenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posDino
	load r1, posAntDino
	cmp r0, r1
	jeq MoveDino_Skip
		call MoveDino_Apaga
		call MoveDino_Desenha		;}
  MoveDino_Skip:
	
	pop r1
	pop r0
	rts
		
; ----------------------------
		
MoveDino_Apaga:
	push r0
	push r1

	load r0, posAntDino	; R0 == posAnt

  MoveDino_Apaga_Skip:	
  
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn r1, #' '
  
  MoveDino_Apaga_Fim:	
	outchar r1, r0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop r1
	pop r0
	rts
;----------------------------------	
; sorteia nr. randomico entre 0 - 7
;					switch rand
;						case 0 : posNova = posAnt -41
;						case 1 : posNova = posAnt -40
;						case 2 : posNova = posAnt -39
;						case 3 : posNova = posAnt -1
;						case 4 : posNova = posAnt +1
;						case 5 : posNova = posAnt +39
;						case 6 : posNova = posAnt +40
;						case 7 : posNova = posAnt +41
	
MoveDino_RecalculaPos:
	push r0 ;Posicao do dinossauro
	push r1	; Incremento
	push r2 ; Comeco do vetor Rand
	push r3 ; O numero randomico em si
	push r4;
	push r5
	push r6
	push r7
	load r0, posDino


; sorteia nr. randomico entre 1 - 4
	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r3, r2 		; busca nr. randomico da memoria em R3
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #80
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveDino_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
	MoveDino_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++

; Switch Rand (r3)

 ; Case 1 : posDino = posDino -40
   MoveDino_RecalculaPos_Case1:
	loadn r2, #1
	cmp r3, r2	; Se Rand = 1
	jne MoveDino_RecalculaPos_Case2
	loadn r1, #40
	sub r0, r0, r1
	call MoveDino_TemParede_Sub
	jmp MoveDino_RecalculaPos_FimSwitch	; Break do Switch

 ; Case 3 : posDino = posDino - 1
   MoveDino_RecalculaPos_Case2:
	loadn r2, #2	; Se Rand = 2
	cmp r3, r2
	jne MoveDino_RecalculaPos_Case3
	loadn r1, #1
	sub r0, r0, r1
	call MoveDino_TemParede_Sub
	jmp MoveDino_RecalculaPos_FimSwitch	; Break do Switch

 ; Case 4 : posDino = posDino + 1	
   MoveDino_RecalculaPos_Case3:
	loadn r2, #3	; Se Rand = 3
	cmp r3, r2
	jne MoveDino_RecalculaPos_Case4
	loadn r1, #1
	add r0, r0, r1
	call MoveDino_TemParede_Soma
	jmp MoveDino_RecalculaPos_FimSwitch	; Break do Switch

 ; Case 6 : posDino = posDino + 40
   MoveDino_RecalculaPos_Case4:
	loadn r2, #4	; Se Rand = 4
	cmp r3, r2
	jne MoveDino_RecalculaPos_FimSwitch
	loadn r1, #40
	add r0, r0, r1
	call MoveDino_TemParede_Soma
	jmp MoveDino_RecalculaPos_FimSwitch	; Break do Switch	

 ; Fim Switch:
  MoveDino_RecalculaPos_FimSwitch:	
	store posDino, r0	; Grava a posicao alterada na memoria
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

 MoveDino_TemParede_Soma:
 	loadn r4, #' '
 	loadn r3, #tela0Linha0
 	loadn r6, #40
	div r2, r0, r6 ;divide a soma por 40 para ver quantas linhas abaixo está a nova posição
	add r2, r0, r2 ;soma a quantidade de linhas com r5 pois matrizes tem 41 caractéres por linha
	add r3, r2, r3 ;r6 = &tela0linha0[r6]
	loadi r5, r3
	cmp r5, r4
	jne ErroParedeSoma
	rts
  
  
 MoveDino_TemParede_Sub:
 	loadn r4, #' '
 	loadn r3, #tela0Linha0
 	loadn r6, #40
	div r2, r0, r6 ;divide a soma por 40 para ver quantas linhas abaixo está a nova posição
	add r2, r0, r2 ;soma a quantidade de linhas com r5 pois matrizes tem 41 caractéres por linha
	add r3, r2, r3 ;r6 = &tela0linha0[r6]
	loadi r5, r3
	cmp r5, r4
	jne ErroParedeSub
	rts

;----------------------------------
ErroParedeSub: 
	add r0, r0, r1
	rts
	
ErroParedeSoma:
	sub r0, r0, r1
	rts

MoveDino_Desenha:
	push r0	

	load r0, posDino
	store posAntDino, r0

	pop r0
	rts

;----------------------------------
;----------------------------------
;--------------------------

Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #50  ; a
	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts							;return



		
Delay1:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #1000  ; a
	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #10000	; b
	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts	
	
Delay2:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #10000  ; a
	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #7000	; b
	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts	
	
Delay3:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #1000  ; a
	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #15000	; b
	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts		
		
		
	
	
	

tela0Linha0  : string "  tttttttttttttttttttttttttttttttttttttt"
tela0Linha1  : string "t    t                  t              t"
tela0Linha2  : string "t tt t ttt ttt tttt t ttttt tttttttttt t"
tela0Linha3  : string "t t  t   t t t t  t t t t t     t      t"
tela0Linha4  : string "t tttttt t t t t tt t t t t t t t tttt t"
tela0Linha5  : string "t  t   t t t t t    t t t t t t t t  t t"
tela0Linha6  : string "tt t ttt t   t t tttt t t t   t t t  t t"
tela0Linha7  : string "t    t   ttttt ttt    t t t t t t t tt t"
tela0Linha8  : string "t tttt t t      t  tt t t t t t t t    t"
tela0Linha9  : string "t      t t tttt t tt  t     t t t tttt t"
tela0Linha10 : string "t tttttt t t    t t  tt ttttt        t t"
tela0Linha11 : string "t t      t t tttt t tt      tttttttt t t"
tela0Linha12 : string "t ttt tttt t      t t  tttt t        t t"
tela0Linha13 : string "t t t t    t tttttt t ttt t tttttt ttt t"
tela0Linha14 : string "t t t t t tt t    t     t t    t t t t t"
tela0Linha15 : string "t t t ttt t  tttt t ttt t t tttt t t t t"
tela0Linha16 : string "t   t     t       t t     t      t   t t"
tela0Linha17 : string "t tttttt tttttttttt ttttt t tttttttt   t"
tela0Linha18 : string "t t    t t t     t    t   t t   t  t ttt"
tela0Linha19 : string "t t tt t t t ttt t tttttt t t t tt t t t"
tela0Linha20 : string "t   tt t t t t t t      t t   t    t t t"
tela0Linha21 : string "t t tt t t t t   tt ttttttt ttttt  t t t"
tela0Linha22 : string "t t    t t t tttttt t   t   t   tttt t t"
tela0Linha23 : string "t tttttt t t    t t t t t t t t t      t"
tela0Linha24 : string "t        t t tt t t t t t t t t t tt t t"
tela0Linha25 : string "t tttt ttt t tt t t t t t t t t t  t t t"
tela0Linha26 : string "t t  t t   t    t t t     t t t    t t t"
tela0Linha27 : string "t t tt t ttttt tt t ttt ttt t tttttt t t"
tela0Linha28 : string "t t               t     t       t    t t"
tela0Linha29 : string "tttttttttttttttttttttttttttttttttttttt t"

posFog : var #18
static posFog + #0, #1
static posFog + #1, #2
static posFog + #2, #3
static posFog + #3, #37
static posFog + #4, #38
static posFog + #5, #39
static posFog + #6, #40
static posFog + #7, #41
static posFog + #8, #42
static posFog + #9, #43
static posFog + #10, #78
static posFog + #11, #79
static posFog + #12, #80
static posFog + #13, #81
static posFog + #14, #82
static posFog + #15, #119
static posFog + #16, #120
static posFog + #17, #121

Rand : var #80		; Tabela de nr. Randomicos entre 1 - 4
	static Rand + #0, #3
	static Rand + #1, #4
	static Rand + #2, #1
	static Rand + #3, #2
	static Rand + #4, #1
	static Rand + #5, #4
	static Rand + #6, #3
	static Rand + #7, #3
	static Rand + #8, #4
	static Rand + #9, #1
	static Rand + #10, #2
	static Rand + #11, #3
	static Rand + #12, #4
	static Rand + #13, #1
	static Rand + #14, #2
	static Rand + #15, #3
	static Rand + #16, #2
	static Rand + #17, #1
	static Rand + #18, #2
	static Rand + #19, #1
	static Rand + #20, #3
	static Rand + #21, #4
	static Rand + #22, #4
	static Rand + #23, #3
	static Rand + #24, #4
	static Rand + #25, #4
	static Rand + #26, #2
	static Rand + #27, #2
	static Rand + #28, #3
	static Rand + #29, #3
	static Rand + #30, #3
	static Rand + #31, #1
	static Rand + #32, #3
	static Rand + #33, #1
	static Rand + #34, #2
	static Rand + #35, #2
	static Rand + #36, #3
	static Rand + #37, #4
	static Rand + #38, #2
	static Rand + #39, #3
	static Rand + #40, #3
	static Rand + #41, #2
	static Rand + #42, #1
	static Rand + #43, #3
	static Rand + #44, #2
	static Rand + #45, #4
	static Rand + #46, #4
	static Rand + #47, #2
	static Rand + #48, #3
	static Rand + #49, #3
	static Rand + #50, #3
	static Rand + #51, #1
	static Rand + #52, #1
	static Rand + #53, #2
	static Rand + #54, #2
	static Rand + #55, #3
	static Rand + #56, #1
	static Rand + #57, #3
	static Rand + #58, #1
	static Rand + #59, #1
	static Rand + #60, #3
	static Rand + #61, #3
	static Rand + #62, #2
	static Rand + #63, #3
	static Rand + #64, #1
	static Rand + #65, #4
	static Rand + #66, #1
	static Rand + #67, #2
	static Rand + #68, #1
	static Rand + #69, #4
	static Rand + #70, #3
	static Rand + #71, #3
	static Rand + #72, #3
	static Rand + #73, #4
	static Rand + #74, #3
	static Rand + #75, #1
	static Rand + #76, #3
	static Rand + #77, #2
	static Rand + #78, #3
	static Rand + #79, #2
	
	
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "                zzz                     "
tela1Linha5  : string "                zzzz                    "
tela1Linha6  : string "                zzzz                    "
tela1Linha7  : string "                 zz                     "
tela1Linha8  : string "               zz  z                    "
tela1Linha9  : string "               zzzzz                    "
tela1Linha10 : string "              zzzzzz z                  "
tela1Linha11 : string "              z zzzzzz                  "
tela1Linha12 : string "               zzzzzz                   "
tela1Linha13 : string "               zzzzzzzz                 "
tela1Linha14 : string "             zzzz                       "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "



tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "               zzzz                     "
tela2Linha6  : string "               zzzz                     "
tela2Linha7  : string "              z zz z                    "
tela2Linha8  : string "              zzzzzz                    "
tela2Linha9  : string "               zzzz                     "
tela2Linha10 : string "              z    z                    "
tela2Linha11 : string "             zzz  zzz                   "
tela2Linha12 : string "            zzzzzzzzzz                  "
tela2Linha13 : string "           zz zzzzz  z                  "
tela2Linha14 : string "           z  zzzzz                     "
tela2Linha15 : string "             zzzzzzz                    "
tela2Linha16 : string "            zzzzzzzzz                   "
tela2Linha17 : string "            zzzzzzzzz                   "
tela2Linha18 : string "             zz z zz                    "
tela2Linha19 : string "           zzzz  zzzz                   "
tela2Linha20 : string "                  zzzzz                 "
tela2Linha21 : string "                                        "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "



tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "               zzzzz                    "
tela3Linha7  : string "              zzzzzzz                   "
tela3Linha8  : string "              z zzz z                   "
tela3Linha9  : string "              zzzzzzz                   "
tela3Linha10 : string "             zzzzzzzz                   "
tela3Linha11 : string "             z{{{{{{z                   "
tela3Linha12 : string "            zzz    |zz                  "
tela3Linha13 : string "            zzz|  |zzzz                 "
tela3Linha14 : string "            zzzz||zzzzzz                "
tela3Linha15 : string "           zzzzzzzzzzzzzz               "
tela3Linha16 : string "          zzzzzzzzzzzz zzz              "
tela3Linha17 : string "          zz zzzzzzzz   zz              "
tela3Linha18 : string "         zzz zzzzzzzz                   "
tela3Linha19 : string "        zzz zzzzzzzzzz                  "
tela3Linha20 : string "        zz  zzzzzzzzzz                  "
tela3Linha21 : string "           zzzzzzzzzzzz                 "
tela3Linha22 : string "          zzzzzzzzzzzzzz                "
tela3Linha23 : string "          zzzzzzzz  zzzz                "
tela3Linha24 : string "           zzzz zz zzz                  "
tela3Linha25 : string "            zzz zzzzzzz                 "
tela3Linha26 : string "           zzz  zzz zzzzz               "
tela3Linha27 : string "         zzzzz                          "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "



tela4Linha0  : string "                                        "
tela4Linha1  : string "               zzzzzzzz                 "
tela4Linha2  : string "              zzzzzzzzzz                "
tela4Linha3  : string "             zzzzzzzzzzzz               "
tela4Linha4  : string "             zz  zzzz  zz               "
tela4Linha5  : string "             zzz zzzz zzz               "
tela4Linha6  : string "             zzzzzzzzzzzz               "
tela4Linha7  : string "              zzzz z zzzz               "
tela4Linha8  : string "             z{{zzzzzzz{zz              "
tela4Linha9  : string "           zzzz {{{{{{{ zz              "
tela4Linha10 : string "          zzzzz||     |zzz              "
tela4Linha11 : string "         zzzz zzz     zzzz              "
tela4Linha12 : string "        zzzz  zzz|| ||zzzzzz            "
tela4Linha13 : string "       zzzz  zzzzzz|zzzzzzzzz           "
tela4Linha14 : string "       zzz  zzzzzzzzzzzzzzzzzz          "
tela4Linha15 : string "            zzzzzzzzzzzzz zzzzz         "
tela4Linha16 : string "           zzzzzzzzzzzzzzzz  zzz        "
tela4Linha17 : string "           zzzzzzzzzzzzzzzz   zzz       "
tela4Linha18 : string "           zzzzzzzzzzzzzzzz    zz       "
tela4Linha19 : string "           zzzzzzzzzzzzzzzz  z          "
tela4Linha20 : string "            zzzzzzzzzzzzzz  zz          "
tela4Linha21 : string "             zzzzzzzzzzzzzzzzz          "
tela4Linha22 : string "              zzzzzzzzzzzzzzz           "
tela4Linha23 : string "               zzz zzzzzzz              "
tela4Linha24 : string "             zzzzz  zzzz                "
tela4Linha25 : string "            zzzzzz   zzz                "
tela4Linha26 : string "          zzzzzzzz   zzzz               "
tela4Linha27 : string "                     zzzzz              "
tela4Linha28 : string "                     zzzzzzz            "
tela4Linha29 : string "                                        "



tela5Linha0  : string "zzzz zz   zzzzzzzzzzzzzzzzzzz    z zzzzz"
tela5Linha1  : string "zzzzzzz   zzzzzzzzzzzzzzzzzzz     z zzzz"
tela5Linha2  : string "zzzz    zzzzzzzzzzzzzzzzzzzzzz    zzzzzz"
tela5Linha3  : string "       zzzzzzzzzzzzzzzzzzzzzzzz     zzzz"
tela5Linha4  : string "       zzzzzzzzzzzzzzzzzzzzzzzz      zzz"
tela5Linha5  : string "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz        "
tela5Linha6  : string "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz      "
tela5Linha7  : string "zzzzzzzzzzzzzz   zzzzzzzzzzzzzzzzzzzz   "
tela5Linha8  : string "zzzzzzzzzzzz      zzzzz   zzzzzzzzzzzzz "
tela5Linha9  : string "zzzzzzzzzzzzzz   zzzzzz    zzzzzzzzzzzzz"
tela5Linha10 : string "zz zzz   zzzzzzzzzzzzzzz    zzzzzzzzzzzz"
tela5Linha11 : string "z   z     zzzzzzzzzzzzzzzz zzzzzzzzzzzzz"
tela5Linha12 : string "z   z     zzz   zzzz  zzzzzzzzzzzzzzzzz "
tela5Linha13 : string "z  z z    z z   z z    zzz  zzzz zzzzz  "
tela5Linha14 : string "zz z  z  zz z   z  z   zz    zz   z z   "
tela5Linha15 : string " zz   z  z   z  z  z   z z  z z   z z   "
tela5Linha16 : string "  {    z z    zz   zz z  z zz zz z  zz  "
tela5Linha17 : string "       z z    {     z z  zzz    {    z z"
tela5Linha18 : string "        {            z    {           { "
tela5Linha19 : string "    |                {           |      "
tela5Linha20 : string "   z z     |                    z z     "
tela5Linha21 : string "  z  z    z z          |    |   z  zz   "
tela5Linha22 : string " z   z   z  z     |   z z  z z  z    z  "
tela5Linha23 : string "z    z  z   z    z z  z  z z  z z     zz"
tela5Linha24 : string "z    z  z   z   z   z z   z    z z      "
tela5Linha25 : string "z    z z    z  z    z z   z    z z      "
tela5Linha26 : string "zzz zzz     z z      z   z     zzzzz  zz"
tela5Linha27 : string "zzzzzz      z z      z   z      zzzzzzzz"
tela5Linha28 : string "zzzzzzz     zzz      z   zz    zzzzzzzzz"
tela5Linha29 : string "zzzzzzzzzzzzzzzzzz zzzz zzzz  zzzzzzzzzz"



tela6Linha0  : string "                                        "
tela6Linha1  : string "                                        "
tela6Linha2  : string "     r     r  rrrr     rrrr   rrrr      "
tela6Linha3  : string "     r     r r    r   r      r          "
tela6Linha4  : string "     r     r r    r  r       r          "
tela6Linha5  : string "      r   r r      r r       rrrr       "
tela6Linha6  : string "      r   r r      r r       r          "
tela6Linha7  : string "       r r   r    r  r       r          "
tela6Linha8  : string "       r r   r    r   r      r          "
tela6Linha9  : string "        r     rrrr     rrrr   rrrr      "
tela6Linha10 : string "                                        "
tela6Linha11 : string "  rrrr   rrrr rrrr  rrr    rrrr r    r  "
tela6Linha12 : string "  r   r r     r   r r  r  r     r    r  "
tela6Linha13 : string "  r   r r     r   r r   r r     r    r  "
tela6Linha14 : string "  r   r rrrr  r   r r   r rrrr  r    r  "
tela6Linha15 : string "  rrrr  r     rrrr  r   r r     r    r  "
tela6Linha16 : string "  r     r     r  r  r   r r     r    r  "
tela6Linha17 : string "  r     r     r   r r  r  r      r  r   "
tela6Linha18 : string "  r      rrrr r   r rrr    rrrr   rr    "
tela6Linha19 : string "                                        "
tela6Linha20 : string "                                        "
tela6Linha21 : string "     r   r   rr     r   r   rr   r r r  "
tela6Linha22 : string "     r   r  r  r    r   r  r  r  r r r  "
tela6Linha23 : string "     r   r  r  r    r   r  r  r  r r r  "
tela6Linha24 : string "     rrrrr r    r   rrrrr r    r r r r  "
tela6Linha25 : string "     r   r rrrrrr   r   r rrrrrr r r r  "
tela6Linha26 : string "     r   r r    r   r   r r    r r r r  "
tela6Linha27 : string "     r   r r    r   r   r r    r        "
tela6Linha28 : string "     r   r r    r   r   r r    r r r r  "
tela6Linha29 : string "                                        "



tela7Linha0  : string "                                        "
tela7Linha1  : string " rrr   rr  rrr   rr  rrr  rrr r   r rrr "
tela7Linha2  : string " r  r r  r r  r r  r r  r r   rr  r r   "
tela7Linha3  : string " r  r rrrr r  r rrrr rrr  rr  r r r rrr "
tela7Linha4  : string " rrr  r  r rrr  r  r r  r r   r r r   r "
tela7Linha5  : string " r    r  r r  r r  r r  r r   r  rr   r "
tela7Linha6  : string " r    r  r r  r r  r rrr  rrr r   r rrr "
tela7Linha7  : string "                                        "
tela7Linha8  : string "                                        "
tela7Linha9  : string "          r   r  rrr   rrr rrrr         "
tela7Linha10 : string "          r   r r   r r    r            "
tela7Linha11 : string "          r   r r   r r    rrr          "
tela7Linha12 : string "          r   r r   r r    r            "
tela7Linha13 : string "           r r  r   r r    r            "
tela7Linha14 : string "            r    rrr   rrr rrrr         "
tela7Linha15 : string "                                        "
tela7Linha16 : string "                                        "
tela7Linha17 : string "                                        "
tela7Linha18 : string "                                        "
tela7Linha19 : string " r     r  rrrr r   r  rrrr  rrrr r   r  "
tela7Linha20 : string " r     r r     rr  r r     r     r   r  "
tela7Linha21 : string " r     r r     r r r r     r     r   r  "
tela7Linha22 : string "  r   r  rrrr  r r r r     rrrr  r   r  "
tela7Linha23 : string "  r   r  r     r r r r     r     r   r  "
tela7Linha24 : string "   r r   r     r  ss r     r     r   r  "
tela7Linha25 : string "   r r   r     r   r r     r     r   r  "
tela7Linha26 : string "    r     rrrr r   r  rrrr  rrrr  rrr   "
tela7Linha27 : string "                                        "
tela7Linha28 : string "                                        "
tela7Linha29 : string "                                        "



tela8Linha0  : string "                                        "
tela8Linha1  : string "   rrr    rrr  rrr  rrr     r   rr      "
tela8Linha2  : string "   r  r  r    r    r        r  r  r     "
tela8Linha3  : string "   r   r rrr  r    rrr      r  r  r     "
tela8Linha4  : string "   r   r r     rr  r        r r    r    "
tela8Linha5  : string "   r   r r       r r    r   r rrrrrr    "
tela8Linha6  : string "   r   r r       r r    r   r r    r    "
tela8Linha7  : string "   r  r  r       r r    r   r r    r    "
tela8Linha8  : string "   rrr    rrr rrr   rrr  rrr  r    r    "
tela8Linha9  : string "                                        "
tela8Linha10 : string "          r  rrr   rrr   r   rrrr       "
tela8Linha11 : string "          r r   r r     r r  r   r      "
tela8Linha12 : string "          r r   r r     r r  r   r      "
tela8Linha13 : string "          r r   r r    r   r r   r      "
tela8Linha14 : string "      r   r r   r r rr rrrrr rrrr       "
tela8Linha15 : string "      r   r r   r r  r r   r r   r      "
tela8Linha16 : string "      r   r r   r r  r r   r r   r      "
tela8Linha17 : string "       rrr   rrr   rrr r   r r   r      "
tela8Linha18 : string "                                        "
tela8Linha19 : string "                                        "
tela8Linha20 : string " rrr    rr   r   r  rrr  r   r  rr  rrr "
tela8Linha21 : string " r  r  r     rr  r r   r r   r r  r   r "
tela8Linha22 : string " r   r rr    r r r r   r r   r r  r   r "
tela8Linha23 : string " r   r r     r r r r   r r   r r  r   r "
tela8Linha24 : string " r   r r     r r r r   r  r r  r  r rrr "
tela8Linha25 : string " r   r r     r r r r   r  r r  r  r r   "
tela8Linha26 : string " r  r  r     r  rr r   r  r r  r  r     "
tela8Linha27 : string " rrr    rr   r   r  rrr    r    rr  r   "
tela8Linha28 : string "                                        "
tela8Linha29 : string "                                        "



tela9Linha0  : string "                                        "
tela9Linha1  : string "                                        "
tela9Linha2  : string "                                        "
tela9Linha3  : string "                                        "
tela9Linha4  : string "                                        "
tela9Linha5  : string "                                        "
tela9Linha6  : string "     rrrrrrrr         r   r         r   "
tela9Linha7  : string "    r                 r   rr        r   "
tela9Linha8  : string "   r                 rr   r r       r   "
tela9Linha9  : string "   r                 r    r  r      r   "
tela9Linha10 : string "   r                 r    r  r      r   "
tela9Linha11 : string "   r                rr    r   r     r   "
tela9Linha12 : string "   r                r     r   r     r   "
tela9Linha13 : string "   r                r     r    r    r   "
tela9Linha14 : string "    r              rr     r    r    r   "
tela9Linha15 : string "     rrrrrrr       r      r    r    r   "
tela9Linha16 : string "            r      r      r    r    r   "
tela9Linha17 : string "             r    rr      r     r   r   "
tela9Linha18 : string "             r    r       r     r   r   "
tela9Linha19 : string "             r   rr       r      r  r   "
tela9Linha20 : string "             r   r        r      r  r   "
tela9Linha21 : string "             r  rr        r       r r   "
tela9Linha22 : string "            r   r         r        rr   "
tela9Linha23 : string "    rrrrrrrr    r         r         r   "
tela9Linha24 : string "                                        "
tela9Linha25 : string "                                        "
tela9Linha26 : string "                                        "
tela9Linha27 : string "                                        "
tela9Linha28 : string "                                        "
tela9Linha29 : string "                                        "



tela10Linha0  : string "                                        "
tela10Linha1  : string "    rrrrrr       rrrrr        rr     r  "
tela10Linha2  : string "   r      r     r     r      r  r    r  "
tela10Linha3  : string "   r      r     r     r     r    r   r  "
tela10Linha4  : string "   r       r   r       r    r    r   r  "
tela10Linha5  : string "   r       r   r       r   r      r  r  "
tela10Linha6  : string "   r        r r         r  r      r  r  "
tela10Linha7  : string "   r        r r         r r        r r  "
tela10Linha8  : string "   r        r r         r r        r r  "
tela10Linha9  : string "   r       r  r         r r        r r  "
tela10Linha10 : string "   r       r  r         r r        r r  "
tela10Linha11 : string "   r      r   r         r r        r r  "
tela10Linha12 : string "   r      r   r         r r        r r  "
tela10Linha13 : string "   rrrrrrr    r         r rrrrrrrrrr r  "
tela10Linha14 : string "   r      r   r         r r        r r  "
tela10Linha15 : string "   r      r   r         r r        r r  "
tela10Linha16 : string "   r       r  r         r r        r r  "
tela10Linha17 : string "   r       r  r         r r        r r  "
tela10Linha18 : string "   r        r r         r r        r r  "
tela10Linha19 : string "   r        r r         r r        r r  "
tela10Linha20 : string "   r        r r         r r        r r  "
tela10Linha21 : string "   r        r r         r r        r r  "
tela10Linha22 : string "   r        r r         r r        r r  "
tela10Linha23 : string "   r       r   r       r  r        r r  "
tela10Linha24 : string "   r       r   r       r  r        r r  "
tela10Linha25 : string "   r       r    r     r   r        r r  "
tela10Linha26 : string "   r      r     r     r   r        r r  "
tela10Linha27 : string "   r      r      r   r    r        r    "
tela10Linha28 : string "    rrrrrr        rrr     r        r r  "
tela10Linha29 : string "                                        "



tela11Linha0  : string "                                        "
tela11Linha1  : string "    rrr    rr      rr      rrr    rr    "
tela11Linha2  : string "   r      r  r    r  r    r      r  r   "
tela11Linha3  : string "   r      r  r    r  r    r      r  r   "
tela11Linha4  : string "   r      r  r    r  r    r      r  r   "
tela11Linha5  : string "   r      rrr     rrrr    r      r  r   "
tela11Linha6  : string "   r      r  r    r  r    r      r  r   "
tela11Linha7  : string "   rrr    r  r    r  r    r      r  r   "
tela11Linha8  : string "   r      r  r    r  r    r      r  r   "
tela11Linha9  : string "   r      r  r    r  r    r      r  r   "
tela11Linha10 : string "   r      r  r    r  r    r      r  r   "
tela11Linha11 : string "   r      r  r    r  r    r      r  r   "
tela11Linha12 : string "   r      r  r    r  r    r      r  r   "
tela11Linha13 : string "   r      r  r    r  r    r      r  r   "
tela11Linha14 : string "   r      r  r    r  r    r      r  r   "
tela11Linha15 : string "   r      r  r    r  r    r      r  r   "
tela11Linha16 : string "   r      r  r    r  r    r      r  r   "
tela11Linha17 : string "   r      r  r    r  r    r      r  r   "
tela11Linha18 : string "   r      r  r    r  r    r      r  r   "
tela11Linha19 : string "   r      r  r    r  r    r      r  r   "
tela11Linha20 : string "   r      r  r    r  r    r      r  r   "
tela11Linha21 : string "   r      r  r    r  r    r      r  r   "
tela11Linha22 : string "   r      r  r    r  r    r      r  r   "
tela11Linha23 : string "   r      r  r    r  r    r      r  r   "
tela11Linha24 : string "   r      r  r    r  r    r      r  r   "
tela11Linha25 : string "   r      r  r    r  r    r      r  r   "
tela11Linha26 : string "   r      r  r    r  r    r      r  r   "
tela11Linha27 : string "   r      r  r    r  r    r      r  r   "
tela11Linha28 : string "   r      r  r    r  r     rrr    rr    "
tela11Linha29 : string "                                        "