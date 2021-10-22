/*******************************
tcp_client.c: the source file of the client in tcp transmission for a large packet
********************************/

#include "headsock.h"

float str_cli(FILE *fp, int sockfd, long *len);                       //packet transmission fuction
void tv_sub(struct  timeval *out, struct timeval *in);	    //calcu the time interval between out and in

int main(int argc, char **argv)
{
	int sockfd, ret;
	float ti, rt;
	long len;
	struct sockaddr_in ser_addr;
	char ** pptr;
	struct hostent *sh;
	struct in_addr **addrs;
	FILE *fp;

	if (argc != 2) {
		printf("parameters not match");
	}

	sh = gethostbyname(argv[1]);	                                       //get host's information
	if (sh == NULL) {
		printf("error when gethostby name");
		exit(0);
	}

	printf("canonical name: %s\n", sh->h_name);					//print server's information
	for (pptr=sh->h_aliases; *pptr != NULL; pptr++)
		printf("the aliases name is: %s\n", *pptr);
	switch(sh->h_addrtype)
	{
		case AF_INET:
			printf("AF_INET\n");
		break;
		default:
			printf("unknown addrtype\n");
		break;
	}
        
	addrs = (struct in_addr **)sh->h_addr_list;
	sockfd = socket(AF_INET, SOCK_STREAM, 0);                           //create the socket
	if (sockfd <0)
	{
		printf("error in socket");
		exit(1);
	}
	ser_addr.sin_family = AF_INET;                                                      
	ser_addr.sin_port = htons(MYTCP_PORT);
	memcpy(&(ser_addr.sin_addr.s_addr), *addrs, sizeof(struct in_addr));
	bzero(&(ser_addr.sin_zero), 8);
	ret = connect(sockfd, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr));         //connect the socket with the remote host
	if (ret != 0) {
		printf ("connection failed\n"); 
		close(sockfd); 
		exit(1);
	}
	
	if((fp = fopen ("myfile.txt","r+t")) == NULL)		//open local file to read the data
	{
		printf("File doesn't exit\n");
		exit(0);
	}

	ti = str_cli(fp, sockfd, &len);                       //perform the transmission and receiving
	if (ti != -1)	{
		rt = (len/(float)ti);                                         //caculate the average transmission rate
		printf("Ave Time(ms) : %.3f, Ave Data sent(byte): %d\nAve Data rate: %f (Kbytes/s)\n", ti, (int)len, rt);
	}

	close(sockfd);
	fclose(fp);
//}
	exit(0);
}

float str_cli(FILE *fp, int sockfd, long *len)
{
	long lsize;
	struct pack_so sends;
	struct ack_so acks;
	int n;
	float time_inv = 0.0;
	struct timeval sendt, recvt;

	fseek (fp , 0 , SEEK_END);
	*len= lsize = ftell (fp);
	rewind (fp);
	printf("The file length is %d bytes\n", (int)lsize);
	

  // copy the file into the buffer.
	fread (sends.data,1,lsize,fp);					//read the file data into the data area in packet

  /*** the whole file is loaded in the buffer. ***/

	gettimeofday(&sendt, NULL);							//get the current time

	sends.len = lsize;									//the data length
	sends.num = 0;
	n=send(sockfd, &sends, (sends.len+HEADLEN), 0);		//send the data in one packet
	if (n == -1)	{			
		printf("error sending data\n");
		exit(1);
	}
	else printf("%d data sent", n);
	if ((n=recv(sockfd, &acks, 2, 0)) == -1) {	        //receive ACK or NACK
		printf("error receiving data\n");
		exit(1);
	}
	if ((acks.len == 0) && (acks.num == 1))         //if it is ACK
	{
		gettimeofday(&recvt, NULL);                                                         //get current time
		tv_sub(&recvt, &sendt);                                                                 // get the whole trans time
		time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
		return(time_inv);
	}
	else	{
		return(-1);
		printf("Error in transmission\n");
	}
}

void tv_sub(struct  timeval *out, struct timeval *in)
{
	if ((out->tv_usec -= in->tv_usec) <0)
	{
		--out ->tv_sec;
		out ->tv_usec += 1000000;
	}
	out->tv_sec -= in->tv_sec;
}
