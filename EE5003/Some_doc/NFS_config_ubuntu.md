## This is a configure guide for Ubuntu system

### 1. Install NFS library

Open terminal, install nfs library

``` shell
$ sudo apt-get install nfs*
```

### 2. Create a local directory

``` shell
$ mkdir ~/ray_nfs
```

### 3. Link the local directory whit GCP server

``` shell
sudo mount -t nfs 34.146.128.46:/home/arunava/ray_nfs ~/ray_nfs -o nolock
```

After that, you can see a nfs folder in your *home* directory. I have upload some document in this file

<img src="/home/lwh/.config/Typora/typora-user-images/image-20211220150548615.png" alt="image-20211220150548615" style="zoom:67%;" />

<img src="/home/lwh/.config/Typora/typora-user-images/image-20211220150617149.png" alt="image-20211220150617149" style="zoom:67%;" />

### 4. Some notes

1. Before you connect to the nfs folder, make sure that the GCP server is working (Please check with **Arunava**).

2. When you finish your work, you need umonut the nfs folder before the server is shutdown. Otherwise your computer will crash.

   ``` shell
   $ sudo umount ~/ray_nfs
   ```

   