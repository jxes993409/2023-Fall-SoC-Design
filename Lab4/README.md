# Lab 4-1

## Waveform Show

1. WB read data from bram, and wait bram for 12T to ready.
![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab4/waveform/Lab4-1/bram.png)

2. Send data to testbench by using mprj port
![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab4/waveform/Lab4-1/mprj.png)

## FIR firmware code
```c=
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

  for (int i = 0; i < N; i++)
  {
    // shift tap data (inputbuffer)
    for (int i = N - 1; i > 0; i--)
    {
      inputbuffer[i] = inputbuffer[i - 1];
    }
    inputbuffer[0] = inputsignal[i];

    // do fir operation
    for (int j = 0; j < N; j++)
    {
      outputsignal[i] += inputbuffer[j] * taps[j];
    }
  }
  return outputsignal;
}
```

# Lab 4-2