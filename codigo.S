#define __SFR_OFFSET 0
#include "avr/io.h"

.global setup
.global loop
setup:
   

// Configurar pines de salida para LEDs y buzzer
SBI DDRB, 0  // PB0 como salida (ROJO)
SBI DDRB, 1  // PB1 como salida (VERDE)
SBI DDRB, 2  // PB2 como salida (AMARILLO)
SBI DDRB, 3  // PB3 como salida (BUZZ)

// Configurar pines de entrada para columnas del teclado
SBI DDRB, 4  // PB4 como entrada (COLUMNA_3)
SBI DDRB, 5  // PB5 como entrada (COLUMNA_4)
SBI DDRD, 6  // PD6 como entrada (COLUMNA_1)
SBI DDRD, 7  // PD7 como entrada (COLUMNA_2)

// Configurar pines de entrada para filas del teclado
SBI DDRD, 2  // PD2 como entrada (FILA_1)
SBI DDRD, 3  // PD3 como entrada (FILA_2)
SBI DDRD, 4  // PD4 como entrada (FILA_3)
SBI DDRD, 5  // PD5 como entrada (FILA_4)

// Configurar pines de entrada analógica para sensores
SBI DDRC, 0  // PC0 como entrada (SENSOR1, equivalente a PIN A0)
SBI DDRC, 1  // PC1 como entrada (SENSOR2, equivalente a PIN A1)
SBI DDRC, 2  // PC2 como entrada (SENSOR3, equivalente a PIN A2)


    clr r16                  // Inicializar estado de alarma (estado_alarma = 0)

loop:
//Función para Alternar Estado de Alarma (toggle_alarma):
toggle_alarma:
    ldi r20, 1               // Cargar 1 en r20
    eor r16, r20             // Alternar el estado de la alarma (estado_alarma = estado_alarma ^ 1)
    tst r16                  // Probar el estado de la alarma
    brne activar_alarma     // Saltar a activar_alarma si la alarma está activada

desactivar_alarma:
    sbi PORTB, 2             // Apagar LED_ROJO (alarma desactivada)
    cbi PORTB, 3             // Encender LED_VERDE (alarma desactivada)
    cbi PORTB, 0             // Apagar BUZZER (alarma desactivada)
    ret                      // Retornar de la función

activar_alarma:
    cbi PORTB, 2             // Encender LED_ROJO (alarma activada)
    sbi PORTB, 3             // Apagar LED_VERDE (alarma activada)
    sbi PORTB, 0             // Encender BUZZER (alarma activada)
    ret                      // Retornar de la función

//Función para Verificar Sensores (verificar_sensores):
verificar_sensores:
    in r24, PINC             // Leer estado de los sensores en PINC

    sbrs r24, 0              // Saltar si SENSOR1 está activado
    rjmp sensor_activado    // Saltar a sensor_activado si SENSOR1 está activado

    sbrs r24, 1              // Saltar si SENSOR2 está activado
    rjmp sensor_activado    // Saltar a sensor_activado si SENSOR2 está activado

    sbrs r24, 2              // Saltar si SENSOR3 está activado
    rjmp sensor_activado    // Saltar a sensor_activado si SENSOR3 está activado

    cbi PORTB, 2             // Apagar LED_AMARILLO (ningún sensor activado)
    tst r16                   // Probar el estado de la alarma
    brne mantener_buzzer    // Saltar a mantener_buzzer si la alarma está activada
    cbi PORTB, 0             // Apagar BUZZER (alarma desactivada)
    ret                      // Retornar de la función

mantener_buzzer:
    ret                      // Retornar de la función

sensor_activado:
    sbi PORTB, 2             // Encender LED_AMARILLO (sensor activado)
    sbi PORTB, 0             // Encender BUZZER (sensor activado)
    ret                      // Retornar de la función
