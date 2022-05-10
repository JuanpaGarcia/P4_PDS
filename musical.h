/*
 * musical.h
 *
 *  Created on: 9 may 2022
 *      Author: garci
 */

#ifndef MUSICAL_H_
#define MUSICAL_H_

#include <stdint.h>
#include <math.h>

#define length_note 59300
#define pi  3.1415926535

uint16_t Do(void);
uint16_t Re(void);
uint16_t Mi(void);
uint16_t Fa(void);
uint16_t Sol(void);
uint16_t La(void);
uint16_t get_note(void);

#define time_up 58100
#define abs_min_note 3.3870f
#define max_note 3.3837f

#endif /* MUSICAL_H_ */
