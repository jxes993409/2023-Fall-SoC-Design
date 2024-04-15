# Lab Final

![image](https://github.com/jxes993409/2023-Fall-SoC-Design/blob/main/Lab_Final/images/soc.jpg)

## Optimize task execution for faster execution time
1. Uart interrupt testing
2. **Matrix multiplication (MM)** (in C)
3. Array sorting (in C)
4. **FIR calculation** (in C)
* Reduce time from 560000T to 93000T, **6x faster**!

## SDRAM prefetch
* From **12T** per data -> **6.25T** per data (50T per 8 data)
![image](https://github.com/jxes993409/2023-Fall-SoC-Design/blob/main/Lab_Final/images/prefetch.png)
## Bank interleaved
* Use section attribute to separate code and data into different banks

## Design a hardware FIR
* Using AXI protocol in FIR, and handshake with Wishbone protocol
## Change MM for loop sequence
* From ijk method to kij method


| IJK method                                                                                      |                                           KIJ method                                            |
| ----------------------------------------------------------------------------------------------- |:-----------------------------------------------------------------------------------------------:|
| ![image](https://github.com/jxes993409/2023-Fall-SoC-Design/blob/main/Lab_Final/images/ijk.png) | ![image](https://github.com/jxes993409/2023-Fall-SoC-Design/blob/main/Lab_Final/images/kij.png) |

