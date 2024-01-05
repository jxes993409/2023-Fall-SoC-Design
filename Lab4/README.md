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

## Block Diagram

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab4/waveform/Lab4-2/block.png)

## Waveform Show

1. Flag hang, use flag `hang` to stop fir until Y is recevied

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab4/waveform/Lab4-2/hang.png)

2. Use counter to count data out, `sm_tlast = 1` when counter == 64

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab4/waveform/Lab4-2/sm_tlast.png)

## Register address

* Table of reg address

|     Reg     |          Address          |
|:-----------:|:-------------------------:|
|   ap_ctrl   |        0x3000_0004        |
| data_length |        0x3000_0010        |
|  tap_data   | 0x3000_0040 ~ 0x3000_0068 |
|    reg_x    |        0x30000080         |
|    reg_y    |        0x30000088         |

* Table of `ap_ctrl[4:0]`

|      Reg      | Bit |
|:-------------:|:---:|
|   ap_start    |  0  |
|    ap_done    |  1  |
|    ap_idle    |  2  |
| ap_x (unused) |  3  |
| ap_y (unused) |  4  |