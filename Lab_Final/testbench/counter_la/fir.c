#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir()
{
	// send tap data

	reg_tap_00 =   0;
	reg_tap_01 = -10;
	reg_tap_02 =  -9;
	reg_tap_03 =  23;
	reg_tap_04 =  56;
	reg_tap_05 =  63;
	reg_tap_06 =  56;
	reg_tap_07 =  23;
	reg_tap_08 =  -9;
	reg_tap_09 = -10;
	reg_tap_10 =   0;

	// send data length
	reg_len = 64;

	reg_ctrl = 1;

}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir()
{
	initfir();
	//write down your fir
	for (int i = 1; i <= 64; i++)
	{
		// ready to accept x
		// while ((reg_ctrl >> 4 & 1) != 1) {}
		reg_x = i;
		// ready to accept y
		// while ((reg_ctrl >> 5 & 1) != 1) {}
		outputsignal[i - 1] = reg_y;
	}
	return outputsignal;
}
		
