# EE5103

## Computer Control Systems

### Liu Weihao A0232935A

<div STYLE="page-break-after: always;"></div>

#### Part 1

The state space can be expressed as:
$$
x(k+1)=x(k)+w(k)\\
y(k)=x(k)+v(k)
$$
The Kalman Filter is given as:
$$
Kf(k)=P(k|k-1)C^T(CP(k|k-1)C^T+R_2)^{-1}\\
K(k)=(AP(k|k-1)C^T)(CP(k|k-1)C^T+R_2)^{-1}\\
\hat{x}(k|k)=\hat{x}(k|k-1)+K_f(k)(y(k)-C\hat{x}(k|k-1))\\
\hat{x}(k+1|k)=A\hat{x}(k|k-1)+Bu(k)+K(k)(y(k)-C\hat{x}(k|k-1))\\
P(k|k)=P(k|k-1)-P(k|k-1)C^T(CP(k|k-1)C^T+R_2)^{-1}CP(k|k-1)\\
P(k+1|k)=AP(k|k-1)A^T-K(k)(CP(k|k-1)C^T+R2)K^T(k)+R_1
$$
The initial condition is $x(0)=5$. Assume that $P(0|-1)=10^5$, we can get:

###### Graph 1, green line: $x(k)$; yellow line: $\hat{x}(k|k)$

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph1.jpg" alt="graph1" style="zoom: 80%;" />

<div STYLE="page-break-after: always;"></div>

###### Graph 2

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph2.jpg" alt="graph2" style="zoom:80%;" />

###### Graph 3

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph3.jpg" alt="graph3" style="zoom:90%;" />

###### Calculate variables

Bias: $\frac{1}{N+1}\sum_{k=0}^{N}{(x(k)-\hat{x}(k|k)}=-0.00249$

Variance: $\frac{1}{N+1}\sum_{k=0}^{N}{(x(k)-\hat{x}(k|k)^2}=0.0986$

<div STYLE="page-break-after: always;"></div>

#### Part 2

The true state position $x_1(k)$ and velocity $x_2(k)$ of a moving target are given by the following equation:
$$
\left[\matrix{x_1(k+1)\\x_2(k+1)}\right]=\left[\matrix{1&T\\0&1}\right]\left[\matrix{x_1(k)\\x_2(k)}\right]+\left[\matrix{\frac{1}{2}T^2\\T}\right]w(k)\\
y(k)=\left[\matrix{1&0}\right]\left[\matrix{x_1(k)\\x_2(k)}\right]+v(k)
$$
The initial contidions are: $x(k)=\left[\matrix{0\\30}\right]$, we can assume that: $P(0|-1)=10^5\times\left[\matrix{1&0\\0&1}\right]$.

Simulate for $k=0,1,...,N$ where $N=10,000$

###### Graph 4, $x_1(k)$: green; $\hat{x}_1(k|k)$: yellow

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph4.jpg" alt="graph4"  />

<div STYLE="page-break-after: always;"></div>

###### Graph 5, $x_2(k)$: green; $\hat{x}_2(k|k)$: yellow

<img src="C:\Users\l_w_h\AppData\Roaming\Typora\typora-user-images\image-20211116025216066.png" alt="image-20211116025216066" style="zoom:80%;" />

###### Graph 6: $P_{11}(k|k)$

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph6.jpg" alt="graph6" style="zoom:80%;" />

<div STYLE="page-break-after: always;"></div>

###### Graph 7: $P_{22}(k|k)$

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph7.jpg" alt="graph7" style="zoom:80%;" />

###### Graph 8: $K_{f1}(k)$

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph8.jpg" alt="graph8" style="zoom:80%;" />

<div STYLE="page-break-after: always;"></div>

###### Graph 9: $K_{f2}(k)$

<img src="E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\graph9.jpg" alt="graph9" style="zoom:80%;" />

###### Calculate variables

The biases
$$
\frac{1}{N+1}\sum_{k=0}^{N}{(x_1(k)-\hat{x}_1(k|k)}=-0.0042\\
\frac{1}{N+1}\sum_{k=0}^{N}{(x_2(k)-\hat{x}_2(k|k)}=0.0014
$$


The variance:
$$
\frac{1}{N+1}\sum_{k=0}^{N}{(x_1(k)-\hat{x}_1(k|k)^2}=0.3452\\
\frac{1}{N+1}\sum_{k=0}^{N}{(x_2(k)-\hat{x}_2(k|k)^2}=0.1290
$$

<div STYLE="page-break-after: always;"></div>

#### Part 3

The target moving in a circle, we can decompose it into $y$ and $z$, caculate the speed and position separately. We can assume that the state $x(k)$ is: $x(k)=\left[\matrix{y(k)\\\dot{y}(k)\\z(k)\\\dot{z}(k)}\right]$, $\dot{y}(k)$ and $\dot{z}(k)$ are the speed in the $y$ and $z$ directions speed. In this case, we can use constant speed module. The whole state-space can be expressed as:
$$
x(k+1)=\left[\matrix{1&T&0&0\\0&1&0&0\\0&0&1&T\\0&0&0&1}\right]x(k)+\left[\matrix{\frac{T^2}{2}\\T\\\frac{T^2}{2}\\T}\right]w(k)\\
y(k)=\left[\matrix{1&0&0&0\\0&0&1&0}\right]x(k)+v(k)
$$
We can assume that, the sampling period $T=0.0005$. The output of Kalman filter are as follows:

![Rp3](E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\Rp3.jpg)

<div STYLE="page-break-after: always;"></div>

###### Graph 10: $K_f(k)$

![Rp3_Kf](E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\Rp3_Kf.jpg)

###### Graph 11: $K(k)$

![Rp3_K](E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\Rp3_K.jpg)

<div STYLE="page-break-after: always;"></div>

###### Graph 12: $P(k|k)$

![Rp3_P](E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\Rp3_P.jpg)

###### Graph 13: P(k+1|k)

![Rp3_Pm](E:\download\OneDrive - National University of Singapore\Desktop\Document\Msc_course\EE5103\project\picture\Rp3_Pm.jpg)

###### Calculate variables

Biases:
$$
\frac{1}{N+1}\sum_{k=0}^N\{10cos\frac{2\pi k}{N}-\hat{x}_y(k|k)\}=2.207\\
\frac{1}{N+1}\sum_{k=0}^N\{10sin\frac{2\pi k}{N}-\hat{x}_z(k|k)\}=-0.9531
$$
Variances
$$
\frac{1}{N+1}\sum_{k=0}^N\{10cos\frac{2\pi k}{N}-\hat{x}_y(k|k)\}^2=38.43\\
\frac{1}{N+1}\sum_{k=0}^N\{10sin\frac{2\pi k}{N}-\hat{x}_z(k|k)\}^2=17.65
$$
