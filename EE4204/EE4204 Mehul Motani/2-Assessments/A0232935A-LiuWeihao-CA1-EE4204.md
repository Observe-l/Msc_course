Liu Weihao

A0232935A

## Q1

1. Time delay 
2. Packet loss 
3. Bandwidth
4. Throughput

## Q2

**a)**

**Layer 1 - Physical:**

This layer deals with physical characteristics of transmission medium.

**Layer 2 - Data link:**

This layer provides access to the networking media and physical transmission across the media.

Besides, it provides reliable transit of data across a physical link. (hop-by-hop)

**Layer 3 - Network:**

This layer defined end-to-end delivery of packets. It also defines how routing works and how routes are learned so that the packets can be delivered.

**Layer 4 - Transport**

This layer regulates information flow to ensure end-to-end connectivity between host applications reliably and accurately.

**Layer 5 - Session**

This layer defines how to start, control and end conversations (called sessions) between applications. This includes the control and management of multiple bidirectional messages using dialogue control.

**Layer 6 - Presentation**

This layer ensures that the information that the application layer of one system sends out is readable by the application layer of another system.

**Layer 7 - Application**

This layer provides network services to the user's applications.

**b)**

TCP/IP stack contain **data link layer**, **network layer**, **transport layer** and **application layer**.

## Q3

**Pros:**

1. Increased efficiency. 

2. This contributes to improve the QoS in mobile network.

3. It is used in various Routing schemes and for reservation mechanisms.

4. This strategy supports information exchange  and optimization.

**Cons:**

1. It suffers with lack of proper architecture.

2. It may create chaos.
3. Cross-layer Interaction may lead to unforeseen dependencies among the layers.
4. It cannot be easily integrated.
5. Chances of various improper stability issues if not handled correctly.

## Q4

**a) Packet Switching**

Compare with circuit switching, packet switching allows more users to use network.

**b) End-to-End principle**

This principle is aimed to secure the data transmit from sender to it's destination.

## Q5

**a)**

ARQ is in the data link layer and transport layer

**b)**

TCP is in transport layer

**c)**

In transport layer, ARQ is part of TCP. TCP can also provide flow control, congestion control.

In data link layer, ARQ provide hop-by-hop transmit reliability.

## Q6

**a)** The hierarchical structure of Internet

Network edge: applications and hosts

Access networks, physical media: wired, wireless

Network core: routers

**b)** The addressing of Internet

It made up of a network address and host address.

## Q7

Circuit Switching is circuit-like performance. Each host has a fixed transmit channel (TDM, FDM). But it can not use the transmit channel 100%.

Packet Switching can combine data from different host. So this method is more efficiency. But it can not avoid congestion.

## Q8

MAC Addresses handle the physical connection from computer to computer.

IP Addresses handle the logical routeable connection from both computer to computer AND network to network

## Q9

Both can be used. But I prefer router.

**pros:**

1. The host can access the Internet and other networks sharing a single IP.
2. Router can set up a larger-scale network than  switching.

**cons:**

Because router works in network layer while  switch works in data link layer, the transmit rate of router is slower.

## Q10

**a)** Data link layer

Broadcast storm, ARP/switch poisoning

**b)** Network layer

DDoS attack: smurf attack, ping of death attack

