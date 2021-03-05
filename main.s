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
/* r4 - Armazena codigo ascii do caracter z    							 */
/*****************************************************************************/

/* definição de constantes ***************************************************/
.equ    UART, 0x10001000  
.equ    mask, 0xFFFF
.equ    entry_msg, 0x1000
/*****************************************************************************/

/* definição de constantes para códigos ascii das letras do alfabeto *********/
.equ    space, 0x20
.equ    dots, 0x3a //???

.equ    C, 0x43
.equ    E, 0x45
.equ    L, 0x4c
.equ    U, 0x55

.equ    a, 0x61
.equ    b, 0x62
.equ    c, 0x63
.equ    d, 0x64
.equ    e, 0x65
.equ    f, 0x66
.equ    g, 0x67
.equ    h, 0x68
.equ    i, 0x69
.equ    j, 0x6a
.equ    l, 0x6c
.equ    m, 0x6d
.equ    n, 0x6e
.equ    o, 0x6f
.equ    p, 0x70
.equ    q, 0x71
.equ    r, 0x72
.equ    s, 0x73
.equ    t, 0x74
.equ    u, 0x75
.equ    v, 0x76
.equ    z, 0x7a
/*****************************************************************************/

/*****************************************************************************/
/*  função MAIN */
.global _start
_start:
	movia	r2, UART
    ldw     r3, 4(r8)   /*   r9: conteudo do control */
LOOP:
    srli    r3, r3, 16  /*   scroll para pegar a parte alta do Control */
    andi 	r3, r3, mask    /*   Isolando o bit de interesse, RVALID */
	beq 	r0, r3, LOOP    /*   caso RVALID != 0, sai do LOOP */
	
	ldw     r3, (r2)        /*  carrega conteudo de Data em r9 */
	andi 	r3, r3, 0x7F    /*  isola ultimos bits */
	
SWITCH_MAIN:
    movia   r4, 0x30        /*  r4 recebe código ascii de 0 */
    beq     r3,r4, SWITCH_LED

    movia   r4, 0x31        /*  r4 recebe código ascii de 1 */
    beq     r3,r4, IF_CHAVE

    movia   r4, 0x32        /*  r4 recebe código ascii de 2 */
    beq     r3,r4, SWITCH_ROT

    /*  call mensagem - tem que passar como parametro o endereco da mensagem ?? */
    br end /* ? */

SWITCH_LED:
    ldw     r3, (r2)        /*  carrega conteudo de Data em r9 */
	andi 	r3, r3, 0x7F    /*  isola ultimos bits */

    movia   r4, 0x30        /*  r4 recebe código ascii de 0 */
    beq     r3,r4, ACENDER_LED

    movia   r4, 0x31        /*  r4 recebe código ascii de 1 */
    beq     r3,r4, APAGAR_LED

    /* call mensagem */
    br end



ACENDER_LED:

    /* fazer td as verificações ? */
    call ler_led
    call led_valido
    call acende_led

    br end

APAGAR_LED:

    /* fazer td as verificações ? */
    call ler_led
    call led_valido
    call apaga_led

    br end


end:
    br end      /* Remain here if done */
/*****************************************************************************/

/*  FUNÇÕES DIVERSAS  ********************************************************/
exibe_mensagem:

	/*addi sp, sp, -12 	 make a 16-byte frame */
	/*stw ra, 8(sp) 		 store the return address */
	/*stw r8, 4(sp)
	/*stw r16, 0(sp) 		 store callee-saved register */
	
	movia 	r6, entry_msg 
    addi    r6,r6,4     /* r4 aponta para o tamanho da mensagem ??????*/ 
    ldw 	r5, (r6)
    subi 	r5,r5,1
    subi    r6,r6,4

	LOOP:
        subi	r5, r5, 1
        beq 	r5, r0, DONE 		/* Finished if r5 is equal to 0 */
        ldw 	r7,(r6)		
        addi 	r6, r6, 4 
        ldw 	r9,(r6)
        stwio   r9, (r8)
        addi 	r6, r6, 4 		/* Increment the list pointer */
        stw 	r10, (r6) 
        br LOOP
    
    		   
    }
	
/*fim:
	ldw ra, 8(sp)
	ldw r8, 4(sp)
	ldw r16, 0(sp)
	addi sp, sp, 12
	
	ret
/*****************************************************************************/

.end
	
.org 0x1000	

/*  Definição de mensagens que serão exibidas no terminal UART em tempo de execução */
entry_msg:
/*  "Entre com o comando: " */
.word E,n,t,r,e,space,c,o,m,space,o,space,c,o,m,a,n,d,o,dots 				
size_entry_msg:
.word 20	

invalid_cmd_msg:
/*  "Comando invalido " */
.word C,o,m,a,n,d,o,space,i,n,v,a,l,i,d,o 				
size_invalid_cmd_msg:
.word 16	

invalid_led_msg:
/*  "LED invalido " */
.word L,E,D,space,i,n,v,a,l,i,d,o 				
size_invalid_led_msg:
.word 12

led_on_msg:
/*  "LED ja aceso " */
.word L,E,D,space,j,a,space,a,c,e,s,o 				
size_led_on_msg:
.word 12

led_off_msg:
/*  "LED ja apagado " */
.word L,E,D,space,j,a,space,a,p,a,g,a,d,o				
size_led_off_msg:
.word 14

no_entry_msg:
/*  "Usuario nao entrou com nenhum valor " */
.word U,s,u,a,r,i,o,space,n,a,o,space,e,n,t,r,o,u,space,c,o,m,space,n,e,n,h,u,m,space,v,a,l,o,r				
size_no_entry_msg:
.word 35
/*****************************************************************************/
.end