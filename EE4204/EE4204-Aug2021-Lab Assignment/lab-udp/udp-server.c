/**************************************
udp_ser.c: the source file of the server in udp transmission
**************************************/
#include "headsock.h"

void error_free(int sockfd);
void stop_wait(int sockfd);

int main(int argc, char *argv[])
{
	int sockfd;
	struct sockaddr_in my_addr;

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
		stop_wait(sockfd);
	}
	close(sockfd);
	exit(0);
}

//error free function. After receive all data, it will return a ACK signal
void error_free(int sockfd)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	char compare[DATALEN];
	struct ack_so ack;
	int end=0, len=0, n = 0, flag = 0;
	long lseek=0;
	struct sockaddr_in addr;

	len = sizeof (struct sockaddr_in);
    printf("receiving data!\n");

    ack.len = 0;
    ack.num = 1;

    while (!end)
    {
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
        memcpy((buf+lseek), recvs, n);
        lseek += n;
    }
    if ((n = sendto(sockfd, &ack, 2, 0, (struct sockaddr *)&addr, len)) == -1)
    {
        printf("send error!");
        exit(1);
    }
    if ((fp = fopen ("error-free.txt","wt")) == NULL)
    {
		printf("File doesn't exit\n");
		exit(0);
    }
	fwrite (buf , 1 , lseek , fp);					//write data into file
	fclose(fp);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);
}

// ACK1, ACK2
void stop_wait(int sockfd)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	char compare[DATALEN];
	struct ack_so ack;
	int end=0, len=0, n = 0, flag = 0;
	long lseek=0;
	struct sockaddr_in addr;

	len = sizeof (struct sockaddr_in);
    printf("receiving data!\n");

    ack.len = 0;
    ack.num = 1;
    while (!end)
    {
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

		if ((flag = sendto(sockfd, &ack, 2, 0, (struct sockaddr *)&addr, len)) == -1)
		{
			printf("send error!");
			exit(1);
		}
		
		if ((flag = memcmp(compare, recvs, n)) == 0)
		{
			printf("two same packets\n");
			continue;
		}
		else
		{
			memcpy(compare, recvs, n);
		}

		if (ack.num == 1)
			ack.num = 2;
		else
			ack.num =1 ; 
	
        memcpy((buf+lseek), recvs, n);
        lseek += n;
    }
    if ((fp = fopen ("stop_wait.txt","wt")) == NULL)
    {
		printf("File doesn't exit\n");
		exit(0);
    }
	fwrite (buf , 1 , lseek , fp);					//write data into file
	fclose(fp);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);
}