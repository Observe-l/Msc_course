Liu Weihao

A0232935A

## Q1

### a)

$$
H(z)=\frac{z+0.8}{z^2-1.5z+0.5}=\frac{B(z)}{A(z)}
$$

The zero is stable, we want wo cancel it, let $R(z)=z+0.8,\;S(z)=s_0z+s_1,\;A_o(z)=B(z)=z+0.8$
$$
A(z)R(z)+B(z)S(z)=A_m(z)A_o(z)\\
(z^2-1.5z+0.5)(z+0.8)+(z+0.8)(s_0z+s_1)=(z+0.8)(z^2-1.8z+0.9)\\
z^2+(s_0-1.5)z+s_1+0.5=z^2-1.8z+0.9\\
\Rightarrow
\begin{cases}
s_0-1.5=-1.8\\
s_1+0.5=0.9
\end{cases}\\
\Rightarrow
\begin{cases}
s_0=-0.3\\
s_1=0.4
\end{cases}
$$
$$
\frac{Y(z)}{U_c(z)}=\frac{T(z)B(z)}{A(z)R(z)+B(z)S(z)}=\frac{T(z)B(z)}{A_m(z)A_o(z)}=\frac{T(z)}{A_m(z)}
$$

Besides, the steady-state gain should be one, and the zero has been canceled, so
$$
\frac{T(1)}{A_m(1)}=1\\
T(z)=A_m(1)=0.1\\
$$
The controller can be expressd as
$$
(q+0.8)u(k)=0.1u_c(k)-(-0.3q+0.4)y(k)
$$

### b)

Cause we don't need cancel zero, so let $R(z)=z+r_1,\;S(z)=s_0z+s_1,\;A_o(z)=z$,
$$
A(z)R(z)+B(z)S(z)=A_m(z)A_o(z)\\
(z^2-1.5z+0.5)(z+r_1)+(z+0.8)(s_0z+s_1)=z(z^2-1.8z+0.9)\\
z^3+(r_1-1.5+s_0)z^2+(0.5-1.5r_1+0.8s_0+s_1)+(0.5r_1+0.8s_1)=z^3-1.8z^2+0.9z\\
\Rightarrow\begin{cases}
r_1-1.5+s_0=-1.8\\
0.5-1.5r_1+0.8s_0+s_1=0.9\\
0.5r_1+0.8s_1=0
\end{cases}\\
\Rightarrow\begin{cases}
r_1=-0.219\\
s_0=-0.0812\\
s_1=0.137
\end{cases}
$$
The steady-state gain should be one, and we want to decrease the order of process
$$
\begin{cases}
T(z)=t_oA_o(z)\\
\frac{T(1)B(1)}{A_m(1)A_o(1)}=1\\
\end{cases}\\
$$

$$
\Rightarrow T(z)=0.0556z\\
\frac{Y(z)}{U_c(z)}=\frac{T(z)B(z)}{A_m(z)A_o(z)}=\frac{0.0556z+0.04448}{z^2-1.8z+0.9}\\
$$

The controller can be expressed as:
$$
(q-0.219)u(k)=0.0556qu_c(k)-(-0.0812q+0.137)y(k)
$$

### c)

Use MATLAB to simulate the input signal and output signal.



![image-20210929193751499](/home/lwh/.config/Typora/typora-user-images/image-20210929193751499.png)

As we can see, after we cancele the process zero, the response is slowly than

## Q2

### a)

