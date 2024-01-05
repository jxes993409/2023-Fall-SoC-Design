#include "fir.h"

void __attribute__((section(".mprjram"))) initfir()
{
	// initial your fir
	for (int i = 0; i < N; i++)
	{
		outputsignal[i] = 0;
		inputbuffer[i] = 0;
	}
}

int *__attribute__((section(".mprjram"))) fir()
{
	initfir();
	// write down your fir
	for (int i = 0; i < N; i++)
	{
		for (int i = N - 1; i > 0; i--)
		{
			inputbuffer[i] = inputbuffer[i - 1];
		}
		inputbuffer[0] = inputsignal[i];

		for (int j = 0; j < N; j++)
		{
			outputsignal[i] += inputbuffer[j] * taps[j];
		}
	}
	return outputsignal;
}
