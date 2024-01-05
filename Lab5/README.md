# Block diagram
![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab5/waveform/block0.png)
![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab5/waveform/io.png)
![](https://github.com/jxes993409/2023-Spring-SoC-Design/blob/main/Lab5/waveform/block1.png)



## Read_ROMcode
<!--
.hex file store in DDR memory
call read_romcode() to move it from DDR to BRAM
-->

Add AXI-Master Path: 
Introduce an additional AXI-master path to facilitate writing to PS Memory.

Load RISCV Code: 
Load program.hex (RISCV code from any Caravel testbench) into the PS memory buffer.

Develop Host Code: 
Create host code to load program.hex to BRAM and read from BRAM.


Copy DRAM to BRAM: 
Copy the PS DRAM buffer to BRAM based on the size of the binary file, limiting BRAM size to 8K.
 
HLS Implementation and IP Export: 
1. Utilize High-Level Synthesis (HLS) to implement the functionality.
2. Export IP for seamless integration into a Vivado project.

## Spiflash
<!--
load data from bram
transfer it to caravel soc by mprj
-->

1. Implement SPI slave device, only support read command (0x03)
2. Return data from BRAM to Caravel
## Caravel

### PS
1. Provide AXI Lite interface for PS CPU to read the mprj_io/out/EN bits
2. Implement by HLS and export IP for Vivado project usage.


### GPIO
1. Used to assert/de-assert Caravel reset pin
2. Provide AXI LITE interface for PS CPU to control the output
3. Implement by HLS and export IP for Vivado project usage


# FPGA utilization
```
Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------
| Tool Version : Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
| Date         : Mon Nov 20 20:40:56 2023
| Host         : ubuntu running 64-bit Ubuntu 20.04.6 LTS
| Command      : report_utilization -file design_1_wrapper_utilization_synth.rpt -pb design_1_wrapper_utilization_synth.pb
| Design       : design_1_wrapper
| Device       : xc7z020clg400-1
| Speed File   : -1
| Design State : Synthesized
---------------------------------------------------------------------------------------------------------------------------

Utilization Design Information

Table of Contents
-----------------
1. Slice Logic
1.1 Summary of Registers by Type
2. Slice Logic Distribution
3. Memory
4. DSP
5. IO and GT Specific
6. Clocking
7. Specific Feature
8. Primitives
9. Black Boxes
10. Instantiated Netlists

1. Slice Logic
--------------

+-------------------------+------+-------+------------+-----------+-------+
|        Site Type        | Used | Fixed | Prohibited | Available | Util% |
+-------------------------+------+-------+------------+-----------+-------+
| Slice LUTs              |    0 |     0 |          0 |     53200 |  0.00 |
|   LUT as Logic          |    0 |     0 |          0 |     53200 |  0.00 |
|   LUT as Memory         |    0 |     0 |          0 |     17400 |  0.00 |
| Slice Registers         |    0 |     0 |          0 |    106400 |  0.00 |
|   Register as Flip Flop |    0 |     0 |          0 |    106400 |  0.00 |
|   Register as Latch     |    0 |     0 |          0 |    106400 |  0.00 |
| F7 Muxes                |    0 |     0 |          0 |     26600 |  0.00 |
| F8 Muxes                |    0 |     0 |          0 |     13300 |  0.00 |
+-------------------------+------+-------+------------+-----------+-------+
* Warning! LUT value is adjusted to account for LUT combining.


1.1 Summary of Registers by Type
--------------------------------

+-------+--------------+-------------+--------------+
| Total | Clock Enable | Synchronous | Asynchronous |
+-------+--------------+-------------+--------------+
| 0     |            _ |           - |            - |
| 0     |            _ |           - |          Set |
| 0     |            _ |           - |        Reset |
| 0     |            _ |         Set |            - |
| 0     |            _ |       Reset |            - |
| 0     |          Yes |           - |            - |
| 0     |          Yes |           - |          Set |
| 0     |          Yes |           - |        Reset |
| 0     |          Yes |         Set |            - |
| 0     |          Yes |       Reset |            - |
+-------+--------------+-------------+--------------+


2. Slice Logic Distribution
---------------------------

+------------------------------------------+------+-------+------------+-----------+-------+
|                 Site Type                | Used | Fixed | Prohibited | Available | Util% |
+------------------------------------------+------+-------+------------+-----------+-------+
| Slice                                    |    0 |     0 |          0 |     13300 |  0.00 |
|   SLICEL                                 |    0 |     0 |            |           |       |
|   SLICEM                                 |    0 |     0 |            |           |       |
| LUT as Logic                             |    0 |     0 |          0 |     53200 |  0.00 |
| LUT as Memory                            |    0 |     0 |          0 |     17400 |  0.00 |
|   LUT as Distributed RAM                 |    0 |     0 |            |           |       |
|   LUT as Shift Register                  |    0 |     0 |            |           |       |
| Slice Registers                          |    0 |     0 |          0 |    106400 |  0.00 |
|   Register driven from within the Slice  |    0 |       |            |           |       |
|   Register driven from outside the Slice |    0 |       |            |           |       |
| Unique Control Sets                      |    0 |       |          0 |     13300 |  0.00 |
+------------------------------------------+------+-------+------------+-----------+-------+
* * Note: Available Control Sets calculated as Slice * 1, Review the Control Sets Report for more information regarding control sets.


3. Memory
---------

+----------------+------+-------+------------+-----------+-------+
|    Site Type   | Used | Fixed | Prohibited | Available | Util% |
+----------------+------+-------+------------+-----------+-------+
| Block RAM Tile |    0 |     0 |          0 |       140 |  0.00 |
|   RAMB36/FIFO* |    0 |     0 |          0 |       140 |  0.00 |
|   RAMB18       |    0 |     0 |          0 |       280 |  0.00 |
+----------------+------+-------+------------+-----------+-------+
* Note: Each Block RAM Tile only has one FIFO logic available and therefore can accommodate only one FIFO36E1 or one FIFO18E1. However, if a FIFO18E1 occupies a Block RAM Tile, that tile can still accommodate a RAMB18E1


4. DSP
------

+-----------+------+-------+------------+-----------+-------+
| Site Type | Used | Fixed | Prohibited | Available | Util% |
+-----------+------+-------+------------+-----------+-------+
| DSPs      |    0 |     0 |          0 |       220 |  0.00 |
+-----------+------+-------+------------+-----------+-------+


5. IO and GT Specific
---------------------

+-----------------------------+------+-------+------------+-----------+-------+
|          Site Type          | Used | Fixed | Prohibited | Available | Util% |
+-----------------------------+------+-------+------------+-----------+-------+
| Bonded IOB                  |    0 |     0 |          0 |       125 |  0.00 |
| Bonded IPADs                |    0 |     0 |          0 |         2 |  0.00 |
| Bonded IOPADs               |    0 |     0 |          0 |       130 |  0.00 |
| PHY_CONTROL                 |    0 |     0 |          0 |         4 |  0.00 |
| PHASER_REF                  |    0 |     0 |          0 |         4 |  0.00 |
| OUT_FIFO                    |    0 |     0 |          0 |        16 |  0.00 |
| IN_FIFO                     |    0 |     0 |          0 |        16 |  0.00 |
| IDELAYCTRL                  |    0 |     0 |          0 |         4 |  0.00 |
| IBUFDS                      |    0 |     0 |          0 |       121 |  0.00 |
| PHASER_OUT/PHASER_OUT_PHY   |    0 |     0 |          0 |        16 |  0.00 |
| PHASER_IN/PHASER_IN_PHY     |    0 |     0 |          0 |        16 |  0.00 |
| IDELAYE2/IDELAYE2_FINEDELAY |    0 |     0 |          0 |       200 |  0.00 |
| ILOGIC                      |    0 |     0 |          0 |       125 |  0.00 |
| OLOGIC                      |    0 |     0 |          0 |       125 |  0.00 |
+-----------------------------+------+-------+------------+-----------+-------+


6. Clocking
-----------

+------------+------+-------+------------+-----------+-------+
|  Site Type | Used | Fixed | Prohibited | Available | Util% |
+------------+------+-------+------------+-----------+-------+
| BUFGCTRL   |    0 |     0 |          0 |        32 |  0.00 |
| BUFIO      |    0 |     0 |          0 |        16 |  0.00 |
| MMCME2_ADV |    0 |     0 |          0 |         4 |  0.00 |
| PLLE2_ADV  |    0 |     0 |          0 |         4 |  0.00 |
| BUFMRCE    |    0 |     0 |          0 |         8 |  0.00 |
| BUFHCE     |    0 |     0 |          0 |        72 |  0.00 |
| BUFR       |    0 |     0 |          0 |        16 |  0.00 |
+------------+------+-------+------------+-----------+-------+


7. Specific Feature
-------------------

+-------------+------+-------+------------+-----------+-------+
|  Site Type  | Used | Fixed | Prohibited | Available | Util% |
+-------------+------+-------+------------+-----------+-------+
| BSCANE2     |    0 |     0 |          0 |         4 |  0.00 |
| CAPTUREE2   |    0 |     0 |          0 |         1 |  0.00 |
| DNA_PORT    |    0 |     0 |          0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |          0 |         1 |  0.00 |
| FRAME_ECCE2 |    0 |     0 |          0 |         1 |  0.00 |
| ICAPE2      |    0 |     0 |          0 |         2 |  0.00 |
| STARTUPE2   |    0 |     0 |          0 |         1 |  0.00 |
| XADC        |    0 |     0 |          0 |         1 |  0.00 |
+-------------+------+-------+------------+-----------+-------+


8. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+


9. Black Boxes
--------------

+---------------------------------+------+
|             Ref Name            | Used |
+---------------------------------+------+
| design_1_xbar_0                 |    1 |
| design_1_spiflash_0_0           |    1 |
| design_1_rst_ps7_0_10M_0        |    1 |
| design_1_read_romcode_0_0       |    1 |
| design_1_processing_system7_0_0 |    1 |
| design_1_output_pin_0_0         |    1 |
| design_1_caravel_ps_0_0         |    1 |
| design_1_caravel_0_0            |    1 |
| design_1_blk_mem_gen_0_0        |    1 |
| design_1_auto_us_0              |    1 |
| design_1_auto_pc_1              |    1 |
| design_1_auto_pc_0              |    1 |
+---------------------------------+------+


10. Instantiated Netlists
-------------------------

+----------+------+
| Ref Name | Used |
+----------+------+
```



# Function of IP

## HLS

### read_romcode
1. Check the `length parameter`
2. Read ROM code and move to bram
```cpp=1
// Check length parameter can't over than CODE_SIZE/4
if(length > (CODE_SIZE / sizeof(int)))
{
    length = (CODE_SIZE / sizeof(int));
}
// load ROMCODE
for(int i = 0; i < length; i++)
{
      #pragma HLS PIPELINE
      internal_bram[i] = romcode[i];
}
```

### ResetControl
<!-- MMIO reset -->
Output Pin reset by control signal
```cpp=1
{
	#pragma HLS INTERFACE s_axilite port=outpin_ctrl
	#pragma HLS INTERFACE ap_none port=outpin
	#pragma HLS INTERFACE ap_ctrl_none port=return

	outpin = outpin_ctrl;

	return;
}
```
### caravel_ps
<!-- The HLS implementation of mprj_io -->
Decide mprj_IO be input or output mode
```cpp=1
for(int i = 0; i < NUM_IO; i++)
{
    #pragma HLS UNROLL
    mprj_in[i] = mprj_en[i] ? mprj_out[i] : ps_mprj_in[i];
}
```

## Verilog

### Spiflash

Simple SPI flash simulation model

This model samples io input signals 1ns before the SPI clock edge and updates output signals 1ns after the SPI clock edge.

Supported commands: `AB, B9, FF, 03, BB, EB, ED`

`AB`: powered_up = 1;

`B9`: powered_up = 0;

`FF`: xip_cmd = 0;

`03`: Read mode

`BB`: Dual I/O Read

`EB`: Quad I/O Read

`ED`: DDR Quad I/O Read

But in lab 5 spiflash.v only support `03` command (Read mode)

# Jupyter Notebook

## caravel_fpga.ipynb
1. load bitstream and set configuration
```python=1
from __future__ import print_function

import sys
import numpy as np
from time import time
import matplotlib.pyplot as plt 

sys.path.append('/home/xilinx')
from pynq import Overlay
from pynq import allocate

ROM_SIZE = 0x2000 #8K

ol = Overlay("/home/xilinx/jupyter_notebooks/caravel_fpga.bit")

ipOUTPIN = ol.output_pin_0
ipPS = ol.caravel_ps_0
ipReadROMCODE = ol.read_romcode_0
```
2. load bitstream to ROM and bram
```python=19
# Create np with 8K/4 (4 bytes per index) size and be initiled to 0
rom_size_final = 0

# Allocate dram buffer will assign physical address to ip ipReadROMCODE
npROM = allocate(shape=(ROM_SIZE >> 2,), dtype=np.uint32)

# Initial it by 0
for index in range (ROM_SIZE >> 2):
    npROM[index] = 0

npROM_index = 0
npROM_offset = 0
fiROM = open("counter_wb.hex", "r+")
#fiROM = open("counter_la.hex", "r+")
#fiROM = open("gcd_la.hex", "r+")

for line in fiROM:
    # offset header
    if line.startswith('@'):
        # Ignore first char @
        npROM_offset = int(line[1:].strip(b'\x00'.decode()), base = 16)
        npROM_offset = npROM_offset >> 2 # 4byte per offset
        #print (npROM_offset)
        npROM_index = 0
        continue
    #print (line)

    # We suppose the data must be 32bit alignment
    buffer = 0
    bytecount = 0
    for line_byte in line.strip(b'\x00'.decode()).split():
        buffer += int(line_byte, base = 16) << (8 * bytecount)
        bytecount += 1
        # Collect 4 bytes, write to npROM
        if(bytecount == 4):
            npROM[npROM_offset + npROM_index] = buffer
            # Clear buffer and bytecount
            buffer = 0
            bytecount = 0
            npROM_index += 1
            #print (npROM_index)
            continue 
    # Fill rest data if not alignment 4 bytes
    if (bytecount != 0):
        npROM[npROM_offset + npROM_index] = buffer
        npROM_index += 1
    
fiROM.close()

rom_size_final = npROM_offset + npROM_index
```
3. testing IPs read / write command
```python=69
# 0x00 : Control signals
#        bit 0  - ap_start (Read/Write/COH)
#        bit 1  - ap_done (Read/COR)
#        bit 2  - ap_idle (Read)
#        bit 3  - ap_ready (Read)
#        bit 7  - auto_restart (Read/Write)
#        others - reserved
# 0x10 : Data signal of romcode
#        bit 31~0 - romcode[31:0] (Read/Write)
# 0x14 : Data signal of romcode
#        bit 31~0 - romcode[63:32] (Read/Write)
# 0x1c : Data signal of length_r
#        bit 31~0 - length_r[31:0] (Read/Write)

# Program physical address for the romcode base address
ipReadROMCODE.write(0x10, npROM.device_address)
ipReadROMCODE.write(0x14, 0)
# Program length of moving data
ipReadROMCODE.write(0x1C, rom_size_final)


# ipReadROMCODE start to move the data from rom_buffer to bram
ipReadROMCODE.write(0x00, 1) # IP Start
while (ipReadROMCODE.read(0x00) & 0x04) == 0x00: # wait for done
    continue
    
print("Write to bram done")
```

# Screenshot of Execution result on all workload
## counter_wb.hex
```python
from __future__ import print_function

import sys
import numpy as np
from time import time
import matplotlib.pyplot as plt 

sys.path.append('/home/xilinx')
from pynq import Overlay
from pynq import allocate

ROM_SIZE = 0x2000 #8K
```






```python
ol = Overlay("/home/xilinx/jupyter_notebooks/caravel_fpga.bit")
#ol.ip_dict
```


```python
ipOUTPIN = ol.output_pin_0
ipPS = ol.caravel_ps_0
ipReadROMCODE = ol.read_romcode_0
```


```python
# Create np with 8K/4 (4 bytes per index) size and be initiled to 0
rom_size_final = 0

# Allocate dram buffer will assign physical address to ip ipReadROMCODE
npROM = allocate(shape=(ROM_SIZE >> 2,), dtype=np.uint32)

# Initial it by 0
for index in range (ROM_SIZE >> 2):
    npROM[index] = 0

npROM_index = 0
npROM_offset = 0
fiROM = open("counter_wb.hex", "r+")
#fiROM = open("counter_la.hex", "r+")
#fiROM = open("gcd_la.hex", "r+")

for line in fiROM:
    # offset header
    if line.startswith('@'):
        # Ignore first char @
        npROM_offset = int(line[1:].strip(b'\x00'.decode()), base = 16)
        npROM_offset = npROM_offset >> 2 # 4byte per offset
        #print (npROM_offset)
        npROM_index = 0
        continue
    #print (line)

    # We suppose the data must be 32bit alignment
    buffer = 0
    bytecount = 0
    for line_byte in line.strip(b'\x00'.decode()).split():
        buffer += int(line_byte, base = 16) << (8 * bytecount)
        bytecount += 1
        # Collect 4 bytes, write to npROM
        if(bytecount == 4):
            npROM[npROM_offset + npROM_index] = buffer
            # Clear buffer and bytecount
            buffer = 0
            bytecount = 0
            npROM_index += 1
            #print (npROM_index)
            continue
    # Fill rest data if not alignment 4 bytes
    if (bytecount != 0):
        npROM[npROM_offset + npROM_index] = buffer
        npROM_index += 1
    
fiROM.close()

rom_size_final = npROM_offset + npROM_index
#print (rom_size_final)

#for data in npROM:
#    print (hex(data))
```


```python
# 0x00 : Control signals
#        bit 0  - ap_start (Read/Write/COH)
#        bit 1  - ap_done (Read/COR)
#        bit 2  - ap_idle (Read)
#        bit 3  - ap_ready (Read)
#        bit 7  - auto_restart (Read/Write)
#        others - reserved
# 0x10 : Data signal of romcode
#        bit 31~0 - romcode[31:0] (Read/Write)
# 0x14 : Data signal of romcode
#        bit 31~0 - romcode[63:32] (Read/Write)
# 0x1c : Data signal of length_r
#        bit 31~0 - length_r[31:0] (Read/Write)

# Program physical address for the romcode base address
ipReadROMCODE.write(0x10, npROM.device_address)
ipReadROMCODE.write(0x14, 0)
# Program length of moving data
ipReadROMCODE.write(0x1C, rom_size_final)


# ipReadROMCODE start to move the data from rom_buffer to bram
ipReadROMCODE.write(0x00, 1) # IP Start
while (ipReadROMCODE.read(0x00) & 0x04) == 0x00: # wait for done
    continue
    
print("Write to bram done")

```

    Write to bram done



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))

```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0x8
    0x20 =  0x0
    0x34 =  0xfffffff7
    0x38 =  0x3f



```python
# Release Caravel reset
# 0x10 : Data signal of outpin_ctrl
#        bit 0  - outpin_ctrl[0] (Read/Write)
#        others - reserved
print (ipOUTPIN.read(0x10))
ipOUTPIN.write(0x10, 1)
print (ipOUTPIN.read(0x10))
```

    0
    1



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))
```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0xab600008
    0x20 =  0x2
    0x34 =  0xfff7
    0x38 =  0x37

<!--
![螢幕擷取畫面 2023-11-22 012752](https://hackmd.io/_uploads/BkJkov5V6.png)
![螢幕擷取畫面 2023-11-22 012832](https://hackmd.io/_uploads/rJJ1jw5Va.png)
![螢幕擷取畫面 2023-11-22 012920](https://hackmd.io/_uploads/Hk1JoPqVT.png)
![螢幕擷取畫面 2023-11-22 012947](https://hackmd.io/_uploads/HykysDcNa.png)
![螢幕擷取畫面 2023-11-22 013006](https://hackmd.io/_uploads/BJr-sDqEp.png)
![螢幕擷取畫面 2023-11-22 013025](https://hackmd.io/_uploads/SJHWsP9ET.png)
![螢幕擷取畫面 2023-11-22 013055](https://hackmd.io/_uploads/rJHboDcNT.png)
![螢幕擷取畫面 2023-11-22 013108](https://hackmd.io/_uploads/BJrbswqEp.png)
-->

## counter_la.hex
```python
from __future__ import print_function

import sys
import numpy as np
from time import time
import matplotlib.pyplot as plt 

sys.path.append('/home/xilinx')
from pynq import Overlay
from pynq import allocate

ROM_SIZE = 0x2000 #8K
```


```python
ol = Overlay("/home/xilinx/jupyter_notebooks/caravel_fpga.bit")
#ol.ip_dict
```


```python
ipOUTPIN = ol.output_pin_0
ipPS = ol.caravel_ps_0
ipReadROMCODE = ol.read_romcode_0
```


```python
# Create np with 8K/4 (4 bytes per index) size and be initiled to 0
rom_size_final = 0

# Allocate dram buffer will assign physical address to ip ipReadROMCODE
npROM = allocate(shape=(ROM_SIZE >> 2,), dtype=np.uint32)

# Initial it by 0
for index in range (ROM_SIZE >> 2):
    npROM[index] = 0

npROM_index = 0
npROM_offset = 0
#fiROM = open("counter_wb.hex", "r+")
fiROM = open("counter_la.hex", "r+")
#fiROM = open("gcd_la.hex", "r+")

for line in fiROM:
    # offset header
    if line.startswith('@'):
        # Ignore first char @
        npROM_offset = int(line[1:].strip(b'\x00'.decode()), base = 16)
        npROM_offset = npROM_offset >> 2 # 4byte per offset
        #print (npROM_offset)
        npROM_index = 0
        continue
    #print (line)

    # We suppose the data must be 32bit alignment
    buffer = 0
    bytecount = 0
    for line_byte in line.strip(b'\x00'.decode()).split():
        buffer += int(line_byte, base = 16) << (8 * bytecount)
        bytecount += 1
        # Collect 4 bytes, write to npROM
        if(bytecount == 4):
            npROM[npROM_offset + npROM_index] = buffer
            # Clear buffer and bytecount
            buffer = 0
            bytecount = 0
            npROM_index += 1
            #print (npROM_index)
            continue
    # Fill rest data if not alignment 4 bytes
    if (bytecount != 0):
        npROM[npROM_offset + npROM_index] = buffer
        npROM_index += 1
    
fiROM.close()

rom_size_final = npROM_offset + npROM_index
#print (rom_size_final)

#for data in npROM:
#    print (hex(data))
```


```python
# 0x00 : Control signals
#        bit 0  - ap_start (Read/Write/COH)
#        bit 1  - ap_done (Read/COR)
#        bit 2  - ap_idle (Read)
#        bit 3  - ap_ready (Read)
#        bit 7  - auto_restart (Read/Write)
#        others - reserved
# 0x10 : Data signal of romcode
#        bit 31~0 - romcode[31:0] (Read/Write)
# 0x14 : Data signal of romcode
#        bit 31~0 - romcode[63:32] (Read/Write)
# 0x1c : Data signal of length_r
#        bit 31~0 - length_r[31:0] (Read/Write)

# Program physical address for the romcode base address
ipReadROMCODE.write(0x10, npROM.device_address)
ipReadROMCODE.write(0x14, 0)
# Program length of moving data
ipReadROMCODE.write(0x1C, rom_size_final)


# ipReadROMCODE start to move the data from rom_buffer to bram
ipReadROMCODE.write(0x00, 1) # IP Start
while (ipReadROMCODE.read(0x00) & 0x04) == 0x00: # wait for done
    continue
    
print("Write to bram done")

```

    Write to bram done



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))

```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0x8
    0x20 =  0x0
    0x34 =  0xfffffff7
    0x38 =  0x3f



```python
# Release Caravel reset
# 0x10 : Data signal of outpin_ctrl
#        bit 0  - outpin_ctrl[0] (Read/Write)
#        others - reserved
print (ipOUTPIN.read(0x10))
ipOUTPIN.write(0x10, 1)
print (ipOUTPIN.read(0x10))
```

    0
    1



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))
```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0xab400040
    0x20 =  0x0
    0x34 =  0x0
    0x38 =  0x3f
<!--
![螢幕擷取畫面 2023-11-22 225536](https://hackmd.io/_uploads/Hy4hNss4p.png)
![螢幕擷取畫面 2023-11-22 225607](https://hackmd.io/_uploads/B1NnEojNT.png)
![螢幕擷取畫面 2023-11-22 225633](https://hackmd.io/_uploads/SkVhNojE6.png)
![螢幕擷取畫面 2023-11-22 225708](https://hackmd.io/_uploads/HJ43EooEa.png)
![螢幕擷取畫面 2023-11-22 225848](https://hackmd.io/_uploads/HyN2Eos4a.png)
![螢幕擷取畫面 2023-11-22 225936](https://hackmd.io/_uploads/SkN3EioNT.png)
-->


## gcd_la.hex
```python
from __future__ import print_function

import sys
import numpy as np
from time import time
import matplotlib.pyplot as plt 

sys.path.append('/home/xilinx')
from pynq import Overlay
from pynq import allocate

ROM_SIZE = 0x2000 #8K
```


```python
ol = Overlay("/home/xilinx/jupyter_notebooks/caravel_fpga.bit")
#ol.ip_dict
```


```python
ipOUTPIN = ol.output_pin_0
ipPS = ol.caravel_ps_0
ipReadROMCODE = ol.read_romcode_0
```


```python
# Create np with 8K/4 (4 bytes per index) size and be initiled to 0
rom_size_final = 0

# Allocate dram buffer will assign physical address to ip ipReadROMCODE
npROM = allocate(shape=(ROM_SIZE >> 2,), dtype=np.uint32)

# Initial it by 0
for index in range (ROM_SIZE >> 2):
    npROM[index] = 0

npROM_index = 0
npROM_offset = 0
#fiROM = open("counter_wb.hex", "r+")
#fiROM = open("counter_la.hex", "r+")
fiROM = open("gcd_la.hex", "r+")

for line in fiROM:
    # offset header
    if line.startswith('@'):
        # Ignore first char @
        npROM_offset = int(line[1:].strip(b'\x00'.decode()), base = 16)
        npROM_offset = npROM_offset >> 2 # 4byte per offset
        #print (npROM_offset)
        npROM_index = 0
        continue
    #print (line)

    # We suppose the data must be 32bit alignment
    buffer = 0
    bytecount = 0
    for line_byte in line.strip(b'\x00'.decode()).split():
        buffer += int(line_byte, base = 16) << (8 * bytecount)
        bytecount += 1
        # Collect 4 bytes, write to npROM
        if(bytecount == 4):
            npROM[npROM_offset + npROM_index] = buffer
            # Clear buffer and bytecount
            buffer = 0
            bytecount = 0
            npROM_index += 1
            #print (npROM_index)
            continue
    # Fill rest data if not alignment 4 bytes
    if (bytecount != 0):
        npROM[npROM_offset + npROM_index] = buffer
        npROM_index += 1
    
fiROM.close()

rom_size_final = npROM_offset + npROM_index
#print (rom_size_final)

#for data in npROM:
#    print (hex(data))
```


```python
# 0x00 : Control signals
#        bit 0  - ap_start (Read/Write/COH)
#        bit 1  - ap_done (Read/COR)
#        bit 2  - ap_idle (Read)
#        bit 3  - ap_ready (Read)
#        bit 7  - auto_restart (Read/Write)
#        others - reserved
# 0x10 : Data signal of romcode
#        bit 31~0 - romcode[31:0] (Read/Write)
# 0x14 : Data signal of romcode
#        bit 31~0 - romcode[63:32] (Read/Write)
# 0x1c : Data signal of length_r
#        bit 31~0 - length_r[31:0] (Read/Write)

# Program physical address for the romcode base address
ipReadROMCODE.write(0x10, npROM.device_address)
ipReadROMCODE.write(0x14, 0)
# Program length of moving data
ipReadROMCODE.write(0x1C, rom_size_final)


# ipReadROMCODE start to move the data from rom_buffer to bram
ipReadROMCODE.write(0x00, 1) # IP Start
while (ipReadROMCODE.read(0x00) & 0x04) == 0x00: # wait for done
    continue
    
print("Write to bram done")

```

    Write to bram done



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))

```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0x8
    0x20 =  0x0
    0x34 =  0xfffffff7
    0x38 =  0x3f



```python
# Release Caravel reset
# 0x10 : Data signal of outpin_ctrl
#        bit 0  - outpin_ctrl[0] (Read/Write)
#        others - reserved
print (ipOUTPIN.read(0x10))
ipOUTPIN.write(0x10, 1)
print (ipOUTPIN.read(0x10))
```

    0
    1



```python
# Check MPRJ_IO input/out/en
# 0x10 : Data signal of ps_mprj_in
#        bit 31~0 - ps_mprj_in[31:0] (Read/Write)
# 0x14 : Data signal of ps_mprj_in
#        bit 5~0 - ps_mprj_in[37:32] (Read/Write)
#        others  - reserved
# 0x1c : Data signal of ps_mprj_out
#        bit 31~0 - ps_mprj_out[31:0] (Read)
# 0x20 : Data signal of ps_mprj_out
#        bit 5~0 - ps_mprj_out[37:32] (Read)
#        others  - reserved
# 0x34 : Data signal of ps_mprj_en
#        bit 31~0 - ps_mprj_en[31:0] (Read)
# 0x38 : Data signal of ps_mprj_en
#        bit 5~0 - ps_mprj_en[37:32] (Read)
#        others  - reserved

print ("0x10 = ", hex(ipPS.read(0x10)))
print ("0x14 = ", hex(ipPS.read(0x14)))
print ("0x1c = ", hex(ipPS.read(0x1c)))
print ("0x20 = ", hex(ipPS.read(0x20)))
print ("0x34 = ", hex(ipPS.read(0x34)))
print ("0x38 = ", hex(ipPS.read(0x38)))
```

    0x10 =  0x0
    0x14 =  0x0
    0x1c =  0xab510041
    0x20 =  0x0
    0x34 =  0x0
    0x38 =  0x3f

<!--
![螢幕擷取畫面 2023-11-22 231653](https://hackmd.io/_uploads/ryDuGoiNa.png)
![螢幕擷取畫面 2023-11-22 231723](https://hackmd.io/_uploads/H1vuMjiN6.png)
![螢幕擷取畫面 2023-11-22 231757](https://hackmd.io/_uploads/B1wdzso4a.png)
![螢幕擷取畫面 2023-11-22 231836](https://hackmd.io/_uploads/BkvOMis4a.png)
![螢幕擷取畫面 2023-11-22 231910](https://hackmd.io/_uploads/S1P_GjoVp.png)
![螢幕擷取畫面 2023-11-22 231931](https://hackmd.io/_uploads/SJPOGso4p.png)
-->

