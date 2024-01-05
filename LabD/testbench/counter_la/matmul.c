#include "matmul.h"

int *__attribute__((section(".mprjram"))) matmul()
{
	for (int i = 0; i < SIZE; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			int sum = 0;
			for (int k = 0; k < SIZE; k++)
			{
				sum += A[(i * SIZE) + k] * B[(k * SIZE) + j];
			}
			result[(i * SIZE) + j] = sum;
		}
	}
	return result;
}
