### 1. Login the VM in broswer

![image-20211219162647729](/home/lwh/.config/Typora/typora-user-images/image-20211219162647729.png)

### 2. Setting the password

``` shell
$ sudo su
$ passwd <username>
```

### 3. Then enable password login

```shell
$ nano /etc/ssh/sshd_config
```

Search for *PasswordAuthentication* and set the option to *no* to disable *PasswordAuthentication* method and *yes* to enable.

``` shell
PasswordAuthentication yes
```



![image-20211219163648661](/home/lwh/.config/Typora/typora-user-images/image-20211219163648661.png)

Note: 

ctrl-o: save the file

ctrl-x: exit the file

### 4. Enable sudo authority

``` shell
$ nano /etc/sudoers
```

add the user to the sudo group 

Note: change "hitliuweihao" to your user name

```shell
hitliuweihao ALL=(ALL:ALL) ALL
```



![image-20211219164410899](/home/lwh/.config/Typora/typora-user-images/image-20211219164410899.png)

### 5. Reboot VM

```shell
$ reboot
```

