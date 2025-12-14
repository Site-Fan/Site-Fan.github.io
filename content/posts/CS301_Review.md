---
title: CS301 Embedded System and Microcomputer Principle Review
tags: [Embedded System]
categories: CS
description: Review notes for Embedded System and Microcomputer Principle, in reverse order
date: 2024-12-31
---

## Outline

1. Introduction
2. STM32 MCU & GPIO
3. C for Embedded System
4. ARM Assembly
5. Interrupt
6. UART
7. Timer Introduction
8. Advanced Timer Functionality
9. I²C and SPI
10. SD Card and File System
11. Bus
12. ADC
13. DMA and Pipeline
14. Arithmetic

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

<center><img src="https://i.ytimg.com/vi/b70ZQwci5sY/maxresdefault.jpg" style="zoom:30%;" />

</center>Problem: each cell causes a propagation delay, $n$ delays for $n$-bit addition

#### Carry Lookahead Adder

<center><img src="https://i.ytimg.com/vi/SQKdnxysXnw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBu9U5xkcvn_fCgPIr_XVSNaQ0yMA" style="zoom:60%;" />

</center>

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

<center><img src="https://media.cheggcdn.com/study/401/401c23ee-fa2c-4a07-8ba9-1fcfd2259a75/Screenshot2024-04-30at9.41.02PM.png" style="zoom:50%;" />

</center>

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

<center><img src="https://media.springernature.com/full/springer-static/image/chp%3A10.1007%2F978-3-030-60910-8_3/MediaObjects/106758_4_En_3_Fig14_HTML.png?as=webp" style="zoom: 33%;" /></center>

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

**Advanced High-performance Bus** (AHB)

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

<center><img src="https://s2.loli.net/2025/01/02/bFqdfHBoD7Mr32T.png" alt="image.png" style="zoom: 33%;" /></center>

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

## Lecture 6 Serial Communication - UART

### UART Protocol

Communication Classification

- Serial
  - Low rate, high anti-interference ability, long distance, low I/O usage, cheap
- Parallel
  - High rate, low anti-interference ability, short distance, high I/O usage, expensive
- Synchronous
  - Master-slave 
  - Shares the same clock signal sent with data
- Asynchronous
  - Fewer wires, w/o clock signal
  - relies on synchronous signals like stop/stop bits within the data signal
- Simplex
  - unidirectional
- Half-duplex
  - bidirectional but time-division
- Full-duplex
  - bidirectional at any time

Universal Asynchronous Receiver-Transmitter(UART)

- Serial, asynchronous, full-duplex
- Start (1-bit) + Data  (8-bit) + Parity (0-1 bit) + Stop (1 bit)
- Start: 0, Stop: 1, LSB of the data transferred first.

**Baud Rate**

In UART, Baud rate = bits per second

data rate = Baud rate \* 8/(1+8+(0/1)+1)

Start, Stop, Parity are the protocol overhead

### UART in Practice

**Synchronization**

Different clocks of transmitter and receiver may have different phases.

Assuming the receiver samples in the middle of its cycle. W/o the parity bit, the final sample is taken 9.5 periods after the initial falling edge and must lie within the stop bit.

The overall permissible error is therefore about ±0.5 bit period in 9.5 period or (about) ±5%. Both transmitter and receiver may have errors, therefore about ±2.5% for both the transmitter and the receiver.

**Bit-level Reorganization**

After the cable propagation, the signal may be interfered and has glitches.

Solution: *oversampling*

- receiver sampling clock 16x faster than the Baud rate
- 3 out of 16 are picked for voting
- 2:1 determines the bit level
- 1:1:1 sets the noise flag

**Error detection**: data + parity bit for 1-bit error

UART, as a communication mechanism, defines only the timing sequence, but does not specify the electrical characteristics of the interface.

*RS-232* and *RS-485* defines the electrical and mechanical characteristics of the interface for serial communication.

### USART in STM32

Universal Synchronous/Asynchronous Receiver-Transmitter

- generate data frame timing based on a byte of data
- send through TX, receive data frame timing from RX
- built-in Baud rate generator
- configurable data length, stop length and optional parity bit

| Register Name |    Offset     | Description          |
| :-----------: | :-----------: | -------------------- |
|   USARTx_SR   |    0x0000     | Status register      |
|   USARTx_DR   |    0x0004     | Data register        |
|  USARTx_BRR   |    0x0008     | Baud rate register   |
| USARTx_CR1-3  | 0x000C-0x0014 | Control register 1-3 |

`USART_BRR`

- [15:4] DIV_Mantissa
- [3:0] DIV_Fraction

$$
\text{baud} = \frac{f_\text{PCLK}}{16\times \text{USARTDIV}}\\
\text{USARTDIV}=\text{DIV_Mantissa} + \text{DIV_Fraction/16}
$$

\* Note that when calculating `DIV_Fraction`, ceiling rounding is used. Handle carefully about the carry of $16\times \text{Fraction}$ into the Mantissa part.

## Lecture 5 Interrupt

### Subroutine

Conditional branch: B (BL, BX when calling subroutine)

Unconditional branch: BCS, BEQ, BGE etc.

**Subroutine**

1. Branch and link (BL): call a subroutine, save the return address (address of the instruction after BL) in the link register (LR)
2. Branch with exchange (BX): branch to the address specified in a register. The processor copies LR to PC after the program is finished.

**Stack**

- FILO
- Used for nested branch and link
- Cortex-M uses full descending stack:
  - Bottom address fixed
  - SP points to the stack top item
  - Grows towards lower address: decrement on push, increment on pop
- STMFD/LDMFD: store/load multiple full descending
- store: decrement SP, store; load: load, increment SP
- Largest-numbered register pushed first, popped last

### Interrupt

Polling

- Periodic/continuous checking of external events
- CPU processing time consuming
- Combined with other functional code
- Events might be missed

Interrupt

- Hardware-based event detection
- A dedicated Interrupt Service Routine (ISR) is used to handle the event

1. Finish the current instruction
2. Save return address and register context to stack
3. Invoke ISR
4. Restore return address and register context from stack
5. Resume main program

Hardware automatically pushes and pops 8 registers onto/from the stack: `xPSP`, `PC`, `LR`, `r12`, `r3`, `r2`, `r1`, `r0`.

**Interrupt Service Routines**

- Each interrupt has an ISR

- Invoked by hardware at unpredictable time, not by the control of the program's logic
- An Interrupt Vector Table stored in memory contains fixed, pre-defined addresses of the ISRs.

**Types of Interrupts**

- Interrupts from peripheral modules
- External pin interrupts (IRQ0-IRQ15)
- Software interrupts
- Non Maskable Interrupts

Interrupts are managed by nested vectored interrupt controller (NVIC).

NVIC receives interrupts requests from various sources

- `AIRCR`: set priority group
- `IPRx`: set priority value (priority of Reset, HardFault and NMI fixed, others adjustable)
- `ISER/ICER`: enable/disable interrupts

**Interrupt Priority**

The smaller, the higher. Reset has the highest priority.

preempt priority > sub-priority > natural priority

| Priority Group | AIRCR[10:8] | IPRx[7:4]         | Result                     |
| -------------- | ----------- | ----------------- | -------------------------- |
| 0              | 111         | / : [7 : 4]       | 0 preempt, 4 sub           |
| 1              | 110         | [7] : [6 : 4]     | 1 preempt, 3 sub           |
| 2              | 101         | [7 : 6] : [5 : 4] | 2 preempt, 2 sub (default) |
| 3              | 100         | [7 : 5] : [4]     | 3 preempt, 1 sub           |
| 4              | 011         | [7 : 4] : /       | 4 preempt, 0 sub           |

```c
IPRn:
 31        27       23        19       15        11       7       3      0
|IRQ(4n+3)|Reserved|IRQ(4n+2)|Reserved|IRQ(4n+1)|Reserved|IRQ(4n)|Reserved|
```

| Subroutine                                         | Interrupt                             |
| -------------------------------------------------- | ------------------------------------- |
| Jumps to any destination                           | Jumps to a fixed location             |
| BL used by the program in the instruction sequence | Hardware interrupt occurs at any time |
| Cannot be masked                                   | Can be masked(disabled)               |
| Saves only LR                                      | Saves 8 registers                     |
| CPU mode unchanged                                 | CPU goes to Handler mode              |
| On return, restores LR to PC                       | On return restores 8 registers        |

## Lecture 4 ARM Assembly

Mnemonic -> Machine Code -> In-memory instructions

````text
label	opcode	operand1	operand2	operand3	; comments
````

- Arithmetic and logic
- Data movement
- Compare and branch

### Arithmetic

- ADD
- SUB
- RSB (reversed sub)
- MUL (result \& 0xFFFFFFFF)

**Condition Flags**

- Negative

  N = 1 if MSB = 1

- Zero

  Z = 1 if all bits of result are 0

- Carry

  - Unsigned addition: C = 1 if carry
  - Unsigned subtraction: C = 0 if borrow
  - Shift/Rotate: C = last bit shifted out

- Overflow

  V = 1 if P + P = N or N + N = P in signed arithmetic operations

Most instructions update NZCV flags only if `S` suffix is present.

Some instructions without a destination register like `CMP`, update NZCV flags even if no `S` specified.

### Logic

- AND
- ORR
- EOR
- BIC
- LSL
- LSR
- ROR

### Data Transfer

- MOV
- MVN
- LDR
- STR

**Endianness**: Cortex-M uses little endian by default, but adjustable.

### Branch and Compare

- CMP
- BNE
- BEQ
- BGT, BGE, BLT, BLE
- BHI, BHS, BLO, BLS

### Addressing Mode

- Register addressing
  - MOV R0, R1
- Immediate addressing
  - Mov R0, #0x42
  - Immediate value <= 0x0FFF (12-bit)
  - immediate = imm\_8 ROR (2 * rotate_imm)
- Indirect addressing
  - No-update: LDR r6, [r11, #12]
  - Pre-index: LDR r6, [r11, #12]!
  - Post-index: LDR r6, [r11], #12
- Register addressing
  - STR R0, [R1]

| Complex Instruction Set Computer                             | Reduced Instruction Set Computer                             |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Complicated CPU                                              | Simple CPU                                                   |
| Slower instruction execution                                 | Faster instruction execution                                 |
| Fewer machine code instructions for each high-level instruction | More machine code instructions for each high-level instruction |
| Good code density                                            | Poor code density                                            |
| Smaller semantic gap                                         | Larger semantic gap                                          |
| Simple compiler                                              | Complicated compiler                                         |

## Lecture 3 C for Embedded System

`switch` is better than `if-else` if the number of branches is large.

Function vs. Macro: compare $T_\text{overhead}$ and $T_\text{execute}$

**Storage class in C**

- `auto`
  - Default storage class for variables declared inside a function
  - Accessible only within the function's scope
- `register`
  - Suggests storing variables in CPU registers
  - Same accessibility as auto, allocation depends on the compiler 
- `static`
  - Lifetime throughout the program's duration
  - Accessibility depends on declaration context
  - Static variables inside functions are initialized only once
- `extern`
  - Makes variables accessible across multiple functions and files.
  - Can be modified by any function within its scope.

Volatile: variable value may change outside the normal program flow

In practice: auto > global, stack > heap

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

**Memory Map**: STM32 maps its memory into 8 blocks of 512 MB

```
0xFFFFFFFF
	Vendor-sprcific, Private peripheral bus - External/Internal
0xE0000000
	External device (1.0 GB)
0XA0000000
	External RAM (1.0 GB)
0X60000000
	Peripheral (0.5 GB)
0X40000000
	SRAM (0.5 GB)
0X20000000
	Code (0.5 GB)
0X00000000
```

**Memory Mapped IO**

- A technique where both memory and I/O devices use the same address space
- The CPU treats I/O devices like computer memory and communicates with either computer memory or I/O devices.

### GPIO

GPIO (General Purpose Input Output) pins are commonly used pins that can control the voltage levels (high or low) and can be read from or written to.

Processor accesses peripheral registers via **memory mapped I/O**

```
GPIO Port A: 0x4001 0400 - 0x4001 07FF
GPIO Port B: 0x4001 0800 - 0x4001 0BFF
...
GPIO Port G: 0x4001 2000 - 0x4001 23FF
```

Each port has seven I/O registers associated with it, each register has a specific memory address, Register Mapping assigned a name to each register address.

```
GPIOA_LCKR	0x4001 0818
GPIOA_BRR	0x4001 0814
GPIOA_BSRR	0x4001 0810
GPIOA_ODR	0x4001 080C
GPIOA_IDR	0x4001 0808
GPIOA_CRH	0x4001 0804
GPIOA_CRL	0x4001 0800
```

**GPIO Mode**

| GPIO Mode                                | Usage                                                        |
| ---------------------------------------- | ------------------------------------------------------------ |
| **Floating input (reset state)**         | Completely floating, and the state is undefined              |
| **Input with pull-up**                   | With internal pull-up, defaults to high level (button)       |
| **Input with pull-down**                 | With internal pull-down, defaults to low level               |
| **Analog mode**                          | ADC, DAC                                                     |
| **General purpose output Open-drain**    | Software I2C, SDA, SCL, etc                                  |
| **General purpose output push-pull**     | Strong driving capability, general-purpose output (LED)      |
| **Alternate function output Open-drain** | On-chip peripheral functions (hardware I2C, SDA, SCL pins, etc) |
| **Alternate function output Push-pull**  | On-chip peripheral functions (SPI, SCK, MISO, MOSI pins, etc) |

**GPIO Output Speed**

- Speed of rising and falling
- Low, medium, fast, high
- High GPIO speed increase EMI noise and power consumption
- High for SPI, low for LED toggling

**GPIO Programming**

1. Enable the corresponding GPIO clock

   RCC->APB2ENR (GPIO is on APB2 bus)

2. Configure the GPIO mode

   Setting CRL/CRH to configure input/output mode

3. Set the input/output status

   - Set ODR to configure pull-up/pull-down input, reading from IDR to get input status
   - Set ODR to configure output status

**CRL and CRH**(configuration registers)

<center><img src="https://s2.loli.net/2025/01/02/CURqFrZ2eyD7GIS.png" alt="image.png" style="zoom:50%;" /></center>

Each GPIO pin is configured using 4 bits in CRL/CRH: `CNFx` an `MODEx`

Input:

- MODEx=0b00

  | CNFx | Configuration                | Description                              |
  | ---- | ---------------------------- | ---------------------------------------- |
  | 00   | Analog                       | Select the pin as an ADC input           |
  | 01   | Floating input               | High impedance                           |
  | 10   | Input with pull-up/pull-down | `ODR` 0 for pull-down, otherwise pull-up |
  | 11   | reserved                     | /                                        |

Output

- Modex>0b00, 10MHz, 2MHz, 50MHz

  | CNFx | Configuration                        |
  | ---- | ------------------------------------ |
  | 00   | General purpose output push-pull     |
  | 01   | General purpose output open-drain    |
  | 10   | Alternate function output push-pull  |
  | 11   | Alternate function output open-drain |

Higher 16 bits  of IDR/ODR reserved, each GPIO pin is configured using 1 bit.

Setting the IDR/ODR to high/low, or pull-up/pull-down?

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
