Liu Weihao

A0232935A

### Q1

* IPv4 only has 32-bit address, the address space soon to be completely allocated. But IPv6 has 128 bits address.
* Header format helps speed processing/forwarding
* Header changes to facilitate QoS

### Q2

1. Link-State approach
   - This is a global information, all routers have complete topology, link cost info.
   - It's a static protocol, routes changes slowly

2. Distance Vector
   - It's a decentralized information, router knows physically-connected neighbors, link costs to neighbors.
   - Iterative process of computation, exchange of info with neighbors.

### Q3

RIP: DV, Intra-AS, distributed

OSPF: LS, Intra-AS, centralized

BGP: DV. inter-AS, distributed

### Q4

No, it's not fair. We should use Max-Min allocation.

Round 1, allocate 10 mbps to each user. Then remove satisfied user (user 3)

Round 2, 40 40 10.

So, user 1 and 2 get 40 mbps, user 3 get 10 mbps.

### Q5

First, we give every user resources until one user is satisfied, then remove the satisfied user and repeat

TCP uses max-min fair

### Q6

**a) cost**

Step 1:

E = {(A, B), (A, C), (A,D)}

Step 2:

E = {(AB, C), (AB, E), (A, C), (A,D)}

Step 3:

E = {(AB, E), (AC, B), (AC, D), (A,D)}

Step 4:

E = {(AB, E), (AD, E)}

Step 5:

E = {A-D-E}

**b) delay**

Step 1:

E = {(A, B), (A, C), (A,D)}

Step 2:

E = {(A,B), (AC, B), (AC, D), (A,D)}

Step 3:

E = {(ACB, E), (AD, E)}

Step 4:

E = {A-C-B-E}

### Q7

**a) cost**

$d_D(A)=min\{3,2+3\}=3$, $d_D(C)=min\{2,3+3\}=2$, $d_D(E)=4$

$d_D(B)=min\{c(D,A)+d_A(B), c(D,C)+d_D(B),c(D,E)+d_E(B)\}=min\{3+2,2+2,4+6\}=4$

Then we can get the table

|        |  A   |  B   |  C   |  E   |
| :----: | :--: | :--: | :--: | :--: |
| From D |  3   |  4   |  2   |  4   |

**b) delay**

$d_D(A)=min\{4,3+1\}=4$, $d_D(C)=min\{3,4+1\}=3$, $d_D(E)=4$

$d_D(B)=min\{c(D,A)+d_A(B), c(D,C)+d_D(B),c(D,E)+d_E(B)\}=min\{4+6,3+4,4+2\}=6$

Then we can get the table

|        |  A   |  B   |  C   |  E   |
| :----: | :--: | :--: | :--: | :--: |
| From D |  4   |  6   |  3   |  4   |

### Q8

As above

### Q9

* Each user is equal, when their demand are not satisfied, they should get same resources
* We should not allocate resources exceed users' needs.

### Q10

If we use Minimum-cost Broadcast Spanning Tree, we won't chose node C.

In terms of cost, the path is same. But in terms of delay, the path will change to: {A-B-E} or {A-D-E}

### Q11



