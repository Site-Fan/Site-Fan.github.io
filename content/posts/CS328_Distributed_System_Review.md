---
title: CS328 Distributed Systems and Cloud Computing Review
tags: [Distributed System]
categories: CS
description: Review Notes for Distributed Systems and Cloud Computing
date: 2025-01-01
---

## Outline

### Lectures

1. Characterisation of Distributed Systems
1. System Models
1. Inter-process Communication
1. Distributed Objects and Remote Invocation
1. Indirect Communication
1. Operating System Support
1. Time
1. Coordination and Agreement
1. Cloud Computing

### Labs

1. MPI
2. RPC
3. RESTful API
4. Proxy
5. HDFS, YARN and Spark
6. Kubernetes
7. Cloud Computing

## Lectures

### Lecture01 Characterisation of Distributed Systems

Scaling dimensions

- **scale-down**: maximize feature density
- **scale-up**:  maximize device capacity
- **scale-out**: maximize system capacity
- **scale-in**: maximize system density, minimize end-to-end latency

What is a distributed system?

- A distributed system consists of components located in networked computers that communicate and coordinate their actions by passing messages. The primary motivation behind these systems is resource sharing.

What is a Computer Network?

- A collection of interconnected autonomous computers
- Generality: Built from general purpose hardware, not optimized for any particular application or data type

Computer Network vs. Distributed System

- Distributed system is a software system running on top of the computer network.
- Distributed systems provide transparency, where resources (like storage, processing power, etc.) are accessed without knowledge of their location, promoting seamless access and usage across different nodes in the system.

OSI Layers

- Session Layer

  Manages sessions and controls dialogues (dialogue synchronization and activities) between systems.

- Presentation Layer

  Ensure that the information being transmitted is understood by the receiving system, regardless of the specific data formats used by the sender.

- Application Layer

  The layer closest to the end-user. It provides services that directly support user applications.

Challenges in Distributed Systems

- **Heterogeneity**: Handling different types of systems and protocols.
- **Openness and Security**: Issues like denial-of-service attacks and security of mobile code.
- **Scalability**: cost, performance loss, availability, bottlenecks as systems scale up
- **Failure Management**: detect, tolerate, and recover from failures without affecting user tasks.
- **Concurrency and Consistency**: Managing multiple operations concurrently without interference, ensuring data consistency.
- **Transparency**
  - **Access Transparency**: Enables identical operations for local and remote resources.
  - **Location Transparency**: Hides the physical or network location of resources.
  - **Concurrency Transparency**: Allows multiple processes to share resources without interference.
  - **Replication Transparency**: Hides multiple resource replicas for improved performance and reliability.
  - **Failure Transparency**: Conceals faults, allowing tasks to continue despite hardware/software failures.
  - **Mobility Transparency**: Supports movement of resources/clients without affecting user operations.
  - **Performance Transparency**: Enables system reconfiguration to optimize performance under varying loads.
  - **Scaling Transparency**: Allows system scaling without changing the structure or algorithms.

### Lecture02 System Models

**Presentation Layer (P Layer)**

- The primary function of the P Layer is to **facilitate interaction** between the system and its users, whether they are human beings or other software systems.
- It acts as an **interface** for users to interact with the system.

- Users submit operations and get responses through the P Layer.
- The boundary between the P Layer and the client (the user's device or software) can be very thin, e.g., Java Applet.

**Application Logic Layer (ALL)**

- The ALL, a.k.a. **Business Process** or **Business Logic**, is responsible for the **data processing** required before delivering the final result to the user.
- It implements the specific **information** requested by the client of the P Layer.

- The ALL encompasses all the programs and modules involved in processing the operations.

**Single Tier Architecture**

- Old-fashioned
- Presentation, Application Logic and Data reside within a single component

**Two Tier Architecture**

- Client-Server model, the idea of API and RPC
- Presentation layer resides on the client (PC)
- Application Logic and Data layers reside on the server
- Fat Client vs. Thin Client: heavy/light client-side processing

**Three Tier Architecture**

- Presentation layer on the client
- Application Logic layer on a separate server
- Data layer on a dedicated database server, connected with Application Logic layer via the middleware, with better interfaces like JDBC
- Middleware: infrastructure that supports the development of ALL
  - Sun RPC, Java RMI, SOAP, CORBA, JMS

**N Tier Architecture**

- Multiple distributed systems interact with each other
- ***Tier*** can refer to both logical (functional separation) and physical (hardware location) separation.

**System Architectures**

- Client-server model
  - client object invokes a method upon a server object
- Multiple servers
  - replication for performance and fault tolerance
- Proxy server
  - a shared cache of web resources for the client machine at a site or across sites
  - access remote web servers via proxy servers
- Cache
  - a store of recently used data objects that is closer than the objects themselves
- Peer processes
  - Processes play similar roles and cooperate to perform a distributed activity
  - Reduce server bottlenecks, but introduce consistency and synchronization issues
- Variations
  - Applets: a small piece of Java code embedded in HTML running on client-side browser
  - Thin client: a minimal client-side machine, upload user input,  show response from servers

Metrics over distributed system architectures

- Performance
  - Responsiveness
    - fast response
    - caching, replication
  - Throughput
    - server speed + data transfer speed
  - Load balancing
    - applets, multi-server etc.
- Quality of Service
  - Deadline properties
    - hard deadline: deterministic deadline
    - soft deadline: 90% of task completion time
  - Adaptability
    - ability to adapt to changing system configuration
- Dependability
  - Correctness
  - Fault-tolerance and recovery
  - Security

**Omission and Arbitrary Failures**

| **Class of Failure**      | **Affects**     | **Description**                                              |
| ------------------------- | --------------- | ------------------------------------------------------------ |
| **Fail-stop**             | Process         | Process halts and remains halted. Other processes may detect this state. |
| **Crash**                 | Process         | Process halts and remains halted. Other processes may not be able to detect this state. |
| **Omission**              | Channel         | A message inserted in an outgoing message buffer never arrives at the other end’s incoming message buffer. |
| **Send-omission**         | Process         | A process completes a send, but the message is not put in its outgoing message buffer. |
| **Receive-omission**      | Process         | A message is put in a process’s incoming message buffer, but that process does not receive it. |
| **Arbitrary (Byzantine)** | Process/Channel | Process or channel exhibits arbitrary behavior: it may send/transmit arbitrary messages at arbitrary times, commit omissions; a process may stop or take an incorrect step. |

**Timing Failures**

| **Class of Failure**      | **Affects** | **Description**                                              |
| ------------------------- | ----------- | ------------------------------------------------------------ |
| **Clock**                 | Process     | Process’s local clock exceeds the bounds on its rate of drift from real time. |
| **Performance (Process)** | Process     | Process exceeds the bounds on the interval between two steps. |
| **Performance (Channel)** | Channel     | A message’s transmission takes longer than the stated bound. |

### Lecture03 Inter-process Communication

**Network Architecture**: framework for designing and implementing Networks

**Components**

- Software
  - Protocols: The functionality encapsulated within each layer
    - the abstract peer-to-peer & service interfaces
    - the objects that implement those interfaces
  - Services: The set of primitives provided to the higher layer
  - Protocol vs. Service: Protocol defines the implementation of primitives of the services provided to the higher layer
- Hardware
  - Transmission Technology
  - Scale: LANs, MANs, WANs
  - Topology

**Inter-process Communication**

- Message Passing Model: send-receive
- Synchronous communications: blocking
- Asynchronous communications: blocking (receive) vs. non-blocking (send, receive) 
- Reliability
  - **Validity**: messages guaranteed to be delivered despite of packet loss
  - **Integrity**: messages must arrive uncorrupted and without duplication 
- Ordering: message send and delivery in order

**Issues in Communications**

- Message identifiers (sequence + sender ID)
- Failure Model
- Timeouts
- Duplicate request messages
- Lost reply messages
- History for re-transmissions

**Multicast**

An operation that sends a single message from one process to each of the members of a group of processes.

- Fault tolerance based on replicated service
- Finding the discovery servers in spontaneous networking
- Better performance through replicated data
- Propagation of event notifications

### Lecture 04 Distributed Objects and Remote Invocation

**Middleware** are layers between Applications and Operating System

- RMI, RPC and events
- Request-reply protocol, external data representation

**Distributed Object**

- Data / Attributes / States
- Operations / Methods

**Remote Method Invocation(RMI)**

{{<raw>}}<center><img src="https://s2.loli.net/2025/01/03/hjQZc48FbBKmfeU.png" alt="Picture2.png" style="zoom: 50%;" /></center>{{</raw>}}

- **Communication Module**
  - Implements the request-reply protocol
- **Proxies**
  - Makes RMI transparent to clients by behaving like a local object to the invoker.
- **Remote Reference Module**
  - Translates between local and remote object references and creates remote object references and proxies
- **Servant**
  - An instance of a class which provides the body of a remote object
  - This eventually handles the remote requests passed on by the corresponding skeleton. Lives in a server process.
- **Dispatcher**
  - Receives the request from communication module, uses the `methodID` to select the appropriate method in the skeleton.
- **Skeleton**
  - The class of a remote object has a skeleton which implements the methods in the remote interface.

**Remote Procedure Call (RPC)**

Request-reply protocol.

Client <-> Client Stub <-> Communication modules <-> Dispatcher <-> Server Stub <-> Service Procedure

**Invocation Semantics**

- Maybe
  - Invocation not guaranteed
- At least once
  - Re-execute procedures
- At most once
  - Re-transmit reply

### Lecture05 Indirect Communication

**Space and time coupling in distributed systems**

Space coupling: transmitter knows the address of the receiver

Time coupling: both transmitter and receiver need to present during communications

|                  | Time-coupled                       | Time-uncoupled                        |
| ---------------- | ---------------------------------- | ------------------------------------- |
| Space coupling   | Message passing, remote invocation | Email                                 |
| Space uncoupling | IP-multicast                       | Most indirect communication paradigms |

**Open group**: external nodes can access internal nodes

**Close group**: only internal nodes can access internal nodes

**Ordering**

- FIFO
- Causal
  - The precedent message should arrive earlier than the succeeding message
- Total
  - The order between any two messages should be deterministic (not only those with causation)

**Publish-subscribe paradigm**

- publishers
  - publish, advertise
- subuscrobers
  - subscribe, notify

**Event Routing**:

- Flooding
  - Filtering done at receiver-side
    - broadcast published content to all subscribers
    - broadcast subscribe to all publishers
- Filtering
  - Publisher maintains lists of subscribers, only publish to them
- Renderzvous
  - Randomly send to a node, keep forwarding until the node is the Renderzvous node responsible for this subscription.
- Informed Gossip

**Overlay Networks**: Broker network, group multicast, DHT, Gossip

**Message queue paradigm**

- Producer
  - Send
- Consumer
  - Receive, Poll, Notify

**Distributed Shared Memory**

DSM appears as memory in address space of processes via a mapping from physical memory to DSM.

**Tuple Space**

Write, read, take, notify

|                  | Groups   | Publish-Subscriber | Message Queues | DSM  | Tuple Spaces |
| ---------------- | -------- | ------------------ | -------------- | ---- | ------------ |
| Space-uncoupled  | Yes      | Yes                | Yes            | Yes  | Yes          |
| Time-uncoupled   | Possible | Possible           | Yes            | Yes  | Yes          |
| Style of service | 1-N      | 1-N                | 1-1            | 1-N  | 1-1 or 1-N   |

### Lecture05 Operating System Support

**Program, Process and Thread**

Program: static executable

Process: a currently executing program

Thread: a lightweight process, an OS abstraction of an activity

Process = execution environment + one or more threads

**Server threads and throughput**

2ms processing + 8ms I/O

- single thread
  - TP = 1000 / (2+8) = 100 rps
- two threads
  - TP = 1000 / 8 = 125 rps
  - processing time is eliminated since one thread can process during another waiting for I/O
- two threads + cache with 75% hit rate
  - TP = 1000 / (8*25%) = 500 rps
  - Caching takes CPU time, so better estimate 1000/2.5 = 400 rps
  - why?

**Multi-threaded server architectures**

- Worker Pool
  - Fixed size poll of worker threads
  - Can accommodate priority but inflexible
- Thread-per-request
  - Allows max throughput
  - Introduces thread creation/deletion overhead
- Thread-per-connection
  - A thread serving multiple requests within a connection
  - Lower overhead, unbalanced Load
- Thread-per-object
- Physical parallelism: multi-processor machines

### Lecture07 Time

**Time service**

- measure delays between distributed components
- synchronize streams
- establish event ordering
  - causal ordering
  - concurrent/overlapping execution
- for accurate timestamp to authenticate/identify
  - business transactions
  - serializability in distributed databases
  - security protocols

**Clock skew**: difference between two different clocks

**Clock drift**: difference between a clock and a perfect reference clock per unit time

**Universal Coordinated Time**(UTC) is broadcasted via GPS

**Clock Synchronization**

- external: synchronize with authoritative source of time
- internal: synchronize clocks with each other

**Clock compensation**

Two clocks of drift rate R msec/sec, must re-sync every D/2R to agree within D.

**Synchronization methods**

- synchronous system
  - simpler, relies on known time bounds on system actions
  - bound=[MIN, MAX], a message with time $t$ sets the receiver's time to $t+\frac{\text{MIN}+\text{MAX}}{2}$, to minimizes the maximum skew to $\frac{\text{MAX}-\text{MIN}}{2}$
- asynchronous system
  - intranet
    - Cristian's algorithm
      - Make multiple requests to UTC time server, set time to $t + \frac{\text{RTT}-\text{interrupt handler time}}{2}$, discard outliers.
      - single point of failure and bottleneck (solved by multicast?)
      - faulty server can wreak havoc (authentication)
    - Berkeley algorithm
      - Master polls slaves, estimates slaves' local time based on RTT, sends messages to slaves indicating clock adjustment
      - Accuracy depends on RTT, eliminates faulty clocks
      - average over the subset of clocks that differ by up to a specified amount
      - Elect another master on failure
  - internet
    - the network time protocol (NTP)
    - Primary: directly connected to UTC receivers
    - Secondary: synchronize with primary
    - Tertiary: synchronize with secondary etc.
    - Scales up to large number of servers and clients

NTP Synchronization Modes

- Multicast
- Procedure call (similar to Cristian's)
- Symmetric protocol
  - highest accuracy, used by layers closest to primary, based on pairwise sync.

**Logical clocks [Lamport]**

monotonically increasing software counter

one for each process P, used for timestamping

incremented before assigning a timestamp to an event

when P sends message m, P timestamps it with current value t of LP (after incrementing it), piggybacking t with m

on receiving message (m,t), Q sets its own clock LQ to maximum of LQ and t, then increments LQ before timestamping the message receive event

**Totally ordered logical clocks**

- Create total order by taking account of pids, sort using pid if timestamps are the same

- **Vector clocks**
  - array of N logical clocks in each process, if N processes
  - increment the corresponding component
  - compare every component to sort
  - Concern: storage requirements 

### Lecture08 Coordination and Agreement

**Mutual exclusion**

1. At most one process is in critical session at the same time
2. Requests to enter and exit are eventually granted
3. (optional, stronger) Requests to enter granted according to causality order

**Ring-based**

Arrange processes in a logical ring and let them pass token.

- No server bottleneck, no master
- If needed, take and retain, otherwise pass to neighbor in one direction

Concern

- continuous use of network bandwidth
- delay to enter depends on ring size
- causality not respected

**Ricart-Agrawala algorithm**

based on multicast communication

- N inter-connected async processes, each with
  - unique ID
  - Lamport's logical clock

- Enter critical session after the multicast request is replied by all other processes (simultaneous requests resolved with the timestamp)

released -> wanted -> held -> released

Satisfies the causality, if hardware support multicast, then only one message to enter

**Leader election**

1. Every process knowns the unique process ID, identity of leader, or is yet undefined
2. All processes participate and eventually discover the identity of the leader (cannot be undefined)

**Chang&Roberts algorithm**

- unidirectional ring of processes, non-participants and participants
- stage 1: election
  - initiator -> participant, UID given to its neighbor
  - neighbor forwards max(self UID, received UID) and becomes participant
- stage 2: elected
  - participant receives its own UID, becomes leader and non-participant, forwards elected message
  - participant receives elected message that is not itself, record the leader's UID, becomes non-participant, forwards elected message

Needs at least 3 rounds to converge

**Consensus: requirements**

- **termination**: eventually each correct process sets its decision value
- **agreement**: any two correct processes must have decided on the same decision value
- **integrity**: if all correct processes propose the same value, then any correct process that has decided must have chosen that value

**Consensus in synchronous system**

1. each process proposes a value
2. maintains the set of values V_r known to it at round r
3. in each round r s.t. 1<=r<=f+1, each process
   - multicasts the values (not sent before) to each other (V_r-V_r-1)
   - receives multicast messages, recoding any new value in V_r
4. In round f+1, each process chooses minimum V_f+1 as decision value

**Byzantine generals**

- three or more generals are agree on a binary decision
- one commander issues the order
- others decide
- one or more generals are faulty

Termination, agreement the same as before.

Integrity: if commander is correct, then all correct processes decide on the value the commander proposed

**N<=3f**

Impossibility when N<=3f, possible for N>=2f+1

- cannot distinguish whether the commander is wrong

**N>=3f+1**

Decide on majority

- success if one other general is wrong
- tie if commander is wrong

In async systems, no guaranteed solution exists even for one failure, but can reach solution with a probability.

- partially synchronous systems
- randomization

### Lecture09 Cloud Computing

Cloud Computing refers to both the applications delivered as services over the Internet and the hardware and system software in the datacenters that provide those services

A cloud infrastructure provides a framework to manage scalable, reliable, on-demand access to applications

A cloud is the “invisible” backend to many of our mobile applications

A model of computation and data storage based on “pay as you go ” access to “unlimited” remote data center capabilities

Own and Setup vs. Subscribe and Use

**Public/Private/Hybrid cloud**

**IaaS, PaaS, SaaS**

![image.png](https://s2.loli.net/2025/01/03/kZYxX4OPDVhgbei.png)

Resource managed by the provider: 

IaaS: system infrastructure (EC2)

PaaS: IaaS + user-level middleware (Hadoop)

SaaS: PaaS + user application (Google Doc)

**Virtualization Reference Model**

Guest -> Virtualization Layer -> Host

**Levels of Virtualization**

Applications -> Programming Language -> OS -> Hardware

**Execution Virtualization**

User mode (ring 3)

Privileged modes(ring 0-2)

- behavior-sensitive: expose privileged state
- control-sensitive: modify privileged state

**Hypervisors**

- type 1 (native virtual machine): run directly on top of the hardware, interact directly with ISA
- type 2 (hosted virtual machine): run on top of the host OS, interact with host ABI.

![image.png](https://s2.loli.net/2025/01/03/HacnkTbA5CIEYUd.png)

- Equivalence
- Resource control: VMM should be in complete control
- Efficiency: a statistically dominant fraction of machine instructions should be executed *without intervention from the VMM*, determined by the layout if the host

**Theorems of Hypervisors**

1. A VMM can be constructed if the set of sensitive instructions is a subset of the privileged instructions
2. If no timing dependency needed for a virtualizable computer to construct a VMM, then it's recursively virtualizable
3. If the all of the user-sensitive instructions are part of the privileged instructions, then a hybrid VMM can be constructed on this machine.

**Hardware Virtualization**

- Hardware-assisted Virtualization
  - run a guest operating system in complete isolation (Intel VT, AMD V)

- Full Virtualization
  - run OS on top of a virtual machine 
- Paravirtualization
  - nontransparent, supports thin VMM. Guests need to be modified. Simplicity
- Partial Virtualization
  - partial emulation of host, does not allow the execution of the guest OS in complete isolation. Not all features of OS are supported

**Disadvantages of virtualization**

- performance degradation
- inefficiency and degraded user experience
- security threats

## Labs

### Lab01 MPI

Message Passing Interface (MPI) is a standard for enabling communication between processes in a parallel computing environment.

- **MPI Processes**: Run concurrently and are managed by MPI.
- **Communicators**: Group processes and assign ranks, with `MPI_COMM_WORLD` being the default communicator for all processes.

**MPI Processes and Communication**:

- Each MPI process runs concurrently, either on the same machine (multi-core CPU) or across a cluster of machines. Each process has its own local memory and doesn't share memory with other processes, which is key in distributed systems.
- Communication between processes is essential, and MPI uses message-passing mechanisms for this.

#### **MPI Functions**:

- **MPI_Init**: Initializes the MPI environment.
- **MPI_Finalize**: Ends the MPI environment.
- **MPI_Comm_size**: Retrieves the number of processes in the communicator.
- **MPI_Comm_rank**: Retrieves the rank of a specific process within a communicator.
- **MPI_Get_processor_name**: Retrieves the name of the processor running the process.

#### MPI Communication Modes

There are **four main types** of communication modes in MPI, each determining how messages are sent and received.

1. **Standard Mode**
   - The system decides if buffering is required.
   - Can be **buffered** (returns immediately) or **non-buffered** (waits until data is sent).
   - **Non-local** mode, requiring communication with another process in non-buffered cases.
2. **Buffered Mode**
   - Data is copied to a buffer and returned immediately.
   - Sending happens in the background.
   - **Local** mode (does not require communication with other processes).
3. **Synchronous Mode**
   - The send operation only completes when the receiving process is ready.
   - Ensures both sender and receiver are synchronized.
   - **Non-local** mode.
4. **Ready Mode**
   - Assumes that the recipient is ready to receive the message.
   - If the recipient is not ready, an error occurs.
   - **Non-local** mode.

#### Blocking vs Non-Blocking Communication

- **Blocking Communication**:
  - The function call waits until the operation is completed.
  - Example: `MPI_Send`, `MPI_Recv`.
- **Non-Blocking Communication**:
  - The function returns immediately, but the operation continues in the background.
  - Example: `MPI_Isend`, `MPI_Irecv`.
  - The user needs to ensure that the operation completes before using the data.

#### Collective Communication in MPI

Collective communication involves interactions among **multiple processes (≥ 3)**. This is commonly used for coordination and data exchange in distributed systems.

- **Barrier (Synchronization)**:

  - Blocks all processes until they all reach the barrier.

  - Example:

    ```c
    MPI_Barrier(MPI_COMM_WORLD);
    ```

- **Broadcast (1-N)**:

  - The root process sends data to all other processes.

  - Example:

    ```c
    MPI_Bcast(&data, 1, MPI_INT, root, MPI_COMM_WORLD);
    ```

- **Scatter (1-N)**:

  - The root sends distinct pieces of data to all other processes.

  - Example:

    ```c
    MPI_Scatter(&sendbuf, count, MPI_INT, &recvbuf, count, MPI_INT, root, MPI_COMM_WORLD);
    ```

- **Gather (N-1)**:

  - Data from all processes is collected at the root.

  - Example:

    ```c
    MPI_Gather(&sendbuf, count, MPI_INT, &recvbuf, count, MPI_INT, root, MPI_COMM_WORLD);
    ```

- **MPI_Reduce (N-N)**:

  - Purpose: Perform a distributed computation (e.g., summing data) where the result is gathered by the root process.

  - Common operation: `MPI_SUM`, which computes the sum across all processes.

  - Example:

    ```c
    MPI_Reduce(&sendbuf, &recvbuf, count, MPI_INT, MPI_SUM, root, comm);
    ```

- **MPI_Allreduce (N-N)**:

  - Purpose: Each process gets the result of the operation, making it ideal for situations where each process needs to know the result of a global computation.

  - Example:

    ```c
    MPI_Allreduce(&sendbuf, &recvbuf, count, MPI_INT, MPI_SUM, comm);
    ```

- **MPI_Scan (N-N)**:

  - Purpose: Similar to a reduction, but each process gets the accumulated result up to its rank.

  - Example:

    ```c
    MPI_Scan(&sendbuf, &recvbuf, count, MPI_INT, MPI_SUM, comm);
    ```

- **MPI_AlltoAll (N-N)**:

  - Purpose: Every process sends its data to every other process, which is used for full data exchanges between processes.

  - Example:

    ```c
    MPI_AlltoAll(&sendbuf, sendcount, sendtype, &recvbuf, recvcount, recvtype, comm);
    ```

- **MPI_Reduce_scatter (N-N)**:

  - Purpose: Scatters the reduced data across processes and performs a reduction (such as a sum) at each step.

  - Essentially combines **scatter** and **reduce** operations in a single call.

  - Example:

    ```c
    MPI_Reduce_scatter(&sendbuf, &recvbuf, recvcounts, MPI_INT, MPI_SUM, comm);
    ```

### Lab02 RPC

#### Remote Procedure Call (RPC) Principles:

- **Serve Remotely**: Execute procedures on a remote server.
- **Invoke as if Locally**: Calls are made as if they are local, abstracting remote interaction.
- **Abstract Remote Interaction Details**: The complexity of remote procedure calls is hidden from the developer.

#### Key Design Concerns in RPC:

1. **Protocol**: Ensures proper communication between client and server (e.g., defining procedure names, parameters, and return types in Interface Definition Language).
2. **Communication**: Covers how requests and responses are transmitted, including serialization of data and selection of network protocols (e.g., TCP or HTTP).
3. Proxy:
   - **Client Stub**: The client-side proxy to request remote procedures.
   - **Server Stub**: The server-side proxy to handle incoming remote procedure calls.

#### gRPC as an RPC Implementation:

- **gRPC** is a high-performance, cross-platform RPC framework developed by Google and part of the Cloud Native Computing Foundation (CNCF).
- **Protocol**: Uses `proto` files for defining messages, remote procedures, and services. These proto files are compiled with `protoc` to generate code for client and server.
- Communication:
  - Uses **Protocol Buffers (Protobuf)** for message serialization, making the communication more compact and efficient compared to alternatives like Java's Object Serialization.
  - gRPC operates over **HTTP/2**, which allows efficient multiplexing of multiple RPC calls over a single connection.
- Proxy:
  - **Client Stub**: Automatically generated from proto files, retrieved from the gRPC channel, and used by the client to interact with remote procedures.
  - **Server Template**: The server extends this template and implements the defined remote procedures.

**gRPC - Key Benefits:**

- **Static & Automatic Code Generation**: gRPC simplifies client-server communication with automatic generation of client stubs and server templates through `protoc`.
- **Efficient Communication via Protobuf**: Uses compact binary encoding for fast data parsing and transmission.
- **Cross-Language & Cross-Platform Support**: Works across different programming languages and platforms.
- **Bidirectional Streaming**: Enables both client and server to send multiple messages in a single call.
- **Multiplexing via HTTP/2**: Multiple RPCs can be handled concurrently over one HTTP/2 connection.

**Serialization with Protobuf:**

- Protobuf (Protocol Buffers) is a compact, binary-based serialization format, used for structured data. It is efficient compared to text-based formats like JSON or XML.
- It benefits from **compact data storage**, **cross-language support** via proto files (IDL), and **automatic code generation** with `protoc`.

**gRPC Streaming:**

- gRPC supports four types of streaming:
  - **Unary RPC**: A single request and response.
  - **Server-Side Streaming**: Client sends one request; server streams multiple responses (e.g., large file retrieval).
  - **Client-Side Streaming**: Client streams multiple requests; server sends one response (e.g., data batch processing).
  - **Bidirectional Streaming**: Both client and server exchange multiple messages (e.g., real-time applications like live chat or gaming).

**gRPC - Multiplexing:**

- Multiplexing allows multiple RPCs to be handled concurrently over one HTTP/2 connection, which is efficient in managing long-running or multiple simultaneous requests.
  - **Single Connection**: All requests are handled over a single connection, allowing efficient resource use.
  - **Thread Pooling**: If there are not enough workers, some requests are queued and handled once workers are available.

### Lab03 RESTful API

#### **REST as an Architecture Style**

- **Representational State Transfer (REST)** is an architectural style for distributed hypermedia systems.
- REST Components:
  - **Resources**:  abstraction of information
    - Identifiers: URI including URL endpoint etc.
    - Metadata
      - Source links
      - Alternate data formats (JSON, XML etc.)
      - Vary: language preferences
  - **Representation**: state of the resource
    - Metadata (e.g., media type, etc.)
      - Media type (application/json)
      - Last-modified time
  - **Control Data**: interaction behaviour
    - Cache-Control

#### **6 Guiding Principles of REST**

1. **Client-Server**
   - Separation of concerns
   - Modularization
   - Features
     - Portability of client
     - Scalability of server
2. **Stateless**
   - No session state on server
   - Request contains all necessary info
   - Requests do not rely on one another
   - Features:
     - Visibility
     - Reliability
     - Scalability
   - Concern: repetitive data overhead
3. **Cacheable**
   - Response data should explicitly or implicitly announce cache-ability to notify the client to reuse the **client-side cache**.
   - Concern: stale data handling
4. **Uniform Interface**
   - Principle of Generality
   - Identification of resources: uniquely identify each resource
   - Manipulation of resources through representations: uniform representation
   - Self-descriptive messages: enough info in each resource representation
   - Hypermedia as the engine of application state: drive resources via hyperlinks
   - Features: Simplicity, Independent evolvability etc.
   - Concern: degradation of efficiency
5. **Layered System**
   - Hierarchical layers, e.g., Model-View-Controller(MVC) Pattern
   - Features
     - Reduced coupling
       - Evolvability
       - Reusability
     - Scalability
     - Transparency
   - Concern: complexity and processing overhead
6. **Code on Demand (optional)**
   - Extend client functionality by downloading code from server
   - Example: server sends JavaScript code to client to execute
   - Features:
     - Simplicity of client init feature
     - Flexibility
   - Concern: visibility & security

#### **Benefits of RESTful API**

- **Scalability**:
  - **Client-Server** enables multiple server duplicates with load balancing
  - **Stateless** ensures that each request is independently  processable, thus the servers can be easily scaled out
  - **Cacheable** reduces the load of the servers so they can serve more clients, introducing distributed caching further improves the service capacity
- **Flexibility and Independence**:
  - **Client-Server**  allows the client and the server to be evolved independently without affecting each other
  - **Layered System** further decouples service logic so that each layer can be designed and implemented separately
  - **Code on Demand** allows the client to extend new functionalities when needed provided by the server via downloading code
- **Uniform Interface**: A consistent interface for interacting with resources, simplifying development and reducing complexity.

#### **RESTful API vs. gRPC**

| Terms                 | gRPC                                                  | REST                                                         |
| --------------------- | ----------------------------------------------------- | ------------------------------------------------------------ |
| Data format           | Protobuf,  binary form                                | plain-text (JSON, XML)                                       |
| Data validation       | Auto validation against the API contract              | Extra validation needed on JSON data                         |
| Communication pattern | Unary, server/client/bidirectional streaming          | Unary request/response cycle                                 |
| Design pattern        | Defines remote-callable functions on the server       | Uses HTTP methods to grant access to resources through dedicated endpoints |
| Code generation       | Support code generation in many programming languages | (?) No native support for code generation                    |
| Primary use case      | Microservice architectures                            | Public APIs or APIs where ease of use is a priority          |

### Lab04 Proxy

**Forward Proxy**

A server in front of a group of clients, intercepting clients' requests and then communicates with web servers on behalf of those clients.

- Access Control and Security
- Privacy and Anonymity
- Content Caching and Filtering
- Monitoring and Logging
- Transparency

**Reverse Proxy**

A server in front of one or more web servers, intercepting and redirecting requests from clients.

- Load Balancing
- Access Control and Security
- Content Caching and Filtering
- Monitoring and Logging
- SSL Encryption Offloading

### Lab05 HDFS, YARN and Spark

#### Hadoop Overview

Hadoop is a framework designed for the distributed storage and processing of massive datasets across clusters of computers. 

**Principles and assumptions behind Hadoop**

1. **Hardware failure is the norm**: Hadoop is built to be resilient to hardware failures, ensuring data availability.
2. **High throughput over low latency**: Prioritizes fast data processing rather than low response times.
3. **Write-once-read-many model**: Optimized for applications where data is written once and accessed many times.
4. **Large datasets**: Hadoop is ideal for handling massive datasets, ranging from gigabytes to terabytes.
5. **Moving computation is cheaper than moving data**: Computation should be moved to where the data resides, rather than transferring large datasets across the network.

#### Hadoop Ecosystem Components

**HDFS (Hadoop Distributed File System)**:

A distributed, fault-tolerant, write-once-read-many file system.

- HDFS Architecture:
  - **NameNode**: Manages metadata, the filesystem namespace, and file operations like open, close, and rename.
  - **DataNodes**: Store the actual data blocks and handle client read/write requests after receiving permission from the NameNode.
- **Block storage**: Files are split into fixed-size blocks (default 128MB) stored across DataNodes.

**YARN (Yet Another Resource Negotiator)**:

- Manages and schedules resources for Hadoop jobs (e.g., MapReduce).
- **ResourceManager**: Allocates resources across the cluster and manages job scheduling.
- **NodeManager**: Each machine in the cluster runs a NodeManager to monitor resources (CPU, memory, disk) and report usage to the ResourceManager.

**MapReduce**:

- A programming model for distributed data processing based on the **Map** and **Reduce** operations.
- **Map**: Converts input data into key-value pairs.
- **Reduce**: Combines results from the Map step based on the key-value pairs.

#### HDFS Features and Fault Tolerance

- **Data Block Storage**: Files in HDFS are split into blocks and stored across multiple DataNodes. By default, each block is replicated 3 times for fault tolerance.
- **Replication**: Each file’s blocks are replicated across multiple DataNodes. If a DataNode fails, the system can still access data through replicas on other DataNodes. The replication factor is adjustable.
- **Heartbeat Mechanism**: DataNodes periodically send heartbeat signals to the NameNode to indicate they are functioning. If the NameNode stops receiving a heartbeat from a DataNode, it considers the node as failed and replicates the blocks stored on it to other nodes.

#### **MapReduce in Action**

- **Map phase**: Raw input data is processed and converted into key-value pairs.
- **Reduce phase**: Aggregates the key-value pairs into final results.
- The **shuffle and sort** phase between Map and Reduce ensures that all values associated with the same key are sent to the same reducer.
  - MapReduce produces as many result files (parts) as the reducers
- MapReduce is executed as a job which managed by the framework, which will be rescheduled upon failures.

**MapReduce Advantages**: It minimizes data transfer by performing computation on data stored locally, reducing the amount of data that needs to be moved between nodes.

#### YARN (Yet Another Resource Negotiator)

**YARN** abstracts the resource management from the user, allowing frameworks like MapReduce and Spark to run on a shared cluster without manual resource allocation.

- **ResourceManager**
  - Central controller responsible for job scheduling and resource allocation.
- **NodeManager**
  - Local agent on each node that manages resource usage and reports the resource usage to the ResourceManager.

#### YARN Job Execution

1. **Client sends job request** to the Application Manager, which includes the job’s resource and data requirements.
2. **Data location**: The system checks where the required data is stored in HDFS.
3. **Resource request**: The Application Manager requests resources from the ResourceManager’s scheduler.
4. **Scheduler assigns resources**: The ResourceManager decides where and when the job will run.
5. **Job launch**: The ResourceManager notifies NodeManagers to start the job in the appropriate containers.
6. **Containers**: NodeManagers start the task containers, using the allocated resources to execute the job.

#### YARN Scheduling

**YARN Scheduler** decides when and where jobs will run. Scheduling ensures optimal resource utilization across the cluster.

**Scheduling Strategies (When)**

- **FIFO Scheduler**: Jobs are executed in the order they are received.
- **Capacity Scheduler**: Resources are assigned to different priority queues, with higher-priority tasks given more resources.
- **Fair Scheduler**: Ensures that all queues receive a fair share of resources. No priority, but resources are allocated equally among tasks in each queue.

**Where**: determined by where the data is stored in HDFS.

#### Scheduling benefits

Finding an optimal scheduling strategy for a given workload is an NP-Complete problem. However, a good scheduling strategy can:

- Maximize resource utilization
- Minimize task waiting time
- Reduce energy usage

#### MapReduce Streaming

**MapReduce Streaming** allows the use of **any executable** for the **mapper** and **reducer** process. 

- **Input data** is passed to the **mapper** via `stdin`. The mapper processes the data and emits key-value pairs to `stdout`.
- These key-value pairs are sorted by the Hadoop framework and are passed to the **reducer** via `stdin`.
- The reducer processes the sorted key-value pairs, produces the output, and writes it back to **HDFS**.

#### Spark

Spark is an **in-memory distributed data processing engine** that enables faster processing compared to traditional disk-based frameworks like Hadoop MapReduce.

#### Resilient Distributed Datasets (RDDs)

RDD is the core data structure in Spark—an **immutable, distributed collection** of objects that can be processed in parallel across a cluster.

**Advantages over MapReduce**:

- RDDs are stored **in-memory**, making data processing faster.
- **Persistent**: RDDs can be cached in memory, reducing the need to recompute intermediate results.
- RDDs support **lazy execution**, which allows Spark to optimize the computation by building a Directed Acyclic Graph (DAG) before running the actual computation.

Spark does not have a built-in file system. Data can be accessed from a variety of sources, but Spark is often used in an HDFS or cloud-based environment where the data is already distributed across nodes.

### Lab06 Kubernetes

#### Virtualization

- Creates virtual representations of hardware
- Powers cloud computing services by helping organizations manage infrastructure

**Benefits**

- More flexible & secure(isolation) resource utilization
- Painless environment setup & recovery effort (keep everything tidy).

**Hypervisor (Virtual Machine Monitor)**: a type of computer software, or hardware that creates and runs virtual machines.

#### Containerization

**Container Images**: lightweight packages of application code together with dependencies required to run your software services.

**Container vs. Virtual Machine**

- Efficient
  - Containerized apps share the hosting OS kernel, use fewer resources
  - Easier environment setup
- Lightweight: contains only libraries and tools
- Portability: OS-independent

#### Docker

**Registry**: Docker Hub `pull`

**Image**: OS + Apps `build`

**Container**: image instance `run`

{{<raw>}}<center><img src="https://learn.microsoft.com/en-us/dotnet/architecture/microservices/container-docker-introduction/media/docker-containers-images-registries/taxonomy-of-docker-terms-and-concepts.png" style="zoom: 33%;" /></center>{{</raw>}}

Docker CLI, Docker Daemon, Docker Desktop

**Docker Compose**: Multi-container applications on a **single** host

**Docker Swarm**: Multi-container applications on multiple hosts

**Kubernetes**: a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both *declarative configuration and automation*.

#### Kubernetes

K8s is an open-source container orchestration system for automating software deployment, scaling, and management.

Currently the most popular software deployment solution for containerized applications, especially in cloud-native application architectures.

**Features**

- **Horizontal scaling**: Automatically scaling applications by adding/removing replicas of containers.
- **Self-healing**: Automatically replacing failed containers.
- **Automated rollouts & rollbacks**: Ensures the application deployment is consistent and can be rolled back in case of failure.
- **Automatic bin packing**: strategically placing containers, or "bins," within nodes to maximize resource utilization while minimizing wasted resources
- **Service discovery & load balancing**: Automatically distributes network traffic across containers.

**Kubernetes Components**

- Control Plane
  - etcd: A distributed key-value store used to store cluster data.
  - API Server: Exposes the Kubernetes API to clients like kubectl.
  - Controller Manager:  Ensures the desired state matches the actual state by running various control loops.
  - Cloud Controller Manager: Manages cloud-specific resources (optional).
  - Scheduler:  Responsible for scheduling pods to appropriate nodes based on resource availability.
- Worker Node
  - kubelet: An agent that runs on each node to ensure containers are running in a pod.
  - kube-proxy: Manages network traffic between services in the cluster.
  - Container Runtime: Software that runs containers (e.g., Docker, containerd).

{{<raw>}}<center><img src="https://kubernetes.io/images/docs/components-of-kubernetes.svg" style="zoom: 50%;" /></center>{{</raw>}}

**Kubernetes Resources/Objects**

- **Pod**: The smallest and most basic deployable object in Kubernetes. A pod can contain one or more containers.
- **ReplicaSet & Deployment**: Deployment owns ReplicaSets to manage sets of pod replicas, in order to execute stateless workloads.
- **StatefulSet**: Maintains a group of pods to support stateful applications with persistent storage & network identities.
- **Service**: Expose applications behind a single endpoint
- **Job**: One-off tasks that run to completion and then stops.
- **AutoScalers**: Automatically adjust the number of running pods or the cluster nodes based on usage.

**Kubernetes CLI - kubectl**

- Imperative commands
  - Operate directly on live cluster objects (create, replace etc.)
- Imperative object configuration
  - Operate states of the objects via configuration files.
- Declarative object configuration
  - Let kubectl examines a group of configuration files and auto detect and applyy changes without specifying the actual operations.

**Kubernetes Scheduler**

- Pod Scheduling / Node Selection
  1. Filtering: find a set of "feasible" nodes
     - Pod affinity/anti-affinity + taints + tolerations
  2. Scoring: ranks the remaining nodes to choose the most suitable od placement
- Pod Binding: notifies the API server about the decision

**Pod Affinity & Anti-affinity**

- Pod Affinity & Anti-affinity handle inter-pod constraints: pods must/can (not) be with each other.
- Instead of node labels, pod labels are examined.

**Taints & Tolerations**

Node Affinity: nodes with certain labels attract these pods.

Taints: nodes with certain taints repel pods

Tolerations: Pods are configured so that they can tolerate certain node taints and become schedulable to relevant nodes.

- Dedicated node specification
  - Hardware requirement
  - Business-level Logic
- Temporary node isolation
  - For responsibility managing
  - For maintenance / troubleshooting

### Lab07 Cloud Computing

A paradigm for enabling network access to a scalable and elastic pool of shareable physical or virtual resources with self-service provisioning and administration on-demand.

**5 Essential Characteristics (by INST)**

1. On-demand self-service
   - Provision as needed
   - Automatic provisioning
2. Broad network access
   - Heterogeneous clients
3. Resource pooling
   - Serve multiple clients
4. Rapid elasticity
   - "Unlimited" resources
5. Measured service
   - Monitoring for optimization

**Cloud Service Models**

- Infrastructure as a Service (IaaS)
  - On-demand access to cloud-hosted physical and virtual servers, storage and networking
- Platform as a Service (Paas)
  - On-demand access to a complete, ready-to-use, cloud-hosted platform for developing, running, maintaining and managing applications
- Software as a Service (SaaS)
  - On-demand access to ready-to-use, cloud-hosted application software

{{<raw>}}<center><img src="https://media7o.sedmiodjel.com/blog/pros-and-cons-of-different-cloud-computing-models/cloud-computing-models-comparison.png" style="zoom: 33%;" /></center>{{</raw>}}

FaaS, CaaS, KaaS etc.

**Common Cloud Services**

**Infrastructure as Code (IaC)**