---
title: CS301 Embedded System and Microcomputer Principle
tags: [Embedded System]
categories: CS
description: Review notes for Embedded System and Microcomputer Principle, in reverse order
date: 2024-12-31
---

## Outline

1. Introduction
2. STM32 MCU & GPIO
3. I²C and SPI
4. SD Card and File System
5. Bus
6. ADC
7. DMA and Pipeline
8. Arithmetic

## Lecture 14 Arithmetic

### Barrel Shifter

| Mnemonic | Name                   | Description      | Example(shift 4 bits)  |
| -------- | ---------------------- | ---------------- | ---------------------- |
| LSL      | Logical Shift Left     | C<-MSB, LSB<-0   | 11111111->11110000     |
| LSR      | Logical Shift Right    | 0->MSB, LSB->C   | 11111111->00001111     |
| ASR      | Arithmetic Shift Right | MSB->MSB, LSB->C | 10000000->11111000     |
| ROR      | Rotate Right           | LSB->MSB, LSB->C | 00001111->11110000     |
| RRX      | Rotate Extended        | C->MSB, LSB->C   | C,10000000->0,C1000000 |

The ARM barrel shifter is placed in the Datapath, so we can shift the second operand before it is used for arithmetic operations, like `MOV`, `ADD`, `ADC`, `SUB`, `RSB`, `AND`, `EOR`, `ORR`, `BIC`.

```assembly
ADD r4, r4, r4, LSL#4
# Multiply R4 by 17
RSB r5, r5, r5, LSL#5
# Multiply R5 by 31
```

### ALU Adder

#### Ripple Carry Adder

A cascaded connection of n full-adder blocks.

{{<raw>}}<center><img src="https://i.ytimg.com/vi/b70ZQwci5sY/maxresdefault.jpg" style="zoom:30%;" />

</center>{{</raw>}}Problem: each cell causes a propagation delay, $n$ delays for $n$-bit addition

#### Carry Lookahead Adder

{{<raw>}}<center><img src="https://i.ytimg.com/vi/SQKdnxysXnw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBu9U5xkcvn_fCgPIr_XVSNaQ0yMA" style="zoom:60%;" />

</center>{{</raw>}}

$G=A \text{ AND } B$

$P=A \text{ XOR } B$

$C_{i+1}=G_{i}+C_{i} \text{ AND } P_{i}$

$S_{i}=P_i\text{ XOR }C_i$

 The critical carry path now has 8 propagation delays for a 32 bit adder.

#### Carry Select Adder

Compute both the results with/without the carry, optimizing the propagation to  Log complexity.

| Width | Ripple | Lookahead | Select |
| :---: | :----: | :-------: | :----: |
|   4   |   4    |     1     |   1    |
|   8   |   8    |     2     |   1    |
|  16   |   16   |     4     |   2    |
|  32   |   32   |     8     |   3    |
|  64   |   64   |    16     |   4    |

### Multiplier

#### Matrix Multiplier

Carry-save adder: during addition, save the carry bits instead of propagating them, then add the carry with the sum.

Carry-save adders can be used on all addition but the final sum, which uses standard adder.

{{<raw>}}<center><img src="https://media.cheggcdn.com/study/401/401c23ee-fa2c-4a07-8ba9-1fcfd2259a75/Screenshot2024-04-30at9.41.02PM.png" style="zoom:50%;" />

</center>{{</raw>}}

#### Sequential Multiplier

- In each step, one bit of the multiplier is selected
- If the bit is logic 1, the multiplicand is shifted left to form a partial product, and it’s added to the partial sum

#### Booth Multiplier

Booth's algorithm

| Current bit | Bit to the right | Equiv Bit | Operation |
| :---------: | :--------------: | :-------: | :-------: |
|      0      |        0         |     0     |     0     |
|      0      |        1         |    +1     |    +M     |
|      1      |        0         |    -1     |    -M     |
|      1      |        1         |     0     |     0     |

Sometimes worse than normal

Booth2

| $Q_{i+1}Q_iQ_{i-1}$ | Equiv value at pos $i$ | Operation |
| :-----------------: | :--------------------: | :-------: |
|         000         |           0            |    +0     |
|         001         |           1            |    +M     |
|         010         |           1            |    +M     |
|         011         |           2            |    +2M    |
|         100         |           -2           |    -2M    |
|         101         |           -1           |    -M     |
|         110         |           -1           |    -M     |
|         111         |           0            |    +0     |

Multiplication requiring only n/2 summands.

## Lecture 13 DMA and Pipeline

### Direct Memory Access

**Why Need DMA?**

Data transfer between I/O device and memory w/o DMA (programmed I/Os):

- Each pure data transfer requires 2 cycles: load + store
- waste of CPU instructions: maintaining memory address and number bytes moved
- high overhead and slow

Transferring blocks of data between the external device and the main memory, or between memories, without continuous intervention by the processor.

DMAC: control unit for DMA transfer, a peripheral moving data.

**DMA transfer mode**

- Burst Mode
  - Entire block in one continuous operation
  - Efficient but CPU remains inactive for long
- Interleaving Mode
  - Transfer only when no conflict with CPU for system bus or memory access, ensuring no interference
- Cycle Stealing Mode
  - DMAC takes control, transfer one word of data, then releases control back to the CPU
  - Allows CPU to continue executing its instruction between transfers

Upon bus/memory access conflict, CPU is stalled, but may still executing instructions w/o cache miss.

**DMA Controller**

- **Memory address register (CMAR)**
  - contains the address to specify the desired location in memory
- **Peripheral register (CPAR)**
  - contains the address to specify the desired location in peripheral
- **Word count register (CNDTR)**
  - contains the number of words to be transferred
- **Configuration register (CCR)**
  - specifies the configurations like transfer mode

**DMA Operation**

- With CPU
  - CPU tells DMAC:
    - Data transfer direction between Mem and I/O
    - Starting address of memory block for data
    - Amount of data to be transferred
  - CPU carries on with other work
  - DMA controller deals with transfer (with peripheral↓)
  - DMA controller sends interrupt when finished
- With peripheral
  - When data available, I/O device places a signal on DMA-request wire
  - DMAC gets the memory bus
    - place the desired address on the memory-address wire
    - place a signal on the DMA-ACK wire
  - Transfer begins

DMA uses bus matrix to allow concurrent transfers.

| I/O Interrupt Transfer                 | DMA Transfer                        |
| -------------------------------------- | ----------------------------------- |
| Software control, needs context switch | Hardware control, no context switch |
| Slow transfer                          | Fast transfer                       |
| CPU involved                           | CPU not involved                    |
| No need for extra hardware             | Need DMAC                           |
| Can used for exception handling        | Data transfer only                  |
| Small data transfer                    | Large data transfer                 |

### Bit Banding

```text
bit_word_addr = bit_band_base + (byte_offset x 32) + (bit_number × 4)
```

### ARM Architecture - Pipeline

On a 32-bit memory system, ARM code is 40% faster than Thumb code.

- performance-centered

On a 16-bit memory system, Thumb code is 45% faster than ARM code.

- memory cost and power consumption

ARM code for the critical routines and Thumb code for backgrounds tasks

**ARM7 3-stage pipeline**

- Fetch
  - increment PC
  - read next instruction
- Decode
  - control signal generation
  - read from register file
- Execute
  - arithmetic/logic operation
  - calculation branch address
  - load/store

**Structure hazards**: different instructions in different stages conflicting for the same resource

**Control hazard**: fetch cannot continue because it does not know the outcome of an earlier branch

**Interrupt latency**:

- [interrupt signal received, the first instruction being executed]
- The minimum latency for an IRQ is 7 clock cycles

Split data buses for instructions and data to eliminate bus conflicts.

## Lecture 12 ADC

### ADC introduction

**ADC**: a circuit that takes in an analog voltage and produces a digital representation of its value.

Sampling rate: frequency of measuring the analog signal

Sampling resolution: depth of bits representing each sample

The ADC has $n$-bit resolution, $2^n$ steps, with step size $\frac{V_{ref}}{2^n}$.

$\text{Output} = \text{round}(2^N\times \frac{V_{input}}{V_{ref}})$.

### ADC Architectures

{{<raw>}}<center><img src="https://media.springernature.com/full/springer-static/image/chp%3A10.1007%2F978-3-030-60910-8_3/MediaObjects/106758_4_En_3_Fig14_HTML.png?as=webp" style="zoom: 33%;" /></center>{{</raw>}}

**Successive-approximation (SAR)**

SAR involves iteratively approximating the input analog voltage by comparing it with a series of binary-weighted voltage levels until a digital output is obtained.

Usually $n$ cycles for $n$-bit ADC.

**Flash ADC / Parallel ADC**

A series of comparators, each one comparing the input signal to a unique reference voltage. The comparator outputs connect to the inputs of a priority encoder circuit, which then produces a binary output.

| ADC Architecture | Resolution | Sampling Rate | Cost |
| :--------------: | :--------: | :-----------: | :--: |
|     SAR ADC      |    High    |      Low      | Low  |
|    Flash ADC     |    Low     |     High      | High |

### STM32 ADC

- regular group: SQ1-SQ16, 16 channels
- injected group: JSQ1-4, 4 channels
- injected group has a higher priority

**Modes**

- Single conversion mode
  - Sample one channel once
- Continuous conversion mode
  - Continuously sample one channel
- Scan mode
  - Sample multiple channels in specified order
- Discontinuous mode
  - Divide channels into groups, need to trigger before converting each group

**Sample time**

$T_\text{ADC}=T_\text{Sampling}+T_\text{Conversion}$

Sampling time is defined in `ADCx_SMPR` register (1.5-239.5 cycles).

Conversion time is 12.5 ADC clock cycles.

| SMP  | Sample time | SMP  | Sample time |
| :--: | :---------: | :--: | :---------: |
| 000  |     1.5     | 100  |    41.5     |
| 001  |     7.5     | 101  |    55.5     |
| 010  |    13.5     | 110  |    71.5     |
| 011  |    28.5     | 111  |    239.5    |

## Lecture 11 Bus

### Bus Architecture

Bus: a shared communication link between subsystems

- Each line or wire of a bus can at any one time contain a single binary digit.
- Time Division:
  - At any given moment, only one component is allowed to send information to the bus. Multiple components send information to the bus in different time slots.
- Shared:
  - Multiple components can be connected to the bus, and each component can exchange information through this set of lines.

**Bus Classification**

- Data transfer format

  - Serial

  - Parallel

- Connectivity

  - In-chip bus: connection between components within a CPU

  - System bus: links components like CPU, memory and I/O devices
    - Address bus (uni-directional)
      - CPU r/w data from memory/devices by addressing a unique location
    - Data bus (bi-directional)
      - data transfer
    - Control bus (bi-directional)
      - signal requests and ACKs
      - data type

  - Communication bus: connects external devices

- Timing control

  - Synchronous
  - Asynchronous

**Bus Architectures**

- Single level: System bus
  - Facilitates adding/removing I/O devices
  - Conflicts occur when multiple components need to use the bus
  - Priority needs to be determined
- Two level: Memory bus + I/O bus
  - IOP: a processor with specialized functions that can uniformly manage I/O devices. The channel program is stored in main memory.
  - Support burst transfer (see *burst transfer* in DMA transfer mode)
- Three level: Memory bus + I/O bus + DMA bus
  - memory centralize with DMA, data transfer between I/O devices and main memory does not require CPU intervention
- Multi-level
  - Allowing various components to connect efficiently while maintaining high performance and data integrity.

### Bus Performance

**Performance**

- width
  - number of bits  of data transmitted in the same time
- frequency
  - bus operating speed
- bandwidth = width × frequency
  - The amount of data transmitted on a bus within a specific time

### [Arbitration](https://www.geeksforgeeks.org/bus-arbitration-in-computer-organization/)

#### Centralized Arbitration

**Daisy Chain**

- All bus masters use the same line for bus request
- Bus grant signal is propagated serially through all masters starting from nearest one

**Counter Arbitration**

- An additional device line is used
- A counter enumerates all the masters through the device line

**Independent Request Arbitration**

- Each master has its own bus request and grant lines
- Bus is granted by bus controller based on the priority

#### Distributed Arbitration

- The arbiters are located within each device
  - The bus device arbiter sends its own arbitration number onto the shared bus.
  - The arbiter compares the arbitration number it receives from the bus with its own to determine priority.
  - If its own priority is lower, it withdraws its arbitration number
  - The highest-priority arbiter remaining on the bus gains control of the bus.

### Bus Timing

#### Bus cycle

1. Request
   - device sends request signal
   - arbitration if multiple devices contending for bus access
2. Addressing
   - master sends address and control signal to the bus
3. Transfer
   - data transmission
4. Complete
   - master removes relevant information from the bus and releases bus control

#### Bus Timing

**Synchronous**

controlled by a clock, support burst transfer

**Asynchronous**

handled by well-defined specifications, i.e., a response is delivered within a specified time after a request

**SOC Bus Architecture**

Advanced Microcontroller Bus Architecture (AMBA)

AMBA2.0->AHB->ARM Cortex-M

**AMBA2.0**

- IP reuse
- flexibility
- compatibility
- well supported

**Advanced High-performance Bus **(AHB)

- high performance
- CPU<->High-speed memory<->DMA controllers
- high bandwidth
- multiple master supported

**Advanced Peripheral Bus**

- low-power peripheral bus
- low-speed peripheral devices<-> system bus
- timers, GPIO controllers, UART etc.
- low-speed, low-power applications

## Lecture 10 SD Card & File System

### Massive Storage

**Static Random Access Memory (SRAM)**

- low density, high power, expensive, fast
- power off -> content loss
- often used for caches

**Dynamic Random Access Memory (DRAM)**

- high density, low power, cheap, slow
- need refreshing regularly
- used for main memory

**Disk Storage**

A sector records its ID and the data.

1. queue for other pending accesses
2. seek: move the heads
3. rotational latency
4. data transfer
5. controller overhead

**Volatile Memory**: SRAM, DRAM

**Non-Volatile Memory**: Disk, ROM, EPROM/Flash

Mask ROM

EPROM

EEPROM

Flash Memory

### Secure Digital Card

initialize, r/w, get status.

- SD mode
  - clock
  - 4 data lines
- SPI mode
  - clock
  - card select
  - 2 data lines

### File System

FAT 16 -> FAT 32 -> exFAT

block/cluster: set of sectors

FAT is designed to solve fragmentation

- chop the storage into equal sized blocks
- fill the empty space in a block-by-block manner

1. read root dir and get the 1st block number
2. read the FAT, find the next block
3. continuously find the next block until -1

| Format                | FAT12 | FAT16 | FAT32           |
| --------------------- | ----- | ----- | --------------- |
| Cluster address width | 12    | 16    | 28 (4 reserved) |
| Numbers of clusters   | 4K    | 64K   | 256M            |

**FAT read**

1. read from initial cluster
   - the file size may help determining if the last cluster is reached.
2. look for the next cluster
3. continue to access the next cluster until EOF
   - the file size help determining how many bytes to read from the last cluster.

**FAT write**

1. locate the last cluster
2. start writing to the non-full cluster
3. allocate the next cluster through FSINFO
4. Update the FATS and FSINFO
5. When write finishes, update the file size

**FAT delete**

1. de-allocate blocks involved. Update FSINFO and FATS
2. change the first byte of the directory entry to `_`

The storage device control module is storage dependent (e.g., SD card driver), it needs to be provided by the implementer.

## Lecture 10 I²C and SPI

### Inter-Integrated Circuit (I²C)

Designed for low-cost, medium data rate applications

- 2-wire communications
- Synchronous, half-duplex
- Start/Stop/Ack

**Characteristics**

- Serial, byte-oriented
- Multi-master bus with master and slave devices
  - Collision detection and arbitration
- 2 bidirectional open-drain lines, plus ground
  - Serial data line (SDA), Serial clock line (SCL)
  - Float high/Drive low
- Up to 100 kbit/s in the standard mode, up to 400 kbit/s in the fast mode

**Communication steps**

1. Master -> Slave: **START**
2. Master -> Slave: **address + direction**
3. Slave -> Master: **ACK**
4. Transmitter -> Receiver: **one-byte data**
5. Receiver -> Transmitter: **ACK**
6. Repeat 4 and 5 until transmission done
7. Master -> Slave: **STOP**

**Start/Stop Signals**

- START (S)
  - SDA 1->0 transition when SCL=1
- STOP (P)
  - SDA 0->1 transition when SCL=1
- Repeated Start (Sr)

**Data Frame**

- transmitter 8 bits + receiver 1 ack bit
- MSB transferred first

**Addressing Scheme**

- Master->Slave: slave address(7 bit) + write/read (1 bit)
- Slave->Master: ack (1 bit)

**Signal Synchronization**

- SCL=1, SDA remains stable
- SCL=0, transmitter sends a bit of data onto the data line

**Bus arbitration**

- *Wire-AND* bus is used: high voltage only when two senders both drive the line to high.
- For SCL (clock), keeping low if SCL of one of the masters is low
- SDA used for arbitration
  - During data transfer, the master constantly checks whether the SDA voltage level matches what it has sent. 
  - When two masters generate a START setting concurrently, the first master which detects SDA low while it has intended to set SDA high will lose the arbitration and let the other master complete the data transfer.

\*Extended details: the losing master will not send STOP to avoid interfering the winning slave, just leaves the losing slave receiving wrong messages and let the protocol to handle this.

### Serial Peripheral Interface (SPI)

Characteristics

- Synchronous full-duplex communication
- Single master, multiple slaves
- No Start/Stop or slave acknowledgment
- Master sets corresponding Slave Select (SS) signal to communicate with slave device
- More than 10 Mbit/s



- MSB transferred first (endian-programmable)
- Data line changed by the sender on a rising(falling) edge, then read by the receiver on the following falling(rising) edge.
- No ACK
- Clock provided by the master
- Master shifts out a bit to, and shifts in a bit from slave
- Only master can starts the data transfer
  - Ignore data received on writing
  - Send empty data to trigger the slave to send data

**SPI Clock Phase and Polarity**

**CPOL**: Clock Polarity

- Determines whether the clock line (SCLK) is idle low (0) or idle high (1).

**CPHA**: Clock Phase

- Determines whether data is sampled (read) on the first or second clock transition.

| **Mode** | **CPOL** | **CPHA** | **Idle Clock Level** | **Read Edge** | **Change Edge** |
| -------- | -------- | -------- | -------------------- | ------------- | --------------- |
| 0        | 0        | 0        | Low                  | Rising edge   | Falling edge    |
| 1        | 0        | 1        | Low                  | Falling edge  | Rising edge     |
| 2        | 1        | 0        | High                 | Falling edge  | Rising edge     |
| 3        | 1        | 1        | High                 | Rising edge   | Falling edge    |

### SPI vs. I²C

- Common
  - Serial, synchronous
  - Short-distance communications
  - Master-slave configuration
- Difference
  - SPI by Motorola, I²C by Philips
  - I²C is half-duplex, SPI is full-duplex
  - I²C w/ ACK, SPI w/o ACK
  - Addressing: broadcast vs. chip select
  - I²C fixes clock polarity and phase, SPI adjustable

## Lecture 8 Advanced Timer Functionality

**TIMx_DIER** (DMA/Interrupts Enable Register)

- UIE: Update Interrupt Enable
- CC1IE: Capture/Compare channel 1 Interrupt enable
- ...

### Output Compare PWM

{{<raw>}}<center><img src="https://s2.loli.net/2025/01/02/bFqdfHBoD7Mr32T.png" alt="image.png" style="zoom: 33%;" /></center>{{</raw>}}

| Output Compare Mode (OCnM) | Timer Output (OCREF) |
| -------------------------- | -------------------- |
| 000                        | Frozen               |
| 001                        | High if CNT==CCR     |
| 010                        | Low if CNT==CCR      |
| 011                        | Toggle if CNT==CCR   |
| 100                        | Constant low         |
| 101                        | Constant high        |
| 110                        | PWM mode 1           |
| 111                        | PWM mode 2           |

**Duty Cycle**

Percentage measuring fraction of period for which signal is HIGH

**Pulse Width Modulation (PWM)**

PWM (Pulse Width Modulation) is a technique to effectively obtain desired analog parameters by modulating the width of a series of pulses.

PWM mode 1: PWM signal = Counter < CCR ? 1 : 0

Duty cycle 1 = CCR / (ARR + 1)

PWM mode 2: PWM signal = Counter < CCR ? 0 : 1

Duty cycle 2 = 1 - (CCR / (ARR + 1))
$$
f_\text{CK_PWM}=\frac{f_\text{CK_PSC}}{(\text{PSC}+1)(\text{ARR}+1)}
$$

### Input Capture

1. The edge detector detects an external signal transition
2. Latch the counter value into `CCR` register
3. If enabled, generate an interrupt to inform the processor to read CCR

$$
\text{Time span} = (\text{CCR}_\text{new}-\text{CCR}_\text{old})\times \frac{1}{f_\text{CK_CNT}}
$$

### System Timer

24-bit down counter, used to initiate an action on a periodic basis

**SysTick registers**

- `SYSTICK_CTRL`
  - SysTick control and status register
  - COUNTFLAG: count done flag since last read, cleared upon read
  - CLKSOURCE: 0 for external reference clock; 1 for processor free running clock
  - TICKINT: 1 for enabling interrupt generation upon 1->0 transition
  - ENABLE: SYSTICK timer enable
- `SYSTICK_LOAD`
  - SysTick reload value register
  - Max = 0x00FFFFFF
  - $\text{Interval} = (\text{RELOAD} + 1)\times\text{Clock Period}$
- `SYSTICK_VAL`
  - SysTick current value register
  - Generates an interrupt on 1->0 transition, invoke `SysTick_Handler()`
  - Clearing the counter and COUNTFLAG

## Lecture 7 Timer Introduction

Software delay loops

- Waste of processor
- Difficult to translate into actual time
- Difficult to translate into number of iterations
- Unpredictable delays: compiler optimization, interrupts etc.

Stable clocks are essential for watchdog timers, timers, asynchronous communications etc.

STM32 clocks

- Quartz Crystal Oscillators
  - Accurate and stable
- RC/LC/RLC oscillators
  - Simple and cheap
- Phase-locked loop
  - increase external low-frequency clock to a higher-frequency internal clock

| Source | Frequency  |  Material  |  Usage   |
| :----: | :--------: | :--------: | :------: |
|  HSE   | 4 - 16 MHz | Oscillator |  SYSCLK  |
|  LSE   | 32.768 KHz | Oscillator |   RTC    |
|  HSI   |   8 MHz    |     RC     |  SYSCLK  |
|  LSI   |   40 KHz   |     RC     | RTC/IWDG |

**Timer Classification**

- Timers
  - Basic
  - General-purpose
  - Advanced
- SysTick
- Watchdogs
  - Independent (IWDG)
  - Windowed (WWDG)
- RTC

**STM32 Timers (16-bit)**

|      Type       |     Num      | Bus  |   Counting Mode   | Feature                                                      |
| :-------------: | :----------: | :--: | :---------------: | ------------------------------------------------------------ |
|      Basic      |  TIM6, TIM7  | APB1 |        Up         | Time-base generation (Timer)                                 |
| General-purpose | TIM2 to TIM5 | APB1 | Up, down, up/down | Time-base generation, Input capture (measuring input pulse lengths), Output compare (PWM waveform) |
|    Advanced     |  TIM1, TIM8  | APB2 | Up, down, up/down | Time-base generation, Input capture, Output compare, and more advanced features |

**Timer Registers**

- `TIMx_CNT`: Counter
- `TIMx_ARR`: Auto-reload register
- `TIMx_PSC`: Prescaler register

$$
f_\text{CK_CNT}=\frac{f_\text{CK_PSC}}{\text{TIMx_PSC}+1}
$$

- `TIMx_CR1`: Control register
  - CEN (Counter Enable)
    - 0: counter disabled
    - 1: counter enabled
  - OPM (One Pulse Mode)
    - 0: counter counts continuously
    - 1: counter stops at the next update event
  - CMS (CMS Center-aligned Mode Selection)
  - DIR (Direction)

|  CMS  | DIR  | Counting Mode        |
| :---: | :--: | -------------------- |
|  00   |  0   | Counting Up          |
|  00   |  1   | Counting Down        |
| Other | Any  | Counting Up and Down |

- `TIMx_SR`: Status register
  - bit 0: Update Interrupt Flag (UIF)
    - set by hardware upon an update event, cleared by software
    - set when `CNT` reaches `ARR` in counting up mode, or reaches 0 in counting down mode.

**Timer initialization**

1. enable the clock to TIMx module
2. set auto-reload register `TIMx_ARR`
3. clear the UIF flag in `TIMx_SR`
4. set the counting mode, enable timer
5. Wait the UIF flag to go high
6. Counting done

$$
T = \frac{(\text{TIMx_ARR}+1) \times (\text{TIMx_PSC}+1)}{f_\text{CK_PSC}}
$$



## Lecture 2 STM32 MCU & GPIO

### CPU Overview

**ARM Cortex Families**

- **A**pplication: support OS and high-performance applications (e.g. smartphones)
- **R**eal-time:  support real-time processing and mission-critical control, with high performance and high reliability
- **M**icrocontroller: cost-sensitive, support SoC

**Arithmetic Logic Unit**

- Operands: from registers and from data memory

- Operations: input from `OP` wire

- Flags: info about the results of operations stored in Program Status Register(i.e., PSR, or C(urrent)PSR)

  - **Z**ero

  - **N**egative

  - o**V**erflow

  - **C**arry

    ```text
    # PSR
    | Condition Code| Reserved |   Operating Mode   |
    | N | Z | C | V |..........|I|F|T|M4|M3|M2|M1|M0|
    ```

- Result: into registers or data memory

**Control Unit**: Instruction decoding \& dataflow identification

**Program Counter**: storing address of the next instruction to be executed, updated after fetching an instruction

### CPU Registers & Memory Map

**ARM CPU Registers**

- fastest way to read/write
- within the processor chip
- 32-bit wide each

ARM Cortex-M3 Register Bank

| Group                   | Number | Desc.                                              |
| ----------------------- | ------ | -------------------------------------------------- |
| Low Register            | R0-R7  | Accessible for any instructions                    |
| High Register           | R8-R12 | Accessible for some instructions                   |
| Stack Pointer           | R13    | Main/Process SP for priviledged/application access |
| Link Register           | R14    | Return address of function calls                   |
| Program Counter         | R15    | Address of the instruction to be executed          |
| Program Status Register | CPSR   | Flags of the ALU result                            |

## Lecture 1 Introduction

>*An embedded system is an application that contains at least one programmable computer.*
>
>—— Michael J. Pont, Embedded C

**Generations of Computers:**

| Generations                             | Technology          |
| --------------------------------------- | ------------------- |
| First Generation (1940s - 1950s)        | Vacuum tubes        |
| Second Generation (1950s - 1960s)       | Transistors         |
| Third Generation (1960s - 1970s)        | Integrated Circuits |
| Fourth/Now Generation (1970s - Present) | Microprocessors     |

**Transistor Evolution:**

- Scaling options
  - component-driven scaling (e.g., microprocessors, GPUs)
  - system-driven scaling (e.g., SoC integration).
- The focus on deeper pipelines, more cache, and multi-core systems, as well as memory chips with increasing capacity.

**Embedded Systems Overview:**

- **Microprocessor (MPU)**: A single-chip processor for data processing and control.
- **Microcontroller (MCU)**: A processor with integrated memory and peripherals for specific tasks, e.g., embedded applications.
- **System on a Chip (SoC)**: A chip that integrates all components of a system, including CPUs, GPUs, memory, and other peripherals.

**Differences Between General and Embedded Computer Systems:**

- **General Systems** include a microprocessor, large memory, and operating systems.
- **Embedded Systems** are tailored for specific functions, often without traditional operating systems and with embedded software in flash memory.

**Microcontroller Vendors**: Companies like STMicroelectronics, Microchip, TI, Intel, and NXP are prominent in this space.

**Development Tools and Environments**:

- **Development boards**: Used for testing software before hardware implementation.
- **IDE tools**: Cross compilers, linkers, loaders, and libraries help in developing embedded software.

For 32-bit processor like ARM, a **word** is 32 bit. (half-word, double-word)

| Power | Prefix | Symbol |
| :---: | :----: | :----: |
| 2^10  |  Kilo  |   K    |
| 2^20  |  Mega  |   M    |
| 2^30  |  Giga  |   G    |
| 2^40  |  Tera  |   T    |
| 2^50  |  Peta  |   P    |
| 2^60  |  Exa   |   E    |
| 2^70  | Zetta  |   Z    |

**Number System**

- Radix conversion
- Signed/one's complement/two's complement

Von-Neumann architecture vs. Harvard architecture

High-level language -> assembly language -> hardware representation



On general computer: compiler -> assembler -> linker -> loader

In cross compilation: cross-compiler + cross-assembler -> linker/locator

- Cross compiler runs on host but generates code for target.
- Locator creates a file containing binary image or other format, that will be copied onto target, which run on its own (not through loader)
