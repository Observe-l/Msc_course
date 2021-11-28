Liu Weihao

A0232935A

## Q1

### a)

The state space is as follow:

$$
\dot{x}=Ax+Bu\\
y=Cx\\
A=\left[\matrix{-1&0\\1&0}\right]
\quad B=\left[\matrix{1\\0}\right]
\quad C=\left[\matrix{0&1}\right]
$$
After sampling, the state space changes into discrete-time form:
$$
x(k+1)=\Phi x(k)+\Gamma u(k)\\
y(k)=Cx(k)\\
\Phi =e^{Ah},\quad\Gamma =\int_0^h{e^{Av}}dvB
$$
We can caculate $\Phi$ and $\Gamma$ via Caley-Hamilton Theorem. The eigenvalues of $A$ are $\lambda_0=-1,\;\lambda_1=0$
$$
\begin{cases}
h(\lambda)=\beta_0+\beta_1 \lambda\\
e^{\lambda_0 h}=\beta_0+\beta_1\lambda_0\\
e^{\lambda_1 h}=\beta_0+\beta_1\lambda_1\\
\end{cases}
\Rightarrow
\begin{cases}
e^{-h}=\beta_0-\beta_1\\
1=\beta_0
\end{cases}
\Rightarrow
\begin{cases}
\beta_0=1\\
\beta_1=1-e^{-h}\\
\end{cases}
$$
So:
$$
\Phi=e^{Ah}=\beta_0I+\beta_1A=
\left[\matrix{e^{-h}&0\\1-e^{-h}&1}\right]\\
\begin{aligned}
\Gamma&=\int_0^h{e^{Av}}dvB\\
&=\int_0^h{\left[\matrix{e^{-v}&0\\1-e^{-v}&1}\right]}dv\left[\matrix{1\\0}\right]\\
&=\left[\matrix{1-e^{-h}\\e^{-h}+h-1}\right]
\end{aligned}
$$
Assuming that $u(k)=-Lx(k)$, using the deadbeat controller:
$$
A_c(\Phi)=\Phi^2=\left[\matrix{e^{-2h}&0\\1-e^{-2h}&1}\right]\\
W_c=\left[\matrix{\Gamma\quad\Phi\Gamma}\right]=\left[\matrix{1-e^{-h}&e^{-h}-e^{-2h}\\e^{-h}+h-1&e^{-2h}-e^{-h}+h}\right]\\
\begin{aligned}
L&=\left[\matrix{0&1}\right]W_c^{-1}A_c(\Phi)\\
&=\left[\matrix{0&1}\right]\left[\matrix{e^{-2h}-e^{-h}+h&e^{-2h}-e^{-h}\\-e^{-h}-h+1&1-e^{-h}}\right]\left[\matrix{e^{-2h}&0\\1-e^{-2h}&1}\right]/det(W_c)\\
&=\left[\matrix{-he^{-2h}-e^{-h}+1&1-e^{-h}}\right]/det(W_c)\\
&=\left[\matrix{\frac{e^{2h}-e^h-h}{h(e^h-1)^2}&\frac{e^h}{h(e^h-1)}}\right]
\end{aligned}
$$

$$
\begin{aligned}
u(k)&=-Lx(k)\\
&=-\left[\matrix{\frac{e^{2h}-e^h-h}{h(e^h-1)^2}&\frac{e^h}{h(e^h-1)}}\right]x(k)
\end{aligned}
$$



### b)

The control signal at k=0 can be expressed as
$$
\begin{aligned}
u(0)&=-Lx(0)\\
&=-\left[\matrix{\frac{e^{2h}-e^h-h}{h(e^h-1)^2}&\frac{e^h}{h(e^h-1)}}\right]\left[\matrix{1\\0.5}\right]\\
&=-\frac{3e^{2h}-3e^{h}-2h}{2h(e^h-1)^2}
\end{aligned}
$$


We want the control signal less than one at k=0, so:
$$
|u(0)|<1\\
|\frac{3e^{2h}-3e^{h}-2h}{2h(e^h-1)^2}|<1\\
h>0\\
\Rightarrow
h>1.74
$$

<div STYLE="page-break-after: always;"></div>

## Q2

Augmented state vector:
$$
z(k)=\left[\matrix{x(k)\\v(k)}\right]\\
z(k+1)=\left[\matrix{x(k+1)\\v(k+1)}\right]=\left[\matrix{\Phi&\Phi_{xv}\\0&\Phi_{v}}\right]z(k)+\left[\matrix{\Gamma\\0}\right]u(k)\\
y(k)=\left[\matrix{C&0}\right]z(k)\\
\Phi=\left[\matrix{0.5&1\\0.5&0.8}\right],\;\Phi_{xv}=\left[\matrix{1\\0}\right],\;\Phi_v=1,\;\Gamma=\left[\matrix{0.2\\0.1}\right],\;C=\left[\matrix{1&0}\right]
$$

### a)

Beacuse the state and $v$ can be measured, assuming that $u(k)=-Lx(k)-L_vv(k)$, 
$$
\begin{aligned}
x(k+1)
&=\Phi x(k)-\Gamma(Lx(k)+L_vv(k))+\Phi_vv(k)\\
&=(\Phi-\Gamma L)x(k)+(\Phi_v-\Gamma L_v)v(k)
\end{aligned}
$$
Deadbeat controller:
$$
A_c(\Phi)=\Phi^2=\left[\matrix{0.75&1.3\\0.65&1.14}\right]\\
W_c=\left[\matrix{\Gamma&\Phi\Gamma}\right]=\left[\matrix{0.2&0.2\\0.1&0.18}\right]\\
\begin{aligned}
L&=\left[\matrix{0&1}\right]W_c^{-1}A_c(\Phi)\\
&=\left[\matrix{0&1}\right]\left[\matrix{0.18&-0.2\\-0.1&0.2}\right]\left[\matrix{0.75&1.3\\0.65&1.14}\right]/det(W_c)\\
&=\left[\matrix{3.4375&6.1250}\right]
\end{aligned}
$$


Then, z-transfor:
$$
zX(z)=(\Phi-\Gamma L)X(z)+(\Phi_v-\Gamma L_v)V(z)\\
X(z)=(zI-\Phi+\Gamma L)^{-1}(\Phi_v-\Gamma L_v)V(z)\\
Y(z)=CX(z)=C(zI-\Phi+\Gamma L)^{-1}(\Phi_v-\Gamma L_v)V(z)=H_v(z)V(z)
$$
If we want to eliminate the influence of $v$, $H_v(1)$ should be 0
$$
\begin{aligned}
H_v(z)&=C(zI-\Phi+\Gamma L)^{-1}(\Phi_v-\Gamma L_v)\\
&=\left[\matrix{1&0}\right](\left[\matrix{z&0\\0&z}\right]-\left[\matrix{0.5&1\\0.5&0.8}\right]+\left[\matrix{0.2\\0.1}\right]\left[\matrix{3.4375&6.1250}\right])^{-1}(\left[\matrix{1\\0}\right]-\left[\matrix{0.2\\0.1}\right]L_v)\\
&=\frac{-80zL_v+24L_v+400z-75}{400z^2}
\end{aligned}
$$

$$
H_v(1)=\frac{-80L_v+24L_v+400-75}{400}=0\\
$$

In concludes, $L=\left[\matrix{3.4375&6.1250}\right]$, $L_v=5.803$, The state space can be expressed as follow:


$$
u(k)=-Lx(k)-L_vv(k)=-\left[\matrix{3.4375&6.1250}\right]x(k)-5.803v(k)\\
\begin{aligned}
\left[\matrix{x(k+1)\\v(k+1)}\right]
&=\left[\matrix{\Phi&\Phi_{xv}\\0&\Phi_{v}}\right]\left[\matrix{x(k)\\v(k)}\right]-\left[\matrix{\Gamma\\0}\right]\left[\matrix{L&L_v}\right]\left[\matrix{x(k)\\v(k)}\right]\\
&=\left[\matrix{\Phi-\Gamma L&\Phi_{xv}-\Gamma L_v\\0&\Phi_{v}}\right]\left[\matrix{x(k)\\v(k)}\right]\\
&=\left[\matrix{-0.1875&-0.2250&-0.1606\\0.1562&0.1875&-0.5803\\0&0&1}\right]\left[\matrix{x(k)\\v(k)}\right]
\end{aligned}
$$

### b)

Build an observe to estimate the disturbance:
$$
\hat{z}(k+1)=\left[\matrix{\Phi&\Phi_{xv}\\0&\Phi_{v}}\right]\hat{z}(k)+\left[\matrix{\Gamma\\0}\right]u(k)+K(y(k)-\hat{y}(k))\\
\hat{y}(k)=C\hat{z}(k)
$$
Put all pols to 0, design a Dead-beat Observer, let $\Phi '=\left[\matrix{\Phi&\Phi_{xv}\\0&\Phi_{v}}\right]$, $C'=\left[\matrix{C&0}\right]$
$$
A_o(\Phi')=\Phi'^3=\left[\matrix{1.025&1.79&2.25\\0.895&1.562&1.15\\0&0&1}\right]\\
W_o=\left[\matrix{C'\\C'\Phi '\\C'\Phi '^2}\right]=\left[\matrix{1&0&0\\0.5&1&1\\0.75&1.3&1.5}\right]\\
K=A_o(\Phi')W_o^{-1}\left[\matrix{0&0&1}\right]^T=\left[\matrix{2.3\\-2.06\\5}\right]\\
$$
Because the disturbance $v$ can not be measured directly, so 
$$
u(k)=-Lx(k)-L_v\hat{v}(k)\\
$$

### c)

The observe is same as **b)**, because only output signal can be measured, the input signal will change to:
$$
u(k)=-L\hat{x}(k)-L_v\hat{v}(k)
$$



<div STYLE="page-break-after: always;"></div>

## Q3

### a)

We can use overshoot and stabilization time:
$$
\begin{cases}
\sigma=e^{-\frac{\pi\zeta}{\sqrt{1-\zeta^2}}}\times100\%\leq10\%\\
t_s\approx\frac{4.6}{\zeta\omega_n}\leq10.0s
\end{cases}
$$

$$
\Rightarrow
\begin{cases}
\zeta\geq0.591\\
\zeta\omega_n\geq0.46
\end{cases}
\Rightarrow
\begin{cases}
\zeta=0.6\\
\omega_n=0.77
\end{cases}
$$

The reference model in the continuous-time is:
$$
H_m(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_ns+\omega_n^2}=\frac{0.593}{s^2+0.924s+0.593}
$$
Then we can get discrete-time transfer function:
$$
\begin{aligned}
H_m(z)
&=(1-z^{-1})Z[\mathscr{L}^{-1}(\frac{G(s)}{s})]\\
&=\frac{z-1}{z}Z[\mathscr{L}^{-1}(\frac{1}{s}\cdot\frac{\omega_n^2}{s^2+2\zeta\omega_ns+\omega_n^2})]\\
&=\frac{z-1}{z}Z[\mathscr{L}^{-1}(\frac{1}{s}+\frac{p_2}{p_1-p_2}\cdot\frac{1}{s-p_1}+\frac{p_1}{p_2-p_1}\cdot\frac{1}{s-p_2})]\\
&=\frac{z-1}{z}(\frac{z}{z-1}+\frac{p_2}{p_1-p_2}\cdot\frac{z}{z-e^{p_1T}}+\frac{p_1}{p_2-p_1}\cdot\frac{z}{z-e^{p_2T}})\\
&=1+\frac{p_2}{p_1-p_2}\cdot\frac{z-1}{z-e^{p_1T}}+\frac{p_1}{p_2-p_1}\cdot\frac{z-1}{z-e^{p_2T}}
\end{aligned}
$$
Because $T=0.1s,\;p_1=-\zeta\omega_n+\omega_n\sqrt{\zeta^2-1},\;p_2=-\zeta\omega_n-\omega_n\sqrt{\zeta^2-1}$, then
$$
H_m(z)=\frac{0.002874z+0.002787}{z^2-1.906z+0.9117}=\frac{B_m(z)}{A_m(z)}
$$

### b)

Because we need to use position control system, the output signal is the position $y(t)$.
$$
\ddot{y}(t)=-\frac{b}{m}\dot{y}(t)+\frac{1}{m}u(t)=-0.1\dot{y}+0.001u(t)\\
x(t)=\left[\matrix{y(t)\\\dot{y}(t)}\right]
$$
The continuous-time state-space is
$$
\dot{x}(t)=\left[\matrix{0&1\\0&-0.1}\right]x(t)+\left[\matrix{0\\0.001}\right]u(t)\\
y(t)=\left[\matrix{1&0}\right]x(t)
$$
Let $A=\left[\matrix{0&1\\0&-0.1}\right],\;B=\left[\matrix{0\\0.001}\right],\;C=\left[\matrix{1&0}\right]$, the discrete-time model is
$$
x(k+1)=\Phi x(k)+\Gamma u(k)\\
y(k)=Cx(k)\\
\Phi=e^{AT}=\left[\matrix{1&10-10e^{-0.01}\\0&e^{-0.01}}\right]=\left[\matrix{1&0.0995\\0&0.990}\right]\\
\Gamma=\int_0^Te^{Av}dvB=\int_0^{0.1}\left[\matrix{1&10-10e^{-0.1v}\\0&e^{-0.1v}}\right]dv\left[\matrix{0\\0.001}\right]=\left[\matrix{4.983\times10^{-6}\\9.95\times10^{-5}}\right]\\
C=\left[\matrix{1&0}\right]
$$

### c)

We need to put poles to $A_m(z)$:
$$
A_m(z)=z^2-1.906z+0.9117\\
A_m(\Phi)=\Phi^2-1.906\Phi+0.9117I=\left[\matrix{0.0057&0.008363\\0&0.004864}\right]\\
W_c=\left[\matrix{\Gamma&\Phi\Gamma}\right]=\left[\matrix{4.983\times10^{-6}&1.488\times10^{-5}\\9.95\times10^{-5}&9.851\times10^{-5}}\right]\\
L=\left[\matrix{0&1}\right]W_c^{-1}A_c(\Phi)=\left[\matrix{572.85&816.02}\right]
$$

### d)

The continuous-time transfer function is
$$
H(s)=\frac{1}{1000s^2+100s}
$$
We can get discrete-time T.F from continuous-time T.F
$$
H(z)=\frac{4.983\times10^{-6}z+4.967\times10^{-6}}{z^2-1.99z+0.99}=\frac{B(z)}{A(z)}
$$
The output signal $Y(z)$ can be expressed:
$$
Y(z)=CX(z)=C(zI-\Phi+\Gamma L)^{-1}H_{ff}(z)U_c(z)=H_{ff}(z)\frac{B(z)}{A_m(z)}U_c(z)\\
H_{ff}(z)=\frac{B_m(z)}{B(z)}=\frac{0.002874z+0.002787}{4.983\times10^{-6}z+4.967\times10^{-6}}=\frac{576.76z+559.3}{z+0.997}
$$

### e)

The observability matrix is:
$$
W_o=\left[\matrix{1&0\\1&0.0995}\right]
$$
$rank(W_o)=2$, so ervey state can be esstimate via output signal. We need to design an Dead-bead Observer.
$$
\hat{x}(k+1)=\Phi x(k)+\Gamma u(k)+K(y(k)-\hat{y}(k))\\
\hat{y}(k)=C\hat{x}(k)\\
A_o(\Phi)=\Phi^2=\left[\matrix{1&0.1980\\0&0.9802}\right]\\
K=A_o(\Phi)W_o^{-1}\left[\matrix{0&1}\right]^T=\left[\matrix{1.990\\9.851}\right]
$$
The input signal is:
$$
U(z)=-L\hat{X}(z)+H_{ff}(z)U_c(z)
$$
