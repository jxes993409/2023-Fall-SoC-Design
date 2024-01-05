# Waveform show

* Prefetch data when sdram is not busy

![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/LabD/waveform/prefetch.png)

# Bank interleave

Change the location of section `.bss` and `.data`, and make sure data and code are in same row but different bank.

In LabD, we put code in bank[0], bank[1], and put data in bank[2], bank[3].

# Tip

In ![setcions.lds](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/LabD/firmware/sections.lds), the original gcclib `<__mulsi3>` is in spiflash. It will take long time to access this library

Hence, comment `*(.text .stub .text.* .gnu.linkonce.t.*)` in `.text`, add `*libgcc.a:*(.text .text.*)` in `.mprjram` section.