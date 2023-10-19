# Synthesis Report
|        Site Type        | Used | Fixed | Prohibited | Available | Util% |
| ---- | ---- | ---- | ---- | ---- | ---- |
| Slice LUTs*             |  196 |     0 |          0 |     53200 |  0.37 |
|   LUT as Logic          |  196 |     0 |          0 |     53200 |  0.37 |
|   LUT as Memory         |    0 |     0 |          0 |     17400 |  0.00 |
| Slice Registers         |  363 |     0 |          0 |    106400 |  0.34 |
|   Register as Flip Flop |   23 |     0 |          0 |    106400 |  0.02 |
|   Register as Latch     |  340 |     0 |          0 |    106400 |  0.32 |
| F7 Muxes                |    0 |     0 |          0 |     26600 |  0.00 |
| F8 Muxes                |    0 |     0 |          0 |     13300 |  0.00 |
# Waveform Show
* Configuration Write

1. `awvalid` trigered, enable bram and send address

2. trigger `wready`, send data

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab3/waveform/Waveform0.png)

* X stream in

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab3/waveform/Waveform1.png)

1. trigger `ss_tready`

* Y stream out

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab3/waveform/Waveform2.png)

1. When `ss_tready` triggered, lock fsm state (counter_current_state) and send X stream to bram

2. Read the original data (bram[0]), and read data at next cycle

3. When `reg counter` = 10, trigger sm_tvalid and send Y stream out