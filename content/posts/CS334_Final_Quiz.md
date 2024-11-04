---
title: CS334 Operating Systems Solutions to Final Quiz
tags: Operating System
categories: CS
description: Solution to final quiz of CS334 in 2023 Spring
date: 2023-05-23
---

## Q1. True or False

1. Aging is an effective solution to priority inversion
2. Dual-mode operation is supported by the CPU to protect the OS from applications
3. TLB works well because of spatial locality and temporal locality, where temporal locality means accesses to the same page tend to be close in time
4. Peterson's solution is an example of the spin-based locks
5. TLB entries can be extended with ASID to and TLB flushes during context switch
6. In Linux, kernel logic addresses are physically continuous; most kernel data structures, like page tables or per-process kernel stacks, are stored in kernel logic address
7. Memory-mapped I/O does not need spatial I/O instructions to operate the I/O ports and registers
8. SJF can be regarded as a dynamic priority scheduling where its priority is the next CPU burst time
9. A priority scheduling algorithm must be preemptive
10. Exit() is always invoked when the process terminates
11. seL4 is a formally verified micro kernel
12. A process switches from running to waiting state when it has used up its CPU quota and begin to wait until its next turn
13. Copy-on-write allows the parent process and the child process to share memory, so race condition may occur if they write to the same global variable concurrently
14. Peterson's solution can be extended to more than two processes with some modification
15. When CPU scheduling is considered, a process can be described as either I/O bound or memory bound
16. \*missing\*
17. \*missing\*
18. SJF scheduling algorithm is optimal with respect to the average turnaround time.
19. In Linux completely fair scheduler, a process with higher priority has higher decay factor for its virtual run time
20. Bounded waiting requires a process trying to enter the critical section will eventually get in if no process is currently in it
21. Page table pages cannot be swap out to the disk by the Linux kernel
22. IA-32 only supports 6 segments per process as it only has 6 segment registers
23. The inverted page table is used to translate physical address into virtual addresses
24. DMA controllers can steal memory access cycles from the main CPU
25. The memory management unit (MMU) is a software component of the operating system to translate logical addresses to physical addresses
26. When a user process accesses a virtual address, it is the operating system that converts the virtual address into a physical address
27. With paging, virtually continuous memory can be physically discontinuous
28. Both segmentation and paging schemes are used in IA-32
29. A round-robin scheduling algorithm is non-preemptive, because it does not preempt the running process when another process switches from waiting to ready
30. Re-parenting happens when the parent process terminates before the child process

**Answers：**

<details>FTTTT TTTFT TFFTF ??TFF TFFTF FTTFT</details>

## Q2. Short Answers

1. A solution to the critical section problem must satisfy \_\_\_\_\_\_, \_\_\_\_\_\_ and \_\_\_\_\_\_.

2. The SV39 mechanism (some introductions). What are the page size of a Gigapage, Megapage and page?

3. The limitations of the Base & Bounds scheme are \_\_\_\_\_\_, \_\_\_\_\_\_, \_\_\_\_\_\_.

4. What is TLB? When does uCore need to refresh TLB?

5. The limitations of the segmentation scheme are \_\_\_\_\_\_, \_\_\_\_\_\_, \_\_\_\_\_\_, \_\_\_\_\_\_.

6. What are the 3 privilege levels of RISC-V?

7. The 3 general methods used to pass system call parameters are \_\_\_\_\_\_, \_\_\_\_\_\_, \_\_\_\_\_\_.

8. Hard/Soft link in iNode-based file systems are different. When creating a hard/soft link, \_\_\_\_\_\_; when deleting a hard/soft link, \_\_\_\_\_\_.

9. The FAT32 file system stores file names into \_\_\_\_\_\_ and file attributes in \_\_\_\_\_\_, but ext2/3 file system stores file names in \_\_\_\_\_\_ and file attributes in \_\_\_\_\_\_.

10. What are the 3 thread models for mapping user-level thread to kernel-level thread?

11. The memory contents are shown as follows, what is the value of an integer at address 0x20 if the CPU is little endian(in hexadecimal)? 

    ![image.png](https://s2.loli.net/2023/05/23/rkZK17cR3QGM8ne.png)

12. \_\_\_\_\_\_ is the phenomenon in which increasing the number of page frames results in an increase in the number of page faults for certain memory access patterns. This phenomenon is commonly experienced when using the \_\_\_\_\_\_ page replacement algorithm.


**Answers**:

<details>
    <p>1. Mutual exclusion, progress, bounded waiting</p>
    <p>2. 2^30 Bytes, 2^21 Bytes, 2^12 Bytes</p>
    <p>3. Internal fragmentation, Connot support larger address space, Hard to do inter-process sharing</p>
    <p>4. CPU hardware cache to store PTEs that have been mostly reccently used, to spend up virtual address translation; When chaging page tables or updating page table contents.</p>
    <p>5. OS content switch must also saave and restire all pairs sof segment registers; A segment may grow, which may or may not be possible; Management of free spaces of physical memory with variable-sized segments; External fragmentation</p>
    <p>6. User, Supervisor, Machine</p>
    <p>7. Register, Block, Stack</p>
    <p>8. A hard link is a directory entry pointing to the iNode of an existing file; A symbolic link creates a new iNode, with the path to the target file in its data block; Deleting the target file does not affect the hard link, but deleting the target file makes the soft link invalid.</p>
    <p>9. FAT32 stores file names and attributes in the directory entries; ext2/3 file system stores the file name in the directry entries, and the file attributes in the iNode.</p>
    <p>10. one-to-one, Many-to-one, Many-to-many mapping</p>
    <p>11. 0x dd 42 34 e7</p>
    <p>12. Bélady's Anomalty, FIFO</p>
</details>

## Q3. Questions and Answers

1. On some CPU architecture, the page size is 16B, each page table entry is 4B, the virtual address has 8 bits.

   (1) What is the size of the virtual space?

   (2) If each level of page table fits into one page, how many levels of page tables are needed?

   (3) If the relevant last-level page table is shown as below, what is the physical address of 0x64?

   (4) If the CPU architecture changes to support page size of 32B, everything else remains unchanged. With the following page table, what is the physical address of 0x64?

   Extra: The physical address of the virtual address 0x364 is 0x1164. What is the corresponding PFN(in decimal numbers)?

   ![image.png](https://s2.loli.net/2023/05/23/akqROWXvn49rxZe.png)

   **Answers**:

   <details>
       <p>(1) 256 Bytes</p>
       <p>(2) 2 levels</p>
       <p>(3) 0x3e4</p>
       <p>(4) 0xc8</p>
   </details>

2. Suppose we have 3 page frames(1, 2, 3), 4 virtual pages(A, B, C, D), consider the following reference string: A B C A D B A C B C. What are the number of page faults for the following page replacement policies? Show each step in the tables.

   (1) MIN

   (2) LRU

   (3) FIFO

   (4) Clock (hint: only second page reference set reference bit)

   ![image.png](https://s2.loli.net/2023/05/23/rEflwc6y9Ovp2eP.png)

   **Answers**:

   <details>
       <table>
       <tr>
           <td></td>
           <td>A</td>
           <td>B</td>
           <td>C</td>
           <td>A</td>
           <td>D</td>
           <td>B</td>
           <td>A</td>
           <td>C</td>
           <td>B</td>
           <td>C</td>
       </tr>
       <tr>
           <td>1</td>
           <td>A</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>2</td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>3</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td>D</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
   </table>
   <table>
       <tr>
           <td></td>
           <td>A</td>
           <td>B</td>
           <td>C</td>
           <td>A</td>
           <td>D</td>
           <td>B</td>
           <td>A</td>
           <td>C</td>
           <td>B</td>
           <td>C</td>
       </tr>
       <tr>
           <td>1</td>
           <td>A</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>2</td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td>D</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>3</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
   </table>
   <table>
       <tr>
           <td></td>
           <td>A</td>
           <td>B</td>
           <td>C</td>
           <td>A</td>
           <td>D</td>
           <td>B</td>
           <td>A</td>
           <td>C</td>
           <td>B</td>
           <td>C</td>
       </tr>
       <tr>
           <td>1</td>
           <td>A</td>
           <td></td>
           <td></td>
           <td></td>
           <td>D</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>2</td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td>A</td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>3</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td>B</td>
           <td></td>
       </tr>
   </table>
   <table>
       <tr>
           <td></td>
           <td>A</td>
           <td>B</td>
           <td>C</td>
           <td>A</td>
           <td>D</td>
           <td>B</td>
           <td>A</td>
           <td>C</td>
           <td>B</td>
           <td>C</td>
       </tr>
       <tr>
           <td>1</td>
           <td>A</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>2</td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td>D</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
       </tr>
       <tr>
           <td>3</td>
           <td></td>
           <td></td>
           <td>C</td>
           <td></td>
           <td></td>
           <td>B</td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
       </tr>
   </table>
   </details>

3. In a computer system that supports demand-paging, the memory access time is 50 ns, the average page fault service time is 5 ms. The page fault rate $p$ is 1/5000. What is the Effective Access Time?

   **Answer**:

   <details>
       <p>1.05 μs</p>
   </details>

4. Consider a set of 4 processes, with their arrival time and CPU burst time shown in the table. What is the average turnaround time with the following CPU scheduling algorithm?

   (1) Non-preemptive SJF

   (2) Preemptive SJF

   (3) Round-robin with a scheduling quantum of 2(let's assume here if two process arrive at the ready queue at the same time, the one with running-ready state transition is placed at the end of the queue).

   **Answers:**

   <details>
   <table>
       <p>(1) (6 + 11 + 5 + 5) / 4 = 6.75</p>
       <tr>
           <td>1</td>
           <td>2</td>
           <td>3</td>
           <td>4</td>
           <td>5</td>
           <td>6</td>
           <td>7</td>
           <td>8</td>
           <td>9</td>
           <td>10</td>
           <td>11</td>
           <td>12</td>
       </tr>
       <tr>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P3</td>
           <td>P4</td>
           <td>P4</td>
           <td>P2</td>
           <td>P2</td>
           <td>P2</td>
       </tr>
   </table>
   <p>(2) (12 + 4 + 1 + 3) / 4 = 5</p>
   <table>
       <tr>
           <td>1</td>
           <td>2</td>
           <td>3</td>
           <td>4</td>
           <td>5</td>
           <td>6</td>
           <td>7</td>
           <td>8</td>
           <td>9</td>
           <td>10</td>
           <td>11</td>
           <td>12</td>
       </tr>
       <tr>
           <td>P1</td>
           <td>P2</td>
           <td>P3</td>
           <td>P2</td>
           <td>P2</td>
           <td>P4</td>
           <td>P4</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
           <td>P1</td>
       </tr>
   </table>
   <p>(3) (12 + 9 + 3 + 5) / 4 = 7.25</p>
   <table>
       <tr>
           <td>1</td>
           <td>2</td>
           <td>3</td>
           <td>4</td>
           <td>5</td>
           <td>6</td>
           <td>7</td>
           <td>8</td>
           <td>9</td>
           <td>10</td>
           <td>11</td>
           <td>12</td>
       </tr>
       <tr>
           <td>P1</td>
           <td>P1</td>
           <td>P2</td>
           <td>P2</td>
           <td>P3</td>
           <td>P1</td>
           <td>P1</td>
           <td>P4</td>
           <td>P4</td>
           <td>P2</td>
           <td>P1</td>
           <td>P1</td>
       </tr>
   </table>
   </details>

5. In a disk scheduling algorithm, the range of the cylinders is 0\~99. The arm head is originally located at track 50. The queue of requests is 25, 98, 52, 67, 42, 8. What is head movement distance, considering the following disk scheduling algorithms? Hint: for SCAN/C-SCAN/LOOK/C_LOOK, the arm head moves towards 99 first; for C-LOOK/C-SCAN, both directions count towards movement distance.

   (1) SSTF

   (2) C-LOOK

   (3) SCAN

   (4) FIFO

   **Answers:**

   <details>
       <p>(1) 136</p>
       <p>(2) 172</p>
       <p>(3) 142</p>
       <p>(4) 218</p>
   </details>

6. A Turing Class student designed an iNode-based file system, called TCFS. The structure of an iNode in Site FS has 256 bytes, with 10 direct block pointers, 2 single indirect block pointers, and 1 double indirect block pointer. A block pointer takes 8 bytes. The block size is 8 KB.

   (1) What is the maximum size of a file in TCFS?

   (2) What is the maximum size of a file system with TCFS format?

   **Answers:**

   <details>
       <p>10*8KB + 2*(8K/8)*8KB + (8K/8)*(8K/8)*8KB = 8GB</p>
       <p> 2 ^ 64 * 8K = 2 ^ 77</p>
   </details>
