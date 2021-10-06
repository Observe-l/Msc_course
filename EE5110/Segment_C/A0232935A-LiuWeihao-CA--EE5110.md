Liu Weihao

A0232935A

## Q.1

### a) Calculus of variations

The input signal is:
$$
u=-\frac{2}{a}y+\frac{1}{a}\dot{y}
$$
The function $J(y,u)$ changes to:
$$
\begin{aligned}
J(y)&=\int_0^{\infin}[y^2+w(-\frac{2}{a}y+\frac{1}{a}\dot{y})^2]dt\\
&=\int_0^{\infin}[(\frac{4w}{a^2}+1)y^2+\frac{w}{a^2}\dot{y}^2]dt-\frac{4w}{a^2}\int_0^{\infin}y\dot{y}dt
\end{aligned}
$$
Because
$$
\int_0^{\infin}y\dot{y}dt=y^2|_0^\infin-\int_0^{\infin}y\dot{y}dt\\
\int_0^{\infin}y\dot{y}dt=\frac{1}{2}[y^2(\infin)-y^2(0)]
$$
So:
$$
J(y)=\int_0^{\infin}[(\frac{4w}{a^2}+1)y^2+\frac{w}{a^2}\dot{y}^2]dt-\frac{2w}{a^2}y^2(\infin)+\frac{2w}{a^2}c^2
$$
Let $z(t)$ denote any function of t with the property that $J(z)$ exists. Take $\varepsilon$ to be a scalar parameter.
$$
J(y_0+\varepsilon z)=\int_0^{\infin}[(\frac{4w}{a^2}+1)(y_0+\varepsilon z)^2+\frac{w}{a^2}(\dot{y}_0+\varepsilon\dot{z})^2]dt-\frac{2w}{a^2}y^2(\infin)+\frac{2w}{a^2}c^2
$$
The $J(y_0+\varepsilon z)$ must have an absolute minimum at $\varepsilon=0$ 
$$
\frac{d}{d\varepsilon}J(y_0+\varepsilon z)|_{\varepsilon=0}=0\\
\begin{aligned}
J(y_0+\varepsilon z)&=\int_0^{\infin}[(\frac{4w}{a^2}+1)y_0^2+\frac{w}{a^2}\dot{y}_0^2]dt+2\varepsilon\int_0^{\infin}[(\frac{4w}{a^2}+1)(y_0z)+\frac{w}{a^2}\dot{y}_0\dot{z}]dt\\
&+\varepsilon^2\int_0^{\infin}[(\frac{4w}{a^2}+1)z^2+\frac{w}{a^2}\dot{z}^2]dt-\frac{2w}{a^2}y^2(\infin)+\frac{2w}{a^2}c^2
\end{aligned}
$$
We see then that the variational condition derived is
$$
\int_0^{\infin}[(\frac{4w}{a^2}+1)(y_0z)+\frac{w}{a^2}\dot{y}_0\dot{z}]dt=0\\
\dot{y}_0z|_0^{\infin}+\int_0^\infin z[(\frac{4w}{a^2}+1)y_0-\frac{w}{a^2}\ddot{y}_0]dt=0\\
\dot{y}_0(\infin)z(\infin)-\dot{y}_0(0)z(0)+\int_0^\infin z[(\frac{4w}{a^2}+1)y_0-\frac{w}{a^2}\ddot{y}_0]dt=0
$$
Since $y_0+\varepsilon z$ is an admissible function satisfies the initial condition
$$
y_0(0)+\varepsilon z(0)=c
$$
We see that $z(0)=0$.

Since the left-hand side must be zero for all admissible $z$, we suspect that
$$
(\frac{4w}{a^2}+1)y_0-\frac{w}{a^2}\ddot{y}_0=0
$$
First, we use $T$ to replace $\infin$, $\dot{y_0}(T)=0$. And we obtain no condition on $\dot{y_0}(0)$. We can get:
$$
y_0(0)=c,\; \dot{y}_o(T)=0
$$
The general solution of the differential equation is:
$$
y=c_1e^{\sqrt{4+a^2/w}\cdot t}+c_2e^{-\sqrt{4+a^2/w}\cdot t}
$$
Using the boundary conditions, we have the two equations to determine the coefficients $c_1$ and $c_2$. 
$$
c=c_1+c_2\\
0=c_1e^{\sqrt{4+a^2/w}\cdot T}-c_2e^{-\sqrt{4+a^2/w}\cdot T}
$$
Solving, we obtain the expression:
$$
y_o(t)=c(\frac{e^{\sqrt{4+a^2/w}(t-T)}+e^{-\sqrt{4+a^2/w}(t-T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c\frac{cosh(\sqrt{4+a^2/w}(t-T))}{cosh(\sqrt{4+a^2/w}\cdot T)}
$$
Let $T\rightarrow \infin$, We have
$$
y_o(t)=c(\frac{e^{\sqrt{4+a^2/w}(t-T)}+e^{-\sqrt{4+a^2/w}(t-T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c(\frac{e^{\sqrt{4+a^2/w}(t-2T)}+e^{-\sqrt{4+a^2/w}\cdot t}}{e^{-2\sqrt{4+a^2/w}\cdot T}+1})\rightarrow ce^{-\sqrt{4+a^2/w}\cdot t}\\
\dot{y}_o(t)=c\sqrt{4+a^2/w}\cdot(\frac{e^{\sqrt{4+a^2/w}(t-T)}-e^{-\sqrt{4+a^2/w}(t-T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c\sqrt{4+a^2/w}\cdot(\frac{e^{\sqrt{4+a^2/w}(t-2T)}-e^{-\sqrt{4+a^2/w}\cdot t}}{e^{-2\sqrt{4+a^2/w}\cdot T}+1})\rightarrow -c\sqrt{4+\frac{a^2}{w}}\cdot e^{-\sqrt{4+a^2/w}\cdot t}\\
\dot{y}_o=-\sqrt{4+\frac{a^2}{w}}\cdot y_o(t)
$$
So we have the control laws
$$
u(t)=-\frac{2}{a}y(t)+\frac{1}{a}\dot{y}(t)=-\frac{1}{a}(2+\sqrt{4+\frac{a^2}{w}})y(t)
$$

### b) Dynamic programming

Optimal Value function:
$$
V(c,T)=\min_{y}J(y)\\
J(y)=\int_0^\Delta+\int_\Delta^T=(c^2+wu^2)\Delta+V(c+(ac+au)\Delta,T-\Delta)+O(\Delta^2)
$$
We can use Taylor series to relate $V(c+(2c+au)\Delta,T-\Delta)$ with $V(c,T)$, $J(y)$ will change to
$$
V(c,T)=\min_u[(c^2+wu^2)\Delta+V(c,T)+\frac{\partial V}{\partial c}(2c+au)\Delta-\frac{\partial V}{\partial T}\Delta+O(\Delta^2)]
$$
Ignoring the higher order terms of $\Delta$, we have
$$
\frac{\partial V}{\partial T}=\min_u[(c^2+wu^2)+\frac{\partial V}{\partial c}(2c+au)]
$$
When $T\rightarrow\infin$, $V(c,T)$ becomes $V(c)$, 
$$
V(c)=\min_u[(c^2+wu^2)\Delta+V(c+(2c+au)\Delta)]+O(\Delta^2)\\
0=\min_u[(c^2+wu^2)+\dot{V}(c)(2c+au)]
$$
Take the derivative respect to $u$ gives $2wu+\dot{V}(c)a=0$, so
$$
u=-\frac{a}{2w}\dot{V}(c)\\
0=(c^2+w(-\frac{a}{2w}\dot{V}(c))^2)+\dot{V}(c)(2c+a(-\frac{a}{2w}\dot{V}(c)))\\
\dot{V}^2(c)-\frac{8wc}{a^2}\dot{V}(c)-\frac{4wc^2}{a^2}=0\\
\dot{V}(c)=\frac{4wc}{a^2}\pm\frac{2c}{a^2}\sqrt{4w^2+wa^2}
$$
So we have two possibilities, with the condition $V(0)=0$, we can obtain two possible solutions:
$$
V(c)=(\frac{2w}{a^2}+\frac{1}{a^2}\sqrt{4w^2+wa^2})c^2\\
V(c)=(\frac{2w}{a^2}-\frac{1}{a^2}\sqrt{4w^2+wa^2})c^2
$$


Since $V(c)\geqslant0$, we see that $V(c)=(\frac{2w}{a^2}+\frac{1}{a^2}\sqrt{4w^2+wa^2})c^2$, the optimal value can be easily obtained as
$$
u=-\frac{a}{2w}\dot{V}(c)=-\frac{1}{a}(2+\sqrt{4+\frac{a^2}{w}})c
$$
Since $y(0)=c$, so we have $u(0)=-\frac{1}{a}(2+\sqrt{4+\frac{a^2}{w}})y(0)$. At any time $t$, we will have the control law:
$$
u(t)=-\frac{1}{a}(2+\sqrt{4+\frac{a^2}{w}})y(t)
$$
**As we can see, the results from two method are same**

### c) Weight factor

If $w\rightarrow\infin$, the $u(t)$ and $y(t)$ will change to
$$
u(t)=-\frac{4}{a}y(t)\\
y(t)=ce^{-2t}
$$
If $w\rightarrow0$, the $u(t)$ and $y(t)$ will change to
$$
u(t)\rightarrow -\infin\\
y(t)=0
$$

As we can see, if weight is very big, the input signal will very small. If weight is small, the control signal will very big, and the output will change to 0 rapidly

<div STYLE="page-break-after: always;"></div>

## Q.2

We write the optimal value function as
$$
V_N(c)=\min_{u_n}J_N(y,u)
$$
After $u(0)$ is chosen, the new state of the system is $y(1)=2c+au(0)$, The cost function takes the form
$$
c^2+wu^2(0)+\sum_{n=1}^N(y^2(n)+wu^2(n))
$$
The long term cost can be expressed as optimal value starting from $2c+au(0)$ withe $N-1$ steps left
$$
\sum_{n=1}^N(y^2(n)+wu^2(n))=V_{N-1}(2c+au(0))
$$
Then
$$
V_N(c)=\min_{u(0)}[c^2+wu^2(0)+V_{N-1}(2c+au(0))]
$$
For the continuous case we have $V(c,T)=c^2r(T)$

It is reasonable to guess that


$$
V_N(c)=c^2r_N\\
c^2r_N=\min_{u(0)}[c^2+wu^2(0)+(2c+au(0))^2r_{N-1}]
$$
The value of $u(0)$ that minimizes is readily obtained by differentiation
$$
2wu(0)+2a(2c+au(0))r_{N-1}=0\\
u(0)=-\frac{2acr_{N-1}}{w+a^2r_{N-1}}
$$
Using this value, we obtain the recurrence relation
$$
r_N=1+\frac{4wr_{N-1}}{w+a^2r_{N-1}}
$$
At each time $t=k$, the input control is
$$
u(k)=-\frac{2ar_{N-k-1}y(k)}{w+a^2r_{N-k-1}}
$$
When $N\rightarrow\infin$, let $r=\lim\limits_{N\rightarrow\infin}r_N$, then $r$ is the positive root of the quadratic equation
$$
r=1+\frac{4wr}{w+a^2r}\\
r=\frac{(a^2+3w)+\sqrt{(a^2+w)(a^2+9w)}}{2a^2}
$$
The control signal will change to:
$$
\lim\limits_{N\rightarrow\infin}u(0)=-\frac{2acr}{w+a^2r}\\
$$
We see that
$$
V(c)=\min_{u(n)}\sum_{n=0}^\infin(y^2(n)+wu^2(n))\\
V(c)=\min_{u(0)}[c^2+wu^2(0)+V(2c+au(0))]\\
V(c)=rc^2
$$
Therefore, for the infinite time process, the optimal feedback controller is:
$$
u(k)=-\frac{2ary(k)}{w+a^2r}
$$


<div STYLE="page-break-after: always;"></div>

## Q.3

Assume that the lifeguard will run to $(a,0)$, and then swim to the swimmer. The parameter we can get from  question: $v_1=8m/s,\;v_2=2m/s$. The optimal function can be expressed as:
$$
J(a)=\min_a[(\frac{\sqrt{a^2+10^2}}{v_1})^2+(\frac{\sqrt{(20-a)^2+(-20)^2}}{v_2})^2]=\min_a[\frac{a^2+10^2}{v_1^2}+\frac{(20-a)^2+20^2}{v_2^2}]
$$
Take the derivative respect to $a$, we get
$$
\frac{2a}{v_1^2}-\frac{2(20-a)}{v_2^2}=0\\
a=\frac{20v_1^2}{v_1^2+v_2^2}=18.823
$$
So, the shortest time path is that lifeguard run to $(18.823,0)$ and then swim to the swimmer. The shortest time is:
$$
t_{min}=\frac{\sqrt{a^2+10^2}}{v_1}+\frac{\sqrt{(20-a)^2+(-20)^2}}{v_2}=12.68s
$$

<div STYLE="page-break-after: always;"></div>

## Q.4

First, we can put all attractions and hotel in the x-y plane and sort them by x coordinate from small to large $p_1,p_2,...,p_n$. Assume that $V_{i,j}\;(i\leqslant j)$ is  the shortest closed curve which contain $p_1,p_2,...,p_j$. This path goes from $p_i$ left to $p_1$, and then goes from $p_1$ right to $p_j$. So, $V_{n,n}$ is what we want in this topic.

Assume that the length of $V_{i,j}$ is $l(i,j)$, the distance between $p_i$ and $p_j$ is $dist(i,j)=\sqrt{(x_i-xj)^2+(y_i-y_j)^2}$

In the path $V_{i,j}$, $p_i$ is in the path $p_i\rightarrow p_1$, $p_j$ is in the path $p_1\rightarrow p_j$. Now, let's talk about the position of $p_{j-1}$

(1) $i<j-1$

Because $p_{j-1}$ is on the right side of $p_i$, so  $p_{j-1}$ is in the path $p_1\rightarrow p_j$. Besides, $p_{j-1}$ is the rightmost point except $p_j$, so it connect to $p_j$ directly. We can get
$$
l(i,j)=l(i,j-1)+dist(j-1,j)
$$
(2) $i=j-1$

In this case, $p_{j-1}$ is $p_i$, so  $p_{j-1}$ is in the path $p_i\rightarrow p_1$. Any point from $p_1,p_2,...,p_{j-2}$ can connect to $p+j$. Assume that point is $p_k(1\leqslant k\leqslant j-2)$. We need to chose an appropriate point $p_k$ so that we can get the shortest $l(i,j)$
$$
l(i,j)=\min_{1\leqslant k\leqslant j-2}[l(k,j-1)+dist(k,j)]
$$
(3)$i=j$

This only happens when $i=j=n$. In this case, $p_{n-1}$ connect to $p_n$, we can get:
$$
l(n,n)=l(n-1,n)+dist(n-1,n)
$$
In conclusion the optimal function is:
$$
l(i,j)=
\begin{cases}
l(i,j-1)+dist(j-1,j),&i<j-1\\
\min_\limits{1\leqslant k\leqslant j-2}[l(k,j-1)+dist(k,j)],&i=j-1\\
l(n-1,n)+dist(n-1,n),&i=j=n
\end{cases}
$$
This function is what we want.

