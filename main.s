/*****************************************************************************
*   Curso:  Ciências da Computação (Integral)
*   Disciplina:     Microprocessadores II (2021)
*   Professor:      Alexandro Jose Baldassin
*
*   Alunos: 
*       Izael de Oliveira da Silva Junior,  RA: 171152743
*       Julia Cristina Perino De Nadai,     RA: 181153203
*
*   Programa desenvolvido no Visual Studio Code e testado no web ???
*
*   Objetivo: ........ ??                                     
*****************************************************************************/

/*****************************************************************************
*   PSEUDO CÓDIGO:

    int main(){
        while( WSPACE == 0 ){   RVALID(??)
            le WSPACE;
        }

        r9 = lerEntrada();
        switch(r9){
            case 0: //  case 0x30
                r9 = lerEntrada();
                switch(r9){
                    case 0: //  case 0x30
                        r9 = lerLED();
                        verifica se o numero do LED é valido
                        if(isValidLED(r9)){
                            verifica se LED ja está ligado
                            if(statusLED(r9)){
                                ligarLED(led);
                            }else{
                                exibeMensagem(led_on_msg);
                            }
                        }else{
                            exibeMensagem(invalid_led_msg);
                        }   
                        break;
                    case 1: //  case 0x31 
                        r9 = lerLED();
                        verifica se o numero do LED é valido
                        if(isValidLED(r9)){
                            verifica se LED ja está desligado
                            if(!statusLED(r9)){
                                desligarLED(led);
                            }else{
                                exibeMensagem(led_off_msg);
                            }
                        }else{
                            exibeMensagem(invalid_led_msg);
                        }   
                        break;
                    default:
                        exibeMensagem(invalid_led_msg);
                        break;
                }
                break;
            case 1: //  case 0x31
                r9 = lerChaves();
                if(r9){
                    r10 = calculaNumeroTriangular(r9);
                    exibeDisplay(r10);
                }else{
                    exibeMensagem(no_entry_msg);
                }            
                break;
            case 2: //  case 0x32
                r9 = lerEntrada();
                switch(r9){
                    case 0: //  case 0x30
                        exibeDisplay('2021');
                        rotaciona(true)??
                        break;
                    case 1: //  case 0x31
                        rotaciona(false);?? 
                        break;
                    default:
                        exibeMensagem(invalid_cmd_msg);
                        break;
                }
                break;
            default: 
                exibeMensagem(invalid_cmd_msg);
                break;
        }
    }

    exibeMensagem(msg){
        end[] = msg;            // movia 	r4, msg 
        tam = 4(end);           // ldw 	r5, 4(r4)
        
        for(i=0; i<tam; i++){
            end[i];             //  addi 	r6, r4, 4 
            exibe na UART       //stwio   r6, (UART)		   
        }
    }

    exibeDisplay(char){ lab5_part1 ?    }

    lerEntrada(){}

    isValidLED(r9){}

    statusLED(r9){}

    ligarLED(led){}

    desligarLED(led){}

    lerChaves(){ lab5_part1 ?    }

    calculaNumeroTriangular(r9){}

    rotaciona(){}


*****************************************************************************/

/*****************************************************************************/
/* Main Program                                                              */
/* r2  - base address for UART                                               */
/* r3  - Control															 */
/* r4 - Registrador reservado para enviar parâmetros para as funções         */
/* r5 - Registrador reservado para enviar parâmetros para as funções         */
/*****************************************************************************/

/* definição de constantes ***************************************************/
.equ    mask, 0xFFFF
.equ	IO_BASE_ADDR, 	0x10000000
.equ    UART, 0x10001000        /* Endereço base do terminal UART  */
.equ	LEDs,	0x10000010		/* Endereço base dos LEDs	       */
.equ	DISPLAYs,0x20		/* Endereço base do DISPLAY	       */
.equ 	switches, 0x40	/* Endereço base dos switches	   */
/*****************************************************************************/

/*****************************************************************************/
/*  função MAIN */
.global _start
_start:
	movia	r2, UART
    ldwio   r3, 4(r8)   /*   r9: conteudo do control */

MAIN:
    /*  Chamada para a função de print                                         */	
	mov	    	r4, r2
    movia     	r5, teste             /* Carrega os parâmetros para sub-rotina */
    
    call	exibe_mensagem

    mov	    	r4, r2    
    call	ler_entrada


SWITCH_MAIN:
    movia   r7, 0x30        /*  r4 recebe código ascii de 0 */
    beq     r3,r7, SWITCH_LED

    movia   r7, 0x31        /*  r4 recebe código ascii de 0 */
    beq     r3,r7, DISPLAY_NUM_TRI

    

    /* Caso comando seja inválido, exibe a mensagem */
    mov	    	r4, r2
    movia     	r5, invalid_cmd_msg             /* Carrega os parâmetros para sub-rotina */
    call	exibe_mensagem
		
    br MAIN
SWITCH_LED:
	mov	    r4, r2    
    call	ler_entrada

    movia   r7, 0x30        /*  r4 recebe código ascii de 0 */
    beq     r3,r7, PISCAR_LED

    movia   r7, 0x31        /*  r4 recebe código ascii de 1 */
    beq     r3,r7, PARAR_LED

	/* Caso comando seja inválido, exibe a mensagem */
    mov	    	r4, r2
    movia     	r5, invalid_cmd_msg             /* Carrega os parâmetros para sub-rotina */
    call	exibe_mensagem
		
    br MAIN

PISCAR_LED:
	mov	    r4, r2    
    call	ler_entrada
	mov	    r4, r3
	call	verifica_LED	/* verifica o primeiro led */
	beq 	r3,r0,MAIN /* ?? */
	
	mov	    r4, r2    
    call	ler_entrada
	mov	    r4, r3
	call	verifica_LED	/* verifica o segundo led */
	beq 	r3,r0,MAIN /* ?? */
	
/*	
	- verificar se o led ja esta piscando, se nao estiver, pisca
    call acende_led
*/
    br end

PARAR_LED:

    /* fazer td as verificações ? 
    call ler_led
    call led_valido
    call apaga_led
*/
    br end

DISPLAY_NUM_TRI:
    mov	    r4, r2    
    call	ler_entrada

	movia 	r7,0x30
    beq     r3,r7,SWITCHES_NUM_TRI
    /* Caso comando seja inválido, exibe a mensagem */
    mov	    	r4, r2
    movia     	r5, invalid_cmd_msg             /* Carrega os parâmetros para sub-rotina */
    call	exibe_mensagem
    
    br MAIN

SWITCHES_NUM_TRI:
    movia	r4,IO_BASE_ADDR
    call    LER_SWITCHES

    /* ?? fazer funcao para verificar se é válido  */
	mov		r4, r3
    call	NUMERO_TRIANGULAR

    mov		r4,r3
    movia   r5,IO_BASE_ADDR
    call    EXIBE_DISPLAY

    br MAIN

end:
    br end      /* Remain here if done */
/*****************************************************************************/

/*  FUNÇÕES DIVERSAS  ********************************************************/
.global exibe
exibe_mensagem:
    addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0	
	
	mov 	r8,r4	/* base uart */
	mov		r9,r5	/* mensagem  */
	
LOOP_MSG:	
	ldwio 	r10, 4(r8)			/* pegando o reg control */
	andhi 	r10, r10, 0xFFFF	/* pegando os 15 primeiros bits */
	beq 	r10, r0, LOOP_MSG
	ldb 	r11, 0(r9)			/*  */
	beq 	r11,r0, FIM_LOOP_MSG
	stwio 	r11, 0(r8)
	addi 	r9, r9, 0x1
	br 		LOOP_MSG
	
FIM_LOOP_MSG:
    mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret


ler_entrada:
    addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0

LOOP_ENTRADA:
    ldwio   r3, (r4)   	    /*   r9: conteudo do registrador Data */
	mov 	r8,r3
	srli    r8, r8, 15  

	andi 	r8, r8, 0xFFFF     /*   Isolando o bit de interesse, RVALID */
	beq 	r0, r8, LOOP_ENTRADA    /*   caso RVALID != 0, sai do LOOP */
	
	andi 	r3, r3, 0x7F    /*  isola ultimos bits */
	
FIM_LOOP_ENTRADA:
    mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret
	

verifica_LED:
	addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0

	movia 	r8, 0x38
	blt		r4,r0,led_invalido
	bgt		r4,r8,led_invalido
	movia 	r3,1	/* retorna 1 para valido */
	br fim_verifica_LED
	
led_invalido:
	mov	    	r4, r2
    movia     	r5, invalid_led_msg             /* Carrega os parâmetros para sub-rotina */
    call	exibe_mensagem
	
	movia 	r3,0	/* retorna 0 para invalido */

fim_verifica_LED:
	mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret

NUMERO_TRIANGULAR:
	addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0


	/*  Fórmula do número triangular de n: n(n + 1)/2	*/
	addi	r8,r4,1
	mul		r8,r8,r4
	srli	r3,r8,1	
	

FIM_LOOP:
	mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret

EXIBE_DISPLAY:
	addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0

    movi 	r13, _7SEG
    add		r8, r0, r0			/* Clear r19                             */
	addi	r9, r0, 4			/* Initialize the LOOP2 counter          */
	mov		r10, r4			    /* r21 holds the number being processed  */
display_loop:
	andi	r11, r10, 0xf		/* Extract a hex digit                   */
	add		r11, r13, r11
	ldb		r12, (r11)			/* Look up the 7-segment pattern         */
	or		r8, r8, r12		/* Include the pattern in total display  */
	roli	r8, r8, 24		/* Make room for pattern of next digit   */
	srli	r10, r10, 4			/* Now consider the next hex digit       */
	subi	r9, r9, 1			/* Decrement the counter                 */
	bgt		r9, r0, display_loop		/* Branch back if not done               */
	stwio	r8, DISPLAYs(r5)		/* Display the sum on HEX display        */        

	mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret

LER_SWITCHES:
    addi sp, sp, -8 
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp,sp,0

    ldwio	r8, switches(r4)		/* Read in the new number                */    
    andi    r3, r8, 0xFF          /* Consider only the first 8 switches      */

    mov sp,fp
	ldw ra, 4(sp) 
	ldw fp, 0(sp)
	addi sp,sp,0
	ret

/*****************************************************************************/


	
.org 0x1000	

/*  Definição de mensagens que serão exibidas ********************************/
menu:
	.asciz "\nMENU:\n00: Piscar LED\n01: Desligar LED\n10: Numero triangular\n20: Rotacionar '2021'\n21: Parar rotacao\nEntre com o comando:"	
	
invalid_cmd_msg:
    .asciz "\nERRO! Comando invalido.."

invalid_led_msg:
    .asciz "\nERRO! LED invalido.."

led_on_msg:
    .asciz "\nLED ja esta aceso.."

led_off_msg:
    .asciz "\nLED ja esta apagado.."

no_entry_msg:
    .asciz "\nERRO! Usuario nao entrou com nenhum valor.."
teste:
    .asciz "\nteste.."
/*****************************************************************************/

/* This is the hex-digit to 7-segment conversion table                             */ 
_7SEG:
.byte 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x67,0x77,0x7c,0x39,0x5e,0x79,0x71

.end