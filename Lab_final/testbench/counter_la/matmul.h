#ifndef _MATMUL_H
#define _MATMUL_H

#define SIZE 4
#define reg_y (*(volatile unsigned int*)0x34000040)

int result[SIZE*SIZE];

#endif
