jmp main

resp: var #1          ; Resposta do jogador se quer ir de novo
Letra: var #1		; Contem a letra que foi digitada
posJogador: var #1			; Contem a posicao atual do jogador
posAntJogador: var #1		; Contem a posicao anterior do jogador
posDino: var #1;		; Contem a posicao do dinossauro
posAntDino: var #1		; Contem a posicao anterior do dinossauro
IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos

	
;---- Inicio do Programa Principal -----
main:
	loadn r0, #0
	store posJogador, r0		; Zera Posicao Atual do Jogador
	store posAntJogador, r0	; Zera Posicao Anterior do Jogador
	loadn r0, #961
	store posDino, r0
	store posAntDino, r0
	loadn r1, #0
	store IncRand, r1
	loadn r1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn r2, #0  			; cor branca!

	call Reset_Feromonio ; Reseta o feromonio ao jogar novamente
	loadn r7, #tela0Linha0 ; Endereço do mapa onde o jogador está
	call loop
	
loop:
	loadn r1, #10
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/10)==0
		ceq MoveJogador	; Chama Rotina de movimentacao do Jogador
		loadn r1, #15
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/15)==0
		ceq MoveDino	; Chama Rotina de movimentacao do Dino
	call Fog
	call CondicaoVitoria
	call Dinocomeu
	call Delay
	inc r0 	;c++

	jmp loop	
;---- Fim do Programa Principal -----
	
;---- Inicio das Subrotinas -----
Dinocomeu:
	push r0
	push r1
	load r0, posJogador	
	load r1, posDino
	cmp r0, r1
	jeq Dinopositivo ; compara se a posição do dino e do jogador são as mesmas
	pop r1
	pop r0
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
	cmp r2, r1
	jeq FimDeJogoWinEnd
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
	jmp main





	
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
	push r2
	push r7
	load r0, posJogador
	loadn r1, #40
	mod r7, r0, r1
	loadn r2, #5
	cmp r7, r2
	jle Else_printDino_Left
	loadn r2, #35
	cmp r7, r2
	jgr Else_printDino_Right
	add r3, r3, r4
	outchar r3, r5 ;imprime o r3 na posição r5
	
	

	Else_printDino_Skip:
	pop r7
	pop r2
	pop r4
	pop r3
	pop r1
	pop r0
	rts

Else_printDino_Left: ; não imprimi o dino do outro lado da tela
	mod r7, r5, r1
	loadn r2, #30
	cmp r7, r2
	jgr Else_printDino_Skip
	add r3, r3, r4
	outchar r3, r5 ;imprime o r3 na posição r5
	jmp Else_printDino_Skip
	
Else_printDino_Right:
	mod r7, r5, r1
	loadn r2, #5
	cmp r7, r2
	jle Else_printDino_Skip
	add r3, r3, r4
	outchar r3, r5 ;imprime o r3 na posição r5
	jmp Else_printDino_Skip

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
		;cmp r0, r2
		;jeq ApagaTela_Loop_Skip
		outchar r1, r0
		cmp r0, r3
		jne ApagaTela_Loop
		
		;ApagaTela_Loop_Skip:
		;cmp r0, r3
		;jne ApagaTela_Loop
 
	pop r3
	pop r2
	pop r1
	pop r0
	rts	

MoveDino:
	push r0
	push r1
	call MoveDino_RecalculaPos
	
	
; So' Apaga e Redesenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posDino
	load r1, posAntDino
	cmp r0, r1
	jeq MoveDino_Skip
		call MoveDino_Apaga
		call MoveDino_novaPos		;}
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
	 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
			; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	MoveDino_RecalculaPos_TryAgain:
	loadn r2, #Rand
	add r2, r2, r1
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
	jmp MoveDino_Feromonio_Case1
	MoveDino_Correto_Case1:
	loadn r1, #40
	sub r0, r0, r1
	jmp MoveDino_TemParede_Sub

 ; Case 3 : posDino = posDino - 1
   MoveDino_RecalculaPos_Case2:
	loadn r2, #2	; Se Rand = 2
	cmp r3, r2
	jne MoveDino_RecalculaPos_Case3
	jmp MoveDino_Feromonio_Case2
	MoveDino_Correto_Case2:
	loadn r1, #1
	sub r0, r0, r1
	jmp MoveDino_TemParede_Sub

 ; Case 4 : posDino = posDino + 1	
   MoveDino_RecalculaPos_Case3:
	loadn r2, #3	; Se Rand = 3
	cmp r3, r2
	jne MoveDino_RecalculaPos_Case4
	jmp MoveDino_Feromonio_Case3
	MoveDino_Correto_Case3:
	loadn r1, #1
	add r0, r0, r1
	jmp MoveDino_TemParede_Soma

 ; Case 6 : posDino = posDino + 40
   MoveDino_RecalculaPos_Case4:
	loadn r2, #4	; Se Rand = 4
	cmp r3, r2
	jne MoveDino_RecalculaPos_FimSwitch
	jmp MoveDino_Feromonio_Case4
	MoveDino_Correto_Case4:
	loadn r1, #40
	add r0, r0, r1
	jmp MoveDino_TemParede_Soma	; Break do Switch	

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
	jeq MoveDino_RecalculaPos_FimSwitch
	sub r0, r0, r1
	jmp MoveDino_RecalculaPos_TryAgain
  
  
 MoveDino_TemParede_Sub:
 	loadn r4, #' '
 	loadn r3, #tela0Linha0
 	loadn r6, #40
	div r2, r0, r6 ;divide a soma por 40 para ver quantas linhas abaixo está a nova posição
	add r2, r0, r2 ;soma a quantidade de linhas com r5 pois matrizes tem 41 caractéres por linha
	add r3, r2, r3 ;r6 = &tela0linha0[r6]
	loadi r5, r3
	cmp r5, r4
	jeq MoveDino_RecalculaPos_FimSwitch
	add r0, r0, r1
	jmp MoveDino_RecalculaPos_TryAgain

;----------------------------------


MoveDino_Feromonio_Case1:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r7, #40
	loadn r0, #tela12Linha0 ;coloca o endereço inicial da tela 12 no r0
	load r1, posDino ;coloca a pos atual do dino no r1
	loadn r2, #40
	sub r3, r1, r2 ;calcula a posição que ele estaria se fizesse o movimento do case1
	div r4, r3, r2 ;continua calculando a posição que ele estaria se fizesse o movimento do case1
	add r4, r3, r4 ;continua calculando a posição que ele estaria se fizesse o movimento do case1
	add r4, r4, r0 ;continua calculando a posição que ele estaria se fizesse o movimento do case1
	loadi r5, r4 ;coloca o que tem nessa posição na matriz de feromonios no r5
	add r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na direção oposta
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	loadn r2, #1
	add r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse em outra direção
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	sub r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na ultima direção possivel
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	jmp MoveDino_Correto_Case1 ;caso a posição que ele deseja ir, tenha menos feromonios que as outras possibilidades, ele anda

MoveDino_Feromonio_Case2:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r7, #40
	loadn r0, #tela12Linha0 ;coloca o endereço inicial da tela 12 no r0
	load r1, posDino ;coloca a pos atual do dino no r1
	loadn r2, #1
	sub r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r5, r4 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	add r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na direção oposta
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	loadn r2, #40
	add r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse em outra direção
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	sub r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na ultima direção possivel
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	jmp MoveDino_Correto_Case2 ;caso a posição que ele deseja ir, tenha menos feromonios que as outras possibilidades, ele anda

MoveDino_Feromonio_Case3:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r7, #40
	loadn r0, #tela12Linha0 ;coloca o endereço inicial da tela 12 no r0
	load r1, posDino ;coloca a pos atual do dino no r1
	loadn r2, #1
	add r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r5, r4 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	sub r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na direção oposta
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	loadn r2, #40
	add r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse em outra direção
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	sub r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na ultima direção possivel
	cmp r5, r6 ;caso tenha mais feromonios na posição que ele desejava ir, ele não anda, e ele vai para a func feromonio erro
	jgr Feromonio_erro
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	jmp MoveDino_Correto_Case3 ;caso a posição que ele deseja ir, tenha menos feromonios que as outras possibilidades, ele anda

MoveDino_Feromonio_Case4:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r7, #40
	loadn r0, #tela12Linha0 ;coloca o endereço inicial da tela 12 no r0
	load r1, posDino ;coloca a pos atual do dino no r1
	loadn r2, #40
	add r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r5, r4 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	sub r3, r1, r2
	div r4, r3, r2
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na direção oposta
	cmp r5, r6 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	jgr Feromonio_erro
	loadn r2, #1
	add r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse em outra direção
	cmp r5, r6 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	jgr Feromonio_erro
	sub r3, r1, r2
	div r4, r3, r7
	add r4, r3, r4
	add r4, r4, r0
	loadi r6, r4 ;calcula e coloca o que teria na matriz de feromonios caso ele andasse na ultima direção possivel
	cmp r5, r6 ;calcula e coloca o que tem na matriz de feromonios na direção que ele quer andar
	jgr Feromonio_erro
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	jmp MoveDino_Correto_Case4 ;caso a posição que ele deseja ir, tenha menos feromonios que as outras possibilidades, ele anda
	
Feromonio_erro:
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	jmp MoveDino_RecalculaPos_TryAgain ;caso ocorra um erro, ele volta para sortear outro nmr randomico para andar, assim ele não perde a vez

MoveDino_novaPos:
	push r0	
	call MoveDino_Feromonio_Novo
	load r0, posDino
	store posAntDino, r0
	pop r0
	rts
	
MoveDino_Feromonio_Novo:
	push r0
	push r1
	push r2
	push r3
	load r0, posDino
	loadn r1, #tela12Linha0
	loadn r2, #40
	loadn r3, #'9'
	div r2, r0, r2
	add r2, r0, r2
	add r2, r1, r2
	storei r2, r3 ;coloca o 9 na pos na matriz que é relativa a pos do dino, esse é o feromonio que ele solta
	call MoveDino_Reduz_Feromonio
	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveDino_Reduz_Feromonio:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r0, #1230
	loadn r1, #tela12Linha0
	loadn r2, #'\0'
	loadn r3, #1
	loadn r4, #0
	loadn r5, #'0'
	loadn r7, #'t'
	MoveDino_Reduz_Feromonio_Loop:
	loadi r6, r1
	cmp r6, r5 ;se o feromonio ja é zero, ele não é reduzido, vai para o skip
	jeq Reduz_Feromonio_Skip
	cmp r6, r2 ;se o caracter na matriz é '\0', ele não é reduzido, vai para o skip
	jeq Reduz_Feromonio_Skip
	cmp r6, r7 ;se o caracter na matriz é 't' (parede), ele não é reduzido, vai para o skip
	jeq Reduz_Feromonio_Skip
	sub r6, r6, r3 ;todos aqueles que passam são reduzidos em uma unidade
	storei r1, r6 ;guarda o novo feromonio
	Reduz_Feromonio_Skip:
	add r4, r4, r3
	add r1, r1, r3
	cmp r4, r0 ;cmp r4 com 1230, para fzr como se fosse um for
	jle MoveDino_Reduz_Feromonio_Loop
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

Reset_Feromonio: ;quando o jogo acaba o feromonio tem que ser resetado
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	loadn r0, #1230
	loadn r1, #tela12Linha0
	loadn r3, #1
	loadn r4, #0
	loadn r5, #'0'
	loadn r2, #41
	loadn r7, #40
	Reset_Feromonio_Loop:
	mod r6, r4, r2
	cmp r6, r7 ;se a posição na linha eh 41, ele insere um '\0'
	ceq insert_fim
	cmp r6, r7 ;se não ele entra na func
	cne insert_letra
	add r4, r4, r3
	add r1, r1, r3
	cmp r4, r0
	jle Reset_Feromonio_Loop
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

insert_fim:
	push r0
	loadn r0, #'\0'
	storei r1, r0
	pop r0
	rts
	
insert_letra:
	push r2
	push r3
	push r5
	loadn r5, #'0'
	loadn r3, #'t'
	loadi r2, r1
	cmp r2, r3 ;se não for parede, ele insere '0'
	cne insert_zero
	cmp r2, r3 ;se for parede insere 't'
	ceq insert_t
	pop r5
	pop r3
	pop r2
	rts
	
insert_zero:
	storei r1, r5
	rts
	
insert_t:
	storei r1, r3
	rts
;----------------------------------
;----------------------------------
;--------------------------

Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #90  ; a
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

tela12Linha0  : string "00tttttttttttttttttttttttttttttttttttttt"
tela12Linha1  : string "t0000t000000000000000000t00000000000000t"
tela12Linha2  : string "t0tt0t0ttt0ttt0tttt0t0ttttt0tttttttttt0t"
tela12Linha3  : string "t0t00t000t0t0t0t00t0t0t0t0t00000t000000t"
tela12Linha4  : string "t0tttttt0t0t0t0t0tt0t0t0t0t0t0t0t0tttt0t"
tela12Linha5  : string "t00t000t0t0t0t0t0000t0t0t0t0t0t0t0t00t0t"
tela12Linha6  : string "tt0t0ttt0t000t0t0tttt0t0t0t000t0t0t00t0t"
tela12Linha7  : string "t0000t000ttttt0ttt0000t0t0t0t0t0t0t0tt0t"
tela12Linha8  : string "t0tttt0t0t000000t00tt0t0t0t0t0t0t0t0000t"
tela12Linha9  : string "t000000t0t0tttt0t0tt00t00000t0t0t0tttt0t"
tela12Linha10 : string "t0tttttt0t0t0000t0t00tt0ttttt00000000t0t"
tela12Linha11 : string "t0t000000t0t0tttt0t0tt000000tttttttt0t0t"
tela12Linha12 : string "t0ttt0tttt0t000000t0t00tttt0t00000000t0t"
tela12Linha13 : string "t0t0t0t0000t0tttttt0t0ttt0t0tttttt0ttt0t"
tela12Linha14 : string "t0t0t0t0t0tt0t0000t00000t0t0000t0t0t0t0t"
tela12Linha15 : string "t0t0t0ttt0t00tttt0t0ttt0t0t0tttt0t0t0t0t"
tela12Linha16 : string "t000t00000t0000000t0t00000t000000t000t0t"
tela12Linha17 : string "t0tttttt0tttttttttt0ttttt0t0tttttttt000t"
tela12Linha18 : string "t0t0000t0t0t00000t0000t000t0t000t00t0ttt"
tela12Linha19 : string "t0t0tt0t0t0t0ttt0t0tttttt0t0t0t0tt0t0t0t"
tela12Linha20 : string "t000tt0t0t0t0t0t0t000000t0t000t0000t0t0t"
tela12Linha21 : string "t0t0tt0t0t0t0t000tt0ttttttt0ttttt00t0t0t"
tela12Linha22 : string "t0t0000t0t0t0tttttt0t000t000t000tttt0t0t"
tela12Linha23 : string "t0tttttt0t0t0000t0t0t0t0t0t0t0t0t000000t"
tela12Linha24 : string "t00000000t0t0tt0t0t0t0t0t0t0t0t0t0tt0t0t"
tela12Linha25 : string "t0tttt0ttt0t0tt0t0t0t0t0t0t0t0t0t00t0t0t"
tela12Linha26 : string "t0t00t0t000t0000t0t0t00000t0t0t0000t0t0t"
tela12Linha27 : string "t0t0tt0t0ttttt0tt0t0ttt0ttt0t0tttttt0t0t"
tela12Linha28 : string "t0t000000000000000t00000t0000000t0000t0t"
tela12Linha29 : string "tttttttttttttttttttttttttttttttttttttt0t"