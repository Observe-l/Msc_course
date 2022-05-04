## Project1 - Analysis of the table cleaning robot

This project aims to analyze the Kinematics and Dynamics performance of a table cleaning robot, the design a PID controller to do the trajectory control.

## Files list

- **EE5106_CA2_Pro2.m**

​		This file do the calculation of the forward kinematic matrixes $A_{ii-1}$, the frame rotation matrix $R_{ii-1}$, and Jacobian matrix $J$

- **EE5106_CA2_Pro3.m**

  This file do the calculation of the Matrix $D$, $C$, $G$ in the equation $D\ddot q+C\dot q+G=\tau$

- **EE5106_CA2_Pro3_simu.m**

  This files calculates the positions $q$, velocities $dq$, accelerations $ddq$ of the 3 revolute joints for a given torque.

- **Dynamic_model.m**

  A function file for the **EE5106_CA2_Pro3_simu.m** to call to compute the positions $q$, velocities $dq$, accelerations $ddq$ for each discrete time point.

- **EE5106_CA2_Pro4.slx**

  This files is a Simulink model, which use the computed torque method to do the trajectory control for the reference  				positions, velocities and accelerations with the PID control.

- **figures** folder

  Stores the figures.

