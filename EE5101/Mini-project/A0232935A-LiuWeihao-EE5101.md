[TOC]

<div STYLE="page-break-after: always;"></div>

### Section Ⅰ Introduction 

#### 1.1 Background

​		This is a real control problem in chemical engineering, where we are trying to control the reaction process that takes place in a tank shown in the following figure 1.1. The chemical reaction is described by $A\rightarrow B$. $A$ and $B$ stand for the reactant and product. The reaction is conducted in the large container located at the central of the tank, meanwhile there is water flow inside the surrounded container wall (we call it cooling jacket) to control the reaction temperature.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure1.jpg" alt="figure1" style="zoom:50%;" />

<center><font size=3>Figure 1.1 CSTR reactor</font></center>

​		Our goal is to control the component of the reactant.

#### 1.2 Modeling

​		For model-based control, the first step is to build an effective dynamic model for our target plant, the continuous-flow stirred tank reactor (CSTR) in this project. Define the state vector $x=\left[\matrix{C_a&T&T_j}\right]^T$, where $C_a$ is the component concentration of the reactant, $T$ is the reaction temperature in the tank, and $T_j$ is the temperature of the outflow water of the cooling jacket. Define the control signal $u=\left[\matrix{F&F_j}\right]^T$, where $F$ is the outlet flow rate of the reaction; $F_j$ is the flow rate of the water in the cooling jacket. Define the measurement vector $y=\left[\matrix{T&T_j}\right]^T$, because we only have two temperature sensors. The system is described by
$$
\begin{aligned}
&\dot x=Ax+Bu+Bw\\
&y=Cy
\end{aligned}\tag{1-1}\label{1-1}
$$
My matriculation number is A023935A, then $a=2,\;b=9,\;c=3,\;d=5$, so:
$$
A=\left[\matrix{-1.7&-0.25&0\\23&-30&20\\0&-490&-1140}\right]\\
B=\left[\matrix{5&0\\-83&0\\0&-770}\right]\\
C=\left[\matrix{0&1&0\\0&0&1}\right]\\
$$
The initial condition of the system is assumed to be
$$
x_0=\left[\matrix{1&100&200}\right]^T\\
$$

<div STYLE="page-break-after: always;"></div>

### Section Ⅱ  Control System Design

#### 2.1 Design specifications

The transient response performance specifications for all the outputs $y$ in state space model $\eqref{1-1}$ are as follows:

​		1) The overshot is less than $10\%$.

​		2) The $2\%$ setting time is less than 30 seconds.

​		Consider a standard second-order system:
$$
H(s)=\frac{\omega_n^2}{s^2+2\zeta \omega_ns+\omega_n^2}\tag{2-1}\label{2-1}
$$
​		Its two poles determine performance completely. According to the transient response performance specifications, we can get:
$$
\begin{cases}
M_p=e^{\frac{-\pi\zeta}{\sqrt{1-\zeta^2}}}\leqslant10\%\\
t_s=\frac{4.0}{\zeta\omega_n}\leqslant30\;s
\end{cases}\tag{2-2}\label{2-2}
$$
​		By solving $\eqref{2-2}$, we can get $\zeta>0.59,\;\zeta\omega_n\geqslant0.133$. We can choose:
$$
\begin{cases}
\zeta=0.65\\
\omega_n=0.25
\end{cases}
$$
​		The poles of the reference model are: 
$$
s=-0.1625\;\pm\;0.19i
$$

#### 2.2 Pole Placement

##### 2.2.1 Controller Design

​		Assume that we can measure all the three state variables. I need to design a state feedback controller via pole placement. Because state space $\eqref{1-1}$ is a three-order system, we can choose a poles far from the dominant poles. The desired poles are: $s_1=-0.1625+0.19i,\;s_2=-0.1625-0.19i,\;s_3=-0.64$. The determinate of the closed-loop matrix is
$$
det(sI-A_d)=(s-s_1)(s-s_2)(s-s_3)\tag{2-3}\label{2-3}
$$
​		We can get closed-loop matrix form $\eqref{2-3}$
$$
A_d=\left[\matrix{0&1&0\\0&0&1\\s_1s_2s_3&-(s_1s_2+s_1s_3+s_2s_3)&s_0+s_1+s_2}\right]=\left[\matrix{0&1&0\\0&0&1\\-0.04&-0.2705&-0.965}\right]\tag{2-4}\label{2-4}
$$
​		Then, we need to obtain the controllable canonical form of this system. First, we need to compute the controllability matrix:
$$
\begin{aligned}
W_c&=\left[\matrix{B&AB&A^2B}\right]\\
&=\left[\matrix{b_1&b_2&Ab_1&Ab_2&A^2b_1&A^2b_2}\right]\\
&=\left[\matrix{5&0&12.25&0&-672.08&3850\\
-83&0&2605&-15400&735531.7&18018000\\
0&-770&40670&877800&-47640250&-993146000}\right]
\end{aligned}\tag{2-5}\label{2-5}
$$
​		Because $rank(W_c)=3$, the system is controllable, and the transformation matrix $T$  exists. We can select 3 independent vectors form $\eqref{2-4}$ in the order from left to right. And group them in a matrix $E$ in the following form:
$$
E=\left[\matrix{b_1&Ab_1&b_2}\right]=\left[\matrix{5&12.25&0\\-83&2605&0\\0&40670&-770}\right]\tag{2-6}\label{2-6}
$$
​		Once we have the matrix $E$, we need to compute the inverse of $E$. Because there are two vectors are associated with $u_1$, one vector is associated with $u_2$, we can get $d_1=2,\;d_2=1$. We need to chose  the second and third rows of $E^{-1}$, then we can get transformation matrix $T$ 
$$
T=\left[\matrix{q_2^T\\q_2^TA\\q_3^T\\}\right]=\left[\matrix{0.0059&0.0004&0\\-0.0019&-0.0122&0.0071\\0.3122&0.0188&-0.0013}\right]\tag{2-7}\label{2-7}
$$
​		The matrix $\bar{A}$ and $\bar B$ can be expressed as
$$
\bar A=TAT^{-1},\;\bar B=TB\tag{2-8}\label{2-8}
$$
​		Then we need to design the feedback gain matrix for the controllable canonical form.
$$
\bar K=\left[\matrix{\bar k_{11}&\bar k_{12}&\bar k_{13}\\\bar k_{21}&\bar k_{22}&\bar k_{23}}\right]
$$
​		Next step, we need to compare $\bar A-\bar B\bar K$ and $A_d$, and equalize them. By solving this equation, we can get $\bar K$, and the feedback matrix $K$
$$
K=\bar KT=\left[\matrix{0.5236&-3.0940&1.8245\\0.2028&0.0090&1.8573}\right]\tag{2-9}\label{2-9}
$$
​		The controller can be expressed as:
$$
u=-Kx+Ir
$$

##### 2.2.2 Simulate

​		The initial state is $x_0$,  we can use Simulink to simulate the designed system. My simulate module is showed in the following figure 2.1.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-1.jpg" alt="figure2-1" style="zoom:40%;" />

<center><font size=3>Figure 2.1 Pole placement module</font></center>

​		All the three state responses to non-zero initial state $x_0$ with zero external inputs are shown in figure 2.2. The control signal is shown in figure 2.3. The desired poles are: $s_1=-0.1625+0.19i,\;s_2=-0.1625-0.19i$.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-2.jpg" alt="figure2-2" style="zoom:50%;" />

<center><font size=3>Figure 2.2 State response</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-3.jpg" alt="figure2-3" style="zoom:48%;" />

<center><font size=3>Figure 2.3 Control signal</font></center>

​		If we increase $\omega_n$ and $\zeta$ at the same time,  the real part part of the pole will goes away from original. The setting time of the system will be shorter and the input signal will be larger. If we decrease A and B, we get the opposite result. Simulation results are shown in the figure below.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-4-a.jpg" alt="figure2-4-a" style="zoom:50%;" />

<center><font size=3>Figure 2.4 Increase &zeta; from 0.65 to 0.7 </font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-5-a.jpg" alt="figure2-5-a" style="zoom:50%;" />

<center><font size=3>Figure 2.5 Decrease &zeta; form 0.65 to 0.6</font></center>

#### 2.3 LQR Controller

##### 2.3.1 Controller Design

​		Assume that we can measure all the three state variables, we need to design a state feedback controller using the LQR method. Assume that the matrix $Q$ and $R$ is:
$$
Q=\left[\matrix{10&0&0\\0&500&0\\0&0&1000}\right]\\
R=\left[\matrix{0.1&0\\0&100}\right]
$$
​		Then we need minimize the following quadratic cost function.
$$
J=\frac{1}{2}\int_0^\infin{(x^TQx+u^TRu)dt}\tag{2-10}\label{2-10}
$$
​		The optimal control law turns out to be in the form of linear state feedback:
$$
u=-Kx\tag{2-11}\label{2-11}
$$
​		Let's try the Lyapunov method this time. Let's define Lyapunov function
$$
V(x)=x^TPx\tag{2-12}\label{2-12}
$$
​		where $P$ is a positive definite matrix. $P>0$. And we will find out an equation for $P$ such that
$$
\frac{dV(x)}{dt}\leqslant0\\
\frac{dV(x)}{dt}=x^T(A^TP+PA+Q-PBR^{-1}B^TP)x+(B^TPx+Ru)^TR^{-1}(B^TPx+Ru)-x^TQx-u^TRu\tag{2-13}\label{2-13}
$$
​		In order to make the first term on the RHS to be zero, we choose $P$ such that
$$
A^TP+PA+Q=PBR^{-1}BP\tag{2-14}\label{2-14}
$$
​		We can use systematic way of eigenvalue-eigenvector based algorithm to solve the $ARE$ equation. First, let define a $2n\times2n$ matrix:
$$
\Gamma=\left[\matrix{A&-BR^{-1}B^T\\-Q&-A^T}\right]=\left[\matrix{-1.7&-0.25&0&-250&4150&0\\23&-30&20&4150&-68890&0\\0&-490&-1140&0&0&-5929\\-10&0&0&1.7&-23&0\\0&-500&0&0.25&30&490\\0&0&-1000&0&-20&140}\right]\tag{2-15}\label{2-15}
$$
​		Then, let the eigenvector of $\Gamma$ corresponding to stable $\lambda_i,\;i=1,2,3$.
$$
\left[\matrix{v\\\mu}\right]=\left[\matrix{-0.0591&0.0755&-0.0182\\0.9865&0.0041&0.2997\\0.1269&-0.0013&0.9245\\0&0.9953&0\\0.0829&0.06&0.0123\\0.0185&0&0.2345}\right]\\
P=\mu v^{-1}=\left[\matrix{13.1426&0.7872&0.0041\\0.7872&0.1330&-0.0143\\0.0041&-0.0143&0.2584}\right]\tag{2-16}\label{2-16}
$$
​		We can get the feedback matrix $K$:
$$
K=-R^{-1}B^TP=\left[\matrix{3.7776&-71.0203&12.0312\\-0.0313&0.1097&-1.9896}\right]\tag{2-17}\label{2-17}
$$
​		The controller can be expressed as:
$$
u=-Kx+Ir
$$

##### 2.3.2 Simulate

The initial state is $x_0$,  we can use Simulink to simulate the designed system. My simulate module is showed in the following figure 2.6.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-1.jpg" alt="figure2-1" style="zoom:50%;" />

<center><font size=3>Figure 2.6 LQR module</font></center>

​		All the three state responses to non-zero initial state $x_0$ with zero external inputs are shown in figure 2.7. The control signal is shown in figure 2.8. The $Q$ and $R$ matrix are:

 $Q=\left[\matrix{10&0&0\\0&500&0\\0&0&1000}\right],\;R=\left[\matrix{0.1&0\\0&100}\right]$.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-7.jpg" alt="figure2-7" style="zoom:50%;" />

<center><font size=3>Figure 2.7 State response</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-8.jpg" alt="figure2-8" style="zoom:50%;" />

<center><font size=3>Figure 2.8 Control signal</font></center>

​		If we increase the number in $Q$,  The setting time of the system will be shorter and the input signal will be larger. If we increase the number in $R$, The setting time of the system will be longer and the input signal will be smaller. Three number in matrix $Q$ corresponds to three state separately. Similarly, two number in matrix $R$ corresponds to two input signal separately. Simulation results are shown in the figure below.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-9-a.jpg" alt="figure2-9-a" style="zoom:50%;" />


<center><font size=3>Figure 2.9 increace Q<sub>11</sub> from 10 to 50 </font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-10-b.jpg" alt="figure2-10-b" style="zoom:50%;" />


<center><font size=3>Figure 2.10 increace R<sub>11</sub> from 0.1 to 10 </font></center>

#### 2.4 State observer

##### 2.4.1 Observer Design

​		In this task we still use LQR controller. Because LQR need state feedback, but we can only measure two of them. We should design an observer to estimate the other state. Here, I choose reduce-order observer to complete this task. Let $\xi = Tx $, so that $\hat x=\left[\matrix{C\\T}\right]^{-1}\left[\matrix{y\\\xi}\right]$. The estimation error $e$ and $\xi$ can be expressed as:
$$
\dot\xi=D\xi+Eu+Gy\\
e=\xi-Tx\tag{2-18}\label{2-18}
$$
​		In this system, $d$ is a scalar。 Let $d=-3,\;T=\left[\matrix{t_1&t_2&t_3}\right],\;G=\left[\matrix{g_1&g_2}\right]$, we need to design $T$ and $G$, so that
$$
dT-TA+GC=0\\
T=(A-dI)^{-1}GC
\tag{2-19}\label{2-19}
$$
Let $G=\left[\matrix{10&20}\right]$, then we can get $T=\left[\matrix{0.7831&-0.0443&-0.0184}\right]$. The matrix $\left[\matrix{C\\T}\right]$ is nosingular. $E=TB=\left[\matrix{7.5894&14.1439}\right]$. The observer is thus determined as
$$
\dot\xi=-3\xi+\left[\matrix{7.5894&14.1439}\right]u+\left[\matrix{10&20}\right]y\tag{2-20}\label{2-20}
$$
​		Then reconstruct the state variables from the plant's output and the observer's output as:
$$
\hat x=\left[\matrix{0&1&0\\0&0&1\\0.7831&-0.0443&-0.184}\right]^{-1}\left[\matrix{y(t)\\\xi (t)}\right]=\left[\matrix{0.0565&0.0235&1.2770\\1&0&0\\0&1&0}\right]\left[\matrix{y(t)\\\xi (t)}\right]\tag{2-21}\label{2-21}
$$

##### 2.4.2 Simulate

​		The initial state is $x_0$,  we can use Simulink to simulate the designed system. My simulate module is showed in the following figure 2.11.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-11.jpg" alt="figure2-11" style="zoom:50%;" />

<center><font size=3>Figure 2.11 Reduce-order observer</font></center>

​		The estimation error is shown in figure 2.12

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-12.jpg" alt="figure2-12" style="zoom:50%;" />

<center><font size=3>Figure 2.12 Estimation error</font></center>

​		If we increase $D$, the estimation error will go to zero much faster. Otherwise, it will slower

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-13.jpg" alt="figure2-13" style="zoom:50%;" />

<center><font size=3>Figure 2.13 d=-30</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-14.jpg" alt="figure2-14" style="zoom:50%;" />

<center><font size=3>Figure 2.14 d=-1</font></center>

#### 2.5 Decoupling  Controller

##### 2.5.1 Controller Design

​		In this task, we need to design a decoupling controller with closed-loop stability. $c_i^T$ represents the $i$ rows of the matrix $C$. Because $c_1^TB=\left[\matrix{-80&0}\right],\;c_2^TB=\left[\matrix{0&-770}\right]$, $\sigma_1=1,\;\sigma_2=1$. The transfer function can be written as
$$
G(s)=\left[\matrix{s^{-\sigma_1}&0\\0&s^{-\sigma_2}}\right][B^*+C^{**}(sI-A)^{-1}B]\\
H(s)=C[I+K(sI-A)^{-1}B]^{-1}F\tag{2-22}\label{2-22}
$$
​		Where $B^*=\left[\matrix{c_1^TB\\c_2^TB}\right]=\left[\matrix{-80&0\\0&-770}\right]$, and we can place two poles, $s_1=-3,\;s_2=-10$, so $\phi_{f_1}=s+3,\;\phi_{f_2}=s+10$, then we can calculate $C^{**},\;F$ and $K$
$$
C^{**}=\left[\matrix{c_1^T(A+3I)\\c_2^T(A+10I)}\right]=\left[\matrix{23&-27&20\\0&-490&-1130}\right]\\
K=(B^*)^{-1}C^{**}=\left[\matrix{-0.2771&0.3253&-0.2410\\0&0.6364&1.4675}\right]\\
F=(B^*)^{-1}=\left[\matrix{-0.0120&0\\0&-0.0013}\right]
\tag{2-23}\label{2-23}
$$
​		Take $\eqref{2-23}$ into $\eqref{2-22}$, we can get:
$$
H(s)=\left[\matrix{\frac{1}{s+3}&0\\0&\frac{1}{s+10}}\right]
$$
​		And the eigenvalue of $A-BK$ is: $s_1=-0.3145,\;s_2=-3,\;s_3=-10$, all of them are negative, so the system is internally stable.

##### 2.5.2 Simulate

​		My simulate module is shown in the following figure:

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-15.jpg" alt="figure2-15" style="zoom:50%;" />

<center><font size=3>Figure 2.15 Decoupling controller</font></center>

​		The step response  with zero initial states are as follow:

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-16.jpg" alt="figure2-16" style="zoom:50%;" />

<center><font size=3>Figure 2.16 Step response(u=[1 0]<sup>T</sup>)</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-17.jpg" alt="figure2-17" style="zoom:50%;" />

<center><font size=3>Figure 2.17 Step response(u=[0 1]<sup>T</sup>)</font></center>

​		The initial response with respect to $x_0$ is as follow:

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-18.jpg" alt="figure2-18" style="zoom:50%;" />

<center><font size=3>Figure 2.18 Initial response</font></center>

#### 2.6 Servo Controller

##### 2.6.1 Controller Design

​		In an application, the operating set point for the two output is $y_{sp}=[100,150]^T$, and we can only measure the output. The step disturbance $w=[-2,5]^T$ take effect from time $t_d=10\;s$ afterwards. Let 
$$
v(t)=\int_0^t{e(\tau)d\tau}\\
\dot v(t)=e(t)=r-y(t)=r-Cx(t)
\tag{2-24}\label{2-24}
$$
​		Equation $\eqref{1-1}$ and $\eqref{2-24}$ form an augmented system:
$$
\left[\matrix{\dot x\\\dot v}\right]=\left[\matrix{A&0\\-C&0}\right]\left[\matrix{\dot x\\\dot v}\right]+\left[\matrix{B\\0}\right]u+\left[\matrix{B\\0}\right]w+\left[\matrix{0\\I}\right]r
\tag{2-25}\label{2-25}
$$

$$
\dot{\bar x}=\bar A\bar x+\bar Bu+\bar Bw+\bar B_rr\\
y=\left[\matrix{C&0}\right]\left[\matrix{x\\v}\right]
\tag{2-26}\label{2-26}
$$

​		The rank of the controllability matrix is
$$
rank\left(\matrix{A&B\\-C&0}\right)=5
$$
​		So, the augmented system is controllable. Then we can use LQR to get the feedback gain $K$. Let $Q=diag(10,10,10,15,15),\;R=diag(10,10)$, then calculate $K$ via equation $\eqref{2-15},\;\eqref{2-16}$ and $\eqref{2-17}$.
$$
K=\left[\matrix{0.2968&-0.7036&0.0017&1.1640&-0.3811\\-0.1162&0.0088&-0.3068&0.3811&1.1640}\right]
$$

<div STYLE="page-break-after: always;"></div>

$$
u=-K\bar x=-\left[\matrix{K_1&K_2}\right]\left[\matrix{x\\v}\right]
\tag{2-27}\label{2-27}
$$



​		And because we can not get the state $x$ directly, we need to design a observer to estimate $x$. We can use full-order observer to estimate the state. The observer can be expressed as:
$$
\dot{\hat x}(t)=A\hat x(t)+Bu(t)+Bw(t)+L(y-\hat y)\\
\hat y=C\hat x
\tag{2-28}\label{2-28}
$$
​		The poles of the controller are the eigenvalue of $A-BK_1,\;s_1=-1.57,\;s_2=-97.61,\;s_3=-1368.6$,  we can choose the observer 3-5 times faster than controller poles, let $s_1=-5,\;s_2=s_3=-10$. We need to put these poles to $A-LC$, which has a similar form with $A-BK$. Because $(A-LC)^T=A^T-C^TL^T$, we can calculating $L^T$ by using equation $\eqref{2-6}, \eqref{2-7}, \eqref{2-8}$ and $\eqref{2-9}$.
$$
L^T=\left[\matrix{0.7452&-31.7&-491\\-13.30&200&-1115}\right]\\
L=\left[\matrix{0.7452&-13.30\\-31.7&200\\-491&-1115}\right]\\
$$

##### 2.6.2 Simulate

​		My simulate module is shown in the following figure.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-19.jpg" alt="figure2-19" style="zoom:50%;" />

<center><font size=3>Figure 2.19 Servo controller and full-order observer</font></center>

​		The control signal, output signal and the estimation is shown in the following figures.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-20.jpg" alt="figure2-20" style="zoom:50%;" />

<center><font size=3>Figure 2.20 Control signal</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-21.jpg" alt="figure2-21" style="zoom:50%;" />

<center><font size=3>Figure 2.21 Output signal</font></center>

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-22.jpg" alt="figure2-22" style="zoom:50%;" />

<center><font size=3>Figure 2.22 Estimation error</font></center>

#### 2.7 Minimize objective function

​		If the set point is $x_{sp}=[5,\;250,\;300]^T$, we can not achieve this point at steady. Because all the state can be measured, let $C_1=I$, the state space will change to
$$
\dot x=Ax+Bu\\
y=C_1x
$$
Let
$$
x^*=\lim_{t\rightarrow\infin}{x(t)}\\
u^*=\lim_{t\rightarrow\infin}{u(t)}\\
\tag{2-29}\label{2-29}
$$
​		For asymptomatic tracking, $x^*$ and $u^*$ must satisfy the equation
$$
\left[\matrix{A&B\\C_1&0}\right]\left[\matrix{x^*\\u^*}\right]=\left[\matrix{0\\I}\right]y_d
\tag{2-30}\label{2-30}
$$
​		Equation $\eqref{2-30}$ can be solved uniquely for $\left[\matrix{x^*\\u^*}\right]$ if ant only if $\left[\matrix{A&B\\C_1&0}\right]$ is nonsingular. But the matrix $\left[\matrix{A&B\\C&0}\right]$ is not square matrix, we can not solve the equation $\eqref{2-30}$.

​		Then, let minimize the following objective function:
$$
J(x_s)=\frac{1}{2}(x_s-x_{sp})^TW(x_s-x_{sp})
\tag{2-31}\label{2-31}
$$
​		Where $W=diag(12,7,10)$. When the system is stable, $\dot x$ will be zero. Let $x=-Kx+Fr$, where $F$ is a Identity matrix, $K$ is the feedback matrix from $\eqref{2-17}$
$$
\dot x_s=(A-BK)x_s+Br=0\\
$$

$$
x_s=(BK-A)^{-1}Br
\tag{2-32}\label{2-32}
$$

​		Let take $\eqref{2-32}$ into $\eqref{2-31}$, the equation will change to 
$$
J(r)=\frac{1}{2}((BK-A)^{-1}Br-x_{sp})^TW((BK-A)^{-1}Br-x_{sp})
\tag{2-33}\label{2-33}
$$
​		Where $r=[r_1\;r_2]^T$, if we want minimize this function, the following equation should be zero
$$
\frac{dJ}{dr_1}=0\\
\frac{dJ}{dr_2}=0
\tag{2-34}\label{2-34}
$$
​		Then the matrix $r$ can be obtained: $r=[-9589.8\;-1126.3]^T$ . The simulation result is shown in following figure.

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5101\Mini-project\graph\figure2-23.jpg" alt="figure2-23" style="zoom:50%;" />

<center><font size=3>Figure 2.23 Output signal</font></center>

<div STYLE="page-break-after: always;"></div>

### Section Ⅲ Conclusion

​		In this project, we design the controller via different methods to satisfy the design specifications. First, we calculate the desired poles which satisfy the transient response performance: 1) The overshoot is less than 10%; 2) The 2% setting time is less than 30 seconds. 

​		In task 1, we use pole place method design the controller. And discuss the effects if the position of the poles on system performance. If the real part of the domain poles goes away from original. The setting time of the system will be shorter and the input signal will be larger.

​		In task 2, we use LQR method design the controller, and design the weight matrix $Q$ and $R$. After that, we discuss the effects of weighting $Q$ and $R$. If we increase the number in $Q$,  The setting time of the system will be shorter and the input signal will be larger. If we increase the number in $R$, The setting time of the system will be longer and the input signal will be smaller.

​		In task 3, we design a reduce-order observer, and investigate the effects of observer poles.  If the real part of the domain poles goes away from original, the estimation error will go to zero much faster. Otherwise, it will slower.

​		In task 4, we design a decoupling controller with closed-loop stability. Because all the eigenvalues of $A-BK$ are negative, the system is internally stable.

​		In task 5, we use servo controller to achieve the set point $y_{sp}=[100,150]^T$. Because we can only measure two of the state, we design a state observer also.

​		In task 6, we want the state will go to $x_{sp}=[5,250,300]^T$ at steady state, and prove that is impossible. So we try to minimize to function $J(x_s)$.

<div STYLE="page-break-after: always;"></div>

### Appendices

Matlab code:

**Task 1: Pole Placement**

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File:Q1_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];
omega_n=0.24;
zeta=0.6;
s0=-zeta*omega_n-omega_n*sqrt(zeta^2-1);
s1=-zeta*omega_n+omega_n*sqrt(zeta^2-1);
s2=-0.64;
s=[s0,s1,s2];

b1=B(:,1);
b2=B(:,2);
Wc=[B,A*B,A^2*B];
%choose b1,A*b1,b2
C_1=[b1,A*b1,b2];
C_t=inv(C_1);
%d1=2,d2=1,T=[q2;q2*A;q3]
q2=C_t(2,:);
q3=C_t(3,:);
T=[q2;q2*A;q3];
Aba=T*A/T;
Bba=T*B;
Ad=[0,1,0;0,0,1;s0*s1*s2,-(s0*s1+s0*s2+s1*s2),s0+s1+s2];
% Ad=[s2,0,0;0,0,1;0,-(s0*s1),s0+s1];
Kba=Bba\(Aba-Ad);
K=Kba*T;
```

<div STYLE="page-break-after: always;"></div>

**Task 2: LQR controller **

``` matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q2_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];

qq=[10,500,1000];
rr=[0.1,100];
Q=diag(qq);
R=diag(rr);
Gamma=[A,-B/R*B';-Q,-A'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:3,i);
        mu(:,k)=x(4:6,i);
        k=k+1;
    end
end
P=mu/v;
K=R\B'*P;
```

<div STYLE="page-break-after: always;"></div>

**Task 3: Reduce-order Observer **

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q3_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];

qq=[10,500,1000];
rr=[0.1,100];
Q=diag(qq);
R=diag(rr);
Gamma=[A,-B/R*B';-Q,-A'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:3,i);
        mu(:,k)=x(4:6,i);
        k=k+1;
    end
end
P=mu/v;
K=R\B'*P;

d=-3;
G=[10,20];
left=A-d*eye(3);
right=G*C;
T=right/left;
E=T*B;
zeta=inv([C;T]);
```

<div STYLE="page-break-after: always;"></div>

**Task 4: Decoupling System **

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q4_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];

C1T=C(1,:);
C2T=C(2,:);

s0=-3;
s1=-10;

B_s=[C1T*B;C2T*B];
C_s=[C1T*A;C2T*A];
C_ss=[C1T*(A-s0*eye(3));C2T*(A-s1*eye(3))];
K=B_s\C_ss;
F=inv(B_s);
H=C*(s*eye(3)-(A-B*K))^(-1)*B*F;

[x,y]=eig(A-B*K)
```

<div STYLE="page-break-after: always;"></div>

**Task 5: Servo Control**

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q5_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
BB=[B,B];
x0=[1;100;200];

Abar=[A,zeros(3,2);-C,zeros(2,2)];
Bbar=[B;zeros(2,2)];

qq=[10,10,10,15,15];
rr=[10,10];
Q=diag(qq);
R=diag(rr);
Gamma=[Abar,-Bbar/R*Bbar';-Q,-Abar'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:5,i);
        mu(:,k)=x(6:10,i);
        k=k+1;
    end
end
P=mu/v;
K=R\Bbar'*P;

s0=-5;
s1=-10;
s2=-10;

At=A';
Ct=C';

b1=Ct(:,1);
b2=Ct(:,2);
Wc=[Ct,At*Ct,At^2*Ct];
%choose b1,A*b1,b2
C_1=[b1,At*b1,b2];
C_t=inv(C_1);
%d1=2,d2=1,T=[q2;q2*A;q3]
q2=C_t(2,:);
q3=C_t(3,:);
T=[q2;q2*At;q3];
Aba=T*At/T;
Bba=T*Ct;
Ad=[0,1,0;0,0,1;s0*s1*s2,-(s0*s1+s0*s2+s1*s2),s0+s1+s2];
Lba=Bba\(Aba-Ad);
Lt=Lba*T;
L=Lt';
```

<div STYLE="page-break-after: always;"></div>

**Task 6: Minimize objective function**

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q6_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
x0=[1;100;200];
W=diag([2+9+1,3+4,5+5]);

syms r1 r2

qq=[10,500,1000];
rr=[0.1,100];
Q=diag(qq);
R=diag(rr);
Gamma=[A,-B/R*B';-Q,-A'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:3,i);
        mu(:,k)=x(4:6,i);
        k=k+1;
    end
end
P=mu/v;
K=R\B'*P;

R=[r1;r2];
Xs=(B*K-A)\B*R;
Xsp=[5;250;300];
J=0.5*(Xs-Xsp)'*W*(Xs-Xsp);
J1=diff(J,r1);
J2=diff(J,r2);
[R1,R2]=vpasolve([J1==0, J2==0],[r1,r2]);
R=[R1;R2];
```

