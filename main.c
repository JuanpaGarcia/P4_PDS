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

#define DELAY_TIME 0.000090579f	// periodo de muestreo
#define SYSTEM_CLOCK (21000000U)	//reloj de la k64

#define MCG_IRCLK_DISABLE 0U                   /*!< MCGIRCLK disabled */
#define MCG_PLL_DISABLE 0U                     /*!< MCGPLLCLK disabled */
#define OSC_CAP0P 0U                           /*!< Oscillator 0pF capacitor load
*/
#define OSC_ER_CLK_DISABLE 0U                  /*!< Disable external reference
clock */
#define SIM_CLKOUT_SEL_FLEXBUS_CLK 0U          /*!< CLKOUT pin clock select:
FlexBus clock */
#define SIM_ENET_1588T_CLK_SEL_OSCERCLK_CLK 2U /*!< SDHC clock select: OSCERCLK
clock */
#define SIM_ENET_RMII_CLK_SEL_EXTAL_CLK 0U     /*!< SDHC clock select: Core/system
clock */
#define SIM_OSC32KSEL_RTC32KCLK_CLK 2U         /*!< OSC32KSEL select: RTC32KCLK
clock (32.768kHz) */
#define SIM_PLLFLLSEL_IRC48MCLK_CLK 3U         /*!< PLLFLL select: IRC48MCLK clock
*/
#define SIM_PLLFLLSEL_MCGPLLCLK_CLK 1U         /*!< PLLFLL select: MCGPLLCLK clock
*/
#define SIM_SDHC_CLK_SEL_OSCERCLK_CLK 2U       /*!< SDHC clock select: OSCERCLK
clock */
#define SIM_TRACE_CLK_SEL_CORE_SYSTEM_CLK 1U   /*!< Trace clock select: Core/system
clock */
#define SIM_USB_CLK_120000000HZ 120000000U     /*!< Input SIM frequency for USB:
120000000Hz */

void init();											//función inicializar los puertos I/o y DAC & ADC
void init_interrupt();									// inicializar y activar interrupciones


uint16_t signal_input[93000] = {0};

const uint32_t g_Adc16_12bitFullRange = 4096U;

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

    while(1) {

    	//ADC16_SetChannelConfig(DEMO_ADC16_BASE, DEMO_ADC16_CHANNEL_GROUP, &adc16ChannelConfigStruct);
    	if(PIT_get_interrupt_flag_status()){

    		uint16_t value = get_note();
    		DAC_SetBufferValue(DAC0, 0U, value);

			PIT_clear_interrupt_flag();			//LIMPIAMOS BANDERA DE INTERRUPCIÓN
    		}
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

	mcg_pll_config_t   pll0Config =
	          {
	              .enableMode = MCG_PLL_DISABLE, /* MCGPLLCLK disabled */
	              .prdiv      = 0xeU,            /* PLL Reference divider:
	divided by 15 */
	              .vdiv       = 0xCU,            /* VCO divider: multiplied
	by 36 */
	          };
	const osc_config_t osc_config = {
	    .freq        = 50000000U,    /* Oscillator frequency: 50000000Hz */
	    .capLoad     = (OSC_CAP0P),  /* Oscillator capacity load: 0pF */
	    .workMode    = kOSC_ModeExt, /* Use external clock */
	    .oscerConfig = {
	        .enableMode =
	            kOSC_ErClkEnable, /* Enable external reference clock, disable
	external reference clock in STOP mode */
	    }};
	 CLOCK_SetSimSafeDivs();
	 CLOCK_InitOsc0(&osc_config);
	 CLOCK_SetXtal0Freq(osc_config.freq);
	 CLOCK_SetFbiMode(kMCG_Dmx32Default, kMCG_DrsLow, NULL);
	 CLOCK_SetFbeMode(0, kMCG_Dmx32Default, kMCG_DrsLow, NULL);
	 CLOCK_SetPbeMode(kMCG_PllClkSelPll0, &pll0Config);
	 CLOCK_SetPeeMode();
	SystemCoreClock = CLOCK_GetFreq(kCLOCK_CoreSysClk);
}

void init_interrupt()
{

	/**Sets the threshold for interrupts, if the interrupt has higher priority constant that the BASEPRI, the interrupt will not be attended*/
	NVIC_set_basepri_threshold(PRIORITY_10);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PIT_CH0_IRQ, PRIORITY_2);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PORTC_IRQ, PRIORITY_4);
	/**Enables and sets a particular interrupt and its priority*/
	NVIC_enable_interrupt_and_priotity(PORTA_IRQ, PRIORITY_4);
	/*Puerto para la selecciÃ³n de estado, swithces*/
	NVIC_enable_interrupt_and_priotity(PORTB_IRQ, PRIORITY_5);


	NVIC_global_enable_interrupts;

}





