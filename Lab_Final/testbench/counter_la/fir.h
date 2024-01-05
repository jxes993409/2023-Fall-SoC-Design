#ifndef __FIR_H__
#define __FIR_H__

#define N 64

// int taps[N] = {0, -10, -9, 23, 56, 63, 56, 23, -9, -10, 0};
int outputsignal[N];

// ap control
#define reg_ctrl (*(volatile long unsigned int*)0x32000004)

// data length
#define reg_len (*(volatile long unsigned int*)0x32000010)

// tap address
#define reg_tap_00 (*(volatile long unsigned int*)0x32000040)
#define reg_tap_01 (*(volatile long unsigned int*)0x32000044)
#define reg_tap_02 (*(volatile long unsigned int*)0x32000048)
#define reg_tap_03 (*(volatile long unsigned int*)0x3200004c)
#define reg_tap_04 (*(volatile long unsigned int*)0x32000050)
#define reg_tap_05 (*(volatile long unsigned int*)0x32000054)
#define reg_tap_06 (*(volatile long unsigned int*)0x32000058)
#define reg_tap_07 (*(volatile long unsigned int*)0x3200005c)
#define reg_tap_08 (*(volatile long unsigned int*)0x32000060)
#define reg_tap_09 (*(volatile long unsigned int*)0x32000064)
#define reg_tap_10 (*(volatile long unsigned int*)0x32000068)

// X[n] address

#define reg_x (*(volatile long unsigned int*)0x32000080)

// Y[n] address

#define reg_y (*(volatile long unsigned int*)0x32000088)

#endif