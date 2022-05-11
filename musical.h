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
#include "PIT.h"

#define length_note 59300
#define pi  3.1415926535


uint16_t Do(int32_t value);
uint16_t Re(int32_t value);
uint16_t Mi(int32_t value);
uint16_t Fa(int32_t value);
uint16_t Sol(int32_t value);
uint16_t La(int32_t value);
uint16_t get_note(int32_t value);

#define time_up 58100
#define one_time 14525
#define two_times  29050

#define abs_min_note 3.3870f
#define max_note 3.3837f

#endif /* MUSICAL_H_ */
