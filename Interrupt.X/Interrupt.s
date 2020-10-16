;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;	Interrupción Equipo Microvid-19
; Cárdenas Galeana Alan Yeray
; Fabían Torres Eddy
; Hernandez Ramirez Leo Alexander 
; Martínez Carbajal Dulce Andrea
; Sánchez Gonzalez Jonathan
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
PROCESSOR 16F887
    #include <xc.inc>
    ;configuración de los fuses
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=OFF
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF                ;Fuses
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
    
    
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    PSECT udata
 tick:
    DS 1
 counter:
    DS 1
 counter2:
    DS 1
   
    PSECT code
    delay:                       ;Delay
    movlw 0xFF
    movwf counter
    counter_loop:
    movlw 0xFF
    movwf tick
    tick_loop:
    decfsz tick,f
    goto tick_loop
    decfsz counter,f
    goto counter_loop
    return
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$    
PSECT resetVec,class=CODE,delta=2
	PAGESEL main
	goto main
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
PSECT isr,class=CODE,delta=2
	
isr:
        btfss INTCON,1
	retfie                     ;Interrupcion
	
BANKSEL PORTC
	movlw 0x01
	xorwf PORTC
	bcf INTCON,1
	BANKSEL PORTA
	retfie
	

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
PSECT main,class=CODE,delta=2
main:
    ;//////////////////////////////////////////
    clrf INTCON
    movlw 0b11010000    ;Activamos INTCON
    movwf INTCON
    ;//////////////////////////////////////////
    BANKSEL OSCCON
    movlw 0b01110101     ; se pone a 8Mhz, trabaja con el interno y es el alto es decir trabaja con el reloj interno y en alta frecuencia y este mismo se utiliza como reloj interno
    movwf OSCCON
    ;////////////////////////////////////////////
    BANKSEL PORTB
    clrf    PORTB
    BANKSEL TRISB      ;limpia PORTB y configura todos los pines como entrada
    movlw   0xFF         ;
    movwf   TRISB
    ;//////////////////////////////////////////
    BANKSEL ANSELH
    bcf ANSELH,4
    ;//////////////////////////////////////////
    BANKSEL WPUB
    movlw 0xFF
    movwf WPUB
    ;/////////////////////////////////////
    BANKSEL PORTC
	clrf PORTC    ;limpia PORTc y configura todos los pines como entrada
    BANKSEL TRISC
	clrf TRISC
    ;////////////////////////////////////////////
    BANKSEL ANSEL
    movlw   0x00         ;desactiva la entrada analogica y permite la entrada de una funcion especial
    movwf   ANSEL
    ;///////////////////////////////////////////
    BANKSEL PORTA  ;limpia el porta 
    clrf    PORTA
    BANKSEL TRISA   ; coloca el TRISA como salida
    clrf    TRISA
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    loop:
    BANKSEL PORTA   ;seleccionamos porta
    call delay      ;llamamos la instruccion delay
    movlw 0x01                                                 ;Ciclo
    xorwf PORTA     ;hace la operacion or compara w con porta en el bit 0 y luego lo guarda en f para una comparacion futura
    goto loop
    END