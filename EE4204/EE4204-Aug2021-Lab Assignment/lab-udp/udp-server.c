/**************************************
udp_ser.c: the source file of the server in udp transmission
**************************************/
#include "headsock.h"

void stop_wait(int sockfd, float err_pro, int DATALEN);

int main(int argc, char *argv[])
{
	int sockfd;
	int DATALEN;
	float error_pro;
	struct sockaddr_in my_addr;

	if (argc!= 3)
	{
		printf("Please input error probability and data unit.\n");
		exit(0);
	}

	error_pro = atof(argv[1]);	// transfer char to float
	DATALEN = atoi(argv[2]);

	printf("error probability is: %f\ndata unit is: %d\n",error_pro, DATALEN);

	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {			//create socket
		printf("error in socket");
		exit(1);
	}

	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(MYUDP_PORT);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(my_addr.sin_zero), 8);
	if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)) == -1) {           //bind socket
		printf("error in binding");
		exit(1);
	}
	printf("start receiving\n");
	while(1) {
		// error_free(sockfd);                        // send and receive
		stop_wait(sockfd, error_pro, DATALEN);
	}
	close(sockfd);
	exit(0);
}


// ACK1, ACK2
void stop_wait(int sockfd, float err_pro, int DATALEN)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	char compare[DATALEN];
	struct ack_so ack;
	int end=0, len=0, n = 0, flag = 0, err_times = 0, suc_time=0;
	long lseek=0;
	struct sockaddr_in addr;

	// float err_pro = 0.01;  //erro probability
	float rand_num = 1.0; //a random number. If it smaller than err_pro, indicator that the packet/ARQ is lost
	long data_num = 59793;
	float erro_num = data_num/DATALEN * err_pro;

	srand(time(NULL));


	len = sizeof (struct sockaddr_in);
    printf("receiving data!\n");

    ack.len = 0;
    ack.num = 1;
    while (!end)
    {
		rand_num = (rand()%10001 / 10000.0);	//generat a randam number.
		if ((n = recvfrom(sockfd, &recvs, DATALEN, 0, (struct sockaddr *)&addr, &len)) == -1) 
        {    //receive the packet
			printf("error when receiving\n");
			exit(1);
        }
        if (recvs[n-1] == '\0')
        {
            end = 1;
            n --;
        }

		// if(rand_num <= err_pro)
		if (erro_num > 0 && suc_time >10)
		{
			// printf("A random number: %f\nerr_pro is: %f\n",rand_num,err_pro);
			err_times += 1;
			erro_num -= 1;
			continue;
		}
		
		if ((flag = memcmp(compare, recvs, n)) == 0)
		{
			printf("two same packets\n");
			if ((flag = sendto(sockfd, &ack, 2, 0, (struct sockaddr *)&addr, len)) == -1)
			{
				printf("send error!");
				exit(1);
			}
			continue;
		}
		else
		{
			memcpy(compare, recvs, n);
			if (ack.num == 1)
				ack.num = 2;
			else
				ack.num =1 ; 
		}

		if ((flag = sendto(sockfd, &ack, 2, 0, (struct sockaddr *)&addr, len)) == -1)
		{
			printf("send error!");
			exit(1);
		}
		
		// if (ack.num == 1)
		// 	ack.num = 2;
		// else
		// 	ack.num =1 ; 
	
        memcpy((buf+lseek), recvs, n);
		suc_time += 1;
        lseek += n;
    }
    if ((fp = fopen ("ARQ.txt","wt")) == NULL)
    {
		printf("File doesn't exit\n");
		exit(0);
    }
	fwrite (buf , 1 , lseek , fp);					//write data into file
	fclose(fp);
	printf("lost %d packet.\n",err_times);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);
}