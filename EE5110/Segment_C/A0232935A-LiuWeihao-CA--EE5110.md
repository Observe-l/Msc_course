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
0=c_1e^{\sqrt{4+a^2/w}\cdot T}+c_2e^{-\sqrt{4+a^2/w}\cdot T}
$$
Solving, we obtain the expression:
$$
y_o(t)=c(\frac{e^{t-\sqrt{4+a^2/w}\cdot T}+e^{-(t-\sqrt{4+a^2/w}\cdot T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c\frac{cosh(t-\sqrt{4+a^2/w}\cdot T)}{cosh(\sqrt{4+a^2/w}\cdot T)}\\
|y_o(t)-\frac{ce^{-t}}{1+e^{2\sqrt{4+a^2/w}\cdot T}}|\leqslant |c|e^{-\sqrt{4+a^2/w}\cdot T}
$$
Let $T\rightarrow \infin$, We have
$$
y_o(t)=c(\frac{e^{t-\sqrt{4+a^2/w}\cdot T}+e^{-(t-\sqrt{4+a^2/w}\cdot T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c(\frac{e^{t-2\sqrt{4+a^2/w}\cdot T}+e^{-t}}{e^{-2\sqrt{4+a^2/w}\cdot T}+1})\rightarrow ce^{-t}\\
\dot{y}_o(t)=c(\frac{e^{t-\sqrt{4+a^2/w}\cdot T}-e^{-(t-\sqrt{4+a^2/w}\cdot T)}}{e^{-\sqrt{4+a^2/w}\cdot T}+e^{\sqrt{4+a^2/w}\cdot T}})=c(\frac{e^{t-2\sqrt{4+a^2/w}\cdot T}-e^{-t}}{e^{-2\sqrt{4+a^2/w}\cdot T}+1})\rightarrow -ce^{-t}\\
\dot{y}_o(t)=-y_o(t)
$$
So we have the control laws
$$
u(t)=-\frac{2}{a}y(t)+\frac{1}{a}\dot{y}(t)=-\frac{3}{a}y(t)
$$

### b) Dynamic programming

Optimal Value function:
$$
V(c,T)=\min_{y}J(y)\\
J(y)=\int_0^\Delta+\int_\Delta^T=(c^2+\dot{y}^2)\Delta+V(c+\dot{y}\Delta,T-\Delta)+O(\Delta^2)
$$
We can use Taylor series to relate $V(c+\dot{y}\Delta,T-\Delta)$ with $V(c,T)$, $J(y)$ will change to
$$
V(c,T)=\min_\dot{y}[(c^2+\dot{y}^2)\Delta+V(c,T)+\frac{\partial V}{\partial c}\dot{y}\Delta-\frac{\partial V}{\partial T}\Delta+O(\Delta^2)]
$$
Ignoring the higher order terms of $\Delta$, we have
$$
\frac{\partial V}{\partial T}=\min_\dot{y}[(c^2+\dot{y}^2)+\frac{\partial V}{\partial c}\dot{y}]
$$
When $T\rightarrow\infin$, $V(c,T)$ becomes $V(c)$, 
$$
V(c)=\min_\dot{y}[(c^2+\dot{y}^2)\Delta+V(c+\dot{y}\Delta)]+O(\Delta^2)\\
0=\min_\dot{y}[(c^2+\dot{y}^2)+\dot{y}\dot{V}(c)]
$$
Take the derivative respect to $\dot{y}$ gives $2\dot{y}+\dot{V}(c)=0$, so
$$
\dot{y}=-\frac{\dot{V}(c)}{2}\\
\dot{V}^2=4c^2
$$
Since $V(c)\geqslant0$, we see that $V(c)=c^2$, the optimal value can be easily obtained as
$$
\dot{y}=-\frac{\dot{V}(c)}{2}=-c
$$
Since $y(0)=c$, so we have $\dot{y}(0)=-y(0)$. At any time $t$, we will have the control law:
$$
\dot{y}(t)=-y(t)\\
u(t)=-\frac{2}{a}y(t)+\frac{1}{a}\dot{y}(t)=-\frac{3}{a}y(t)
$$
**As we can see, the results from two method are same**

### c) Weight factor

If $w\rightarrow\infin$, the $y_o(t)$ will change to
$$
y_o(t)=c\frac{e^{-t}+e^{t-4T}}{1+e^{-4T}}
$$
If $w\rightarrow0$, the optimal value function will change to
$$
J(y)=\int_0^\infin y^2dt
$$

## Q.2



