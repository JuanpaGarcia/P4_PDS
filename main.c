#include <stdio.h>
#include "GPIO.h"
#include "PIT.h"
#include "NVIC.h"
#include "Bits.h"
#include "DAC.h"
#include "RGB.h"
#include "fsl_dac.h"
#include <stdio.h>
#include<math.h>
#include "musical.h"
#include "fsl_clock.h"

#include "fsl_common.h"
#include "fsl_device_registers.h"
#include "fsl_debug_console.h"
#include "fsl_common.h"
#include "fsl_adc16.h"

#define DEMO_ADC16_BASE          ADC0	//Seleccionamos el ADC a utilizar
#define DEMO_ADC16_CHANNEL_GROUP 0U		//Seleccionar el canal
#define DEMO_ADC16_USER_CHANNEL  12U

#define DELAY_TIME 0.000090579f	// periodo de muestreo 11025z
#define SYSTEM_CLOCK (21000000U)	//reloj de la k64

void init(void);											//función inicializar los puertos I/o y DAC & ADC
void init_interrupt(void);									// inicializar y activar interrupciones

void play_tone(void);
void play_song(void);

int main(void) {

	init();		// manda a llamar inicialización de puertos
	init_interrupt();	//manda a llamar inicialización de interrupciones

    dac_config_t dacConfigStruct;	//estructura de configuración del DAC

    //las siguientes lineas inicializan al DAC
    DAC_GetDefaultConfig(&dacConfigStruct);
    DAC_Init(DAC0, &dacConfigStruct);
    DAC_Enable(DAC0, true);             /* Enable output. */
    DAC_SetBufferReadPointer(DAC0, 0U);


    PIT_delay(PIT_0, SYSTEM_CLOCK, DELAY_TIME);// EMPEZAMOS LA FREQ DE MUESTREO
    uint16_t value = 0;
    while(1)
    {
    }
    return 0 ;
}


void init()
{
	//configurar entradas switches puerto b como
	gpio_pin_control_register_t input_intr_config = GPIO_MUX1|GPIO_PE|GPIO_PS|INTR_FALLING_EDGE; // SW interrupt config
	gpio_pin_control_register_t input_intr_config_dp_sw = GPIO_MUX1|GPIO_PS|INTR_EITHER_EDGE;//interrupcion sw puerto b

	GPIO_clock_gating(GPIO_A);//VOLUMEN SW3
	GPIO_clock_gating(GPIO_B);//SWITHCES
	GPIO_clock_gating(GPIO_C);//VOLUMEN SW2
	GPIO_clock_gating(GPIO_E);

	gpio_pin_control_register_t pcr_gpioe_pin_led = GPIO_MUX1;
	gpio_pin_control_register_t pcr_gpiob_pin_led = GPIO_MUX1;

	GPIO_pin_control_register(GPIO_B,bit_21,&pcr_gpiob_pin_led);
	GPIO_pin_control_register(GPIO_B,bit_22,&pcr_gpiob_pin_led);
	GPIO_pin_control_register(GPIO_E,bit_26,&pcr_gpioe_pin_led);

	GPIO_pin_control_register(GPIO_A,bit_4, &input_intr_config);
	GPIO_pin_control_register(GPIO_C,bit_6, &input_intr_config);

	GPIO_pin_control_register(GPIO_B, bit_3,&input_intr_config_dp_sw);
	GPIO_pin_control_register(GPIO_B, bit_10,&input_intr_config_dp_sw);

	GPIO_data_direction_pin(GPIO_C, GPIO_INPUT, bit_6);
	GPIO_data_direction_pin(GPIO_A, GPIO_INPUT, bit_4);

	GPIO_data_direction_pin(GPIO_B, GPIO_INPUT, bit_3);
	GPIO_data_direction_pin(GPIO_B, GPIO_INPUT, bit_10);
	//
	GPIO_data_direction_pin(GPIO_B, GPIO_OUTPUT, bit_21);
	GPIO_data_direction_pin(GPIO_B, GPIO_OUTPUT, bit_22);
	GPIO_data_direction_pin(GPIO_E, GPIO_OUTPUT, bit_26);

	//
	PIT_clock_gating();
	PIT_enable();
}

void init_interrupt()
{

	/**Sets the threshold for interrupts, if the interrupt has higher priority constant that the BASEPRI, the interrupt will not be attended*/
	NVIC_set_basepri_threshold(PRIORITY_10);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PIT_CH0_IRQ, PRIORITY_2);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PIT_CH1_IRQ, PRIORITY_2);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PORTC_IRQ, PRIORITY_4);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PORTA_IRQ, PRIORITY_4);
	/*Puerto para la selecciÃ³n de estado, swithces*/
	NVIC_enable_interrupt_and_priotity(PORTB_IRQ, PRIORITY_5);

	NVIC_global_enable_interrupts;
}

void play_tone(void)
{
	int counter = 0;
	uint16_t value;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = get_note(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);
}


void play_song(void)
{
	int counter = 0;
	uint16_t value;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Do(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);


	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Do(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);


	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = La(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = La(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Fa(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Fa(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Re(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Re(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Do(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////Primera parte///////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////

	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Mi(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);


	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Fa(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);


	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = Sol(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);


	counter = 0;
	while(1)
	{
	   	if(PIT_get_interrupt_flag_status())
	   	{

		value = La(counter);

		DAC_SetBufferValue(DAC0, 0U, value);

		PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN

		counter++;
		}
	   	if(counter <= time_up) break;
	}
	DAC_SetBufferValue(DAC0, 0U, value);

}


