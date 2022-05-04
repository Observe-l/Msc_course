## Conclusion

In this project, we create a mathematic model of the 4 DOF table cleaning robot.  Based on the D-H parameters, we get the Jacobian matrix and compute the forward and inverse kinematics. Based on theses results, we can calculate the joint drive torque and convert any specific coordinates to the joint angles, so that the endpoint could reach the predetermined destination.

However, the Jacobian matrix could only represent the static joint torque. So in task 3, we use N-E and L-E equation to determine the dynamics model. We our robotic is moving, we can use this equation to calculate the drive torque.

In task 4, we designed a PID controller to implement the trajectory. When we give the a reference trajectory, the controller will control the joint to track it. In the end, the whole system will stable and the closed-loop error will come to 0.

### Difficult 



### Other required technologies

#### Binocular Stereo Vision

Before the trajectory planning, we should know the specifics tasks. In terms of our table cleaning robot, we need to find the clutter on the table and get its coordinates. One of the method is to use the "Binocular Stereo Vision" 

In recent years, binocular stereo vision has been gradually applied to autonomous navigation, engineering surveying and other areas. Distance measurement based on binocular stereo vision is a passive way. Compared with traditional initiative distance measurement methods such as infrared and laser, it has advantages of hidden, safe, simple hardware and so on. However, the software design is more complicated. To obtain the distance information, it needs a series of complex operations to the detected images. Therefore, the focus of the study is on designing a high performance real-time image processing algorithm.

The Binocular Stereo Vision imaging is shown as follow. 

<img src=".\fig\model.png" alt="model" style="zoom:67%;" />

In the above figure, the distance between the two cameras is B. The $P(X,Y,Z)$ in the imaging images of the left and right cameras are $p_l(u_l,v_l)$ and $p_r(u_r,v_r)$, the left and right camera coordinate systems are respectively displayed as $O_lx_ly_l$ and $O_rx_ry_r$. In this fig, $f$ is the focal length of the camera, $Z$ is the distance from point $P$ to our frame origin. $Z$ is given as:
$$
\frac{B-(u_l-u_r)}{B}=\frac{Z-f}{Z}\\
Z=f*\frac{B}{u_l-u_r}
$$
After we get the exactly position, the processor could generate the trajectory to reach the targets and collect them.

#### Trajectory planning

After get the position of the clutter, we need to design a proper trajectory so that the robot manipulate could reach the position. In terms of robot arm trajectory planning, there are two methods: 1) Joint-space based method; 2) Cartesian-space based method

In terms of  joint-space based trajectory planning, there are five steps

**Step one**: Determine the **initial point** and **finial point**, use convolution-based algorithm or some other methods to generate the via point

**Step two**: Use inverse kinematics to calculate all the joint angles on the trace (based on joint-space).

**Step three**: Generate a smooth trajectory to connect all these point

**Step four**: Use forward kinematics to calculate the tool tips cartesian-space coordinates.

**Step five**: Check whether the trajectory proper.

<img src=".\fig\Joint_space.png" alt="Joint_space" style="zoom:67%;" />

In terms of  cartesian-space based trajectory planning, there are four steps

**Step one**: Determine the **initial point** and **finial point**, use convolution-based algorithm or some other methods to generate the via point

**Step two**: Generate a smooth trajectory to connect all these point

**Step three**: Use inverse kinematics to get the tool tips joint-space coordinates.

**Step four**: Check whether the trajectory smoothly.

<img src=".\fig\Cartesian-space.png" alt="Cartesian-space" style="zoom:67%;" />



## Distribution 

| Name       | Distribution     |
| ---------- | ---------------- |
| Jin Yixuan | Task 1, 2 , 4, 5 |
| Liu Weihao | Task 1, 3, 4, 5  |



### Reference

1. Sun, Xiyan, et al. "Distance measurement system based on binocular stereo vision." IOP Conference Series: Earth and Environmental Science. Vol. 252. No. 5. IOP Publishing, 2019.
2. Yang, Lu, et al. "Analysis on location accuracy for the binocular stereo vision system." *IEEE Photonics Journal* 10.1 (2017): 1-16.
3. Gasparetto, Alessandro, and V. Zanotto. "A new method for smooth trajectory planning of robot manipulators." *Mechanism and machine theory* 42.4 (2007): 455-471.
4. Piazzi, Aurelio, and Antonio Visioli. "Global minimum-jerk trajectory planning of robot manipulators." *IEEE transactions on industrial electronics* 47.1 (2000): 140-149.
5. Yang GJ, Delgado R, Choi BW. A Practical Joint-Space Trajectory Generation Method Based on Convolution in Real-Time Control. International Journal of Advanced Robotic Systems. March 2016. doi:10.5772/62722

