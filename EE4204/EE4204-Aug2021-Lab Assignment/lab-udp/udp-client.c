/*******************************
udp_client.c: the source file of the client in udp
********************************/

#include "headsock.h"

float error_free(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len);
float stop_wait(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len);    
void tv_sub(struct  timeval *out, struct timeval *in);

int main(int argc, char *argv[])
{
	int sockfd;
	long len;
	float ti, rt;
	struct sockaddr_in ser_addr;
	char **pptr;
	struct hostent *sh;
	struct in_addr **addrs;
    FILE *fp;

	if (argc!= 2)
	{
		printf("parameters not match.");
		exit(0);
	}

	if ((sh=gethostbyname(argv[1]))==NULL) {             //get host's information
		printf("error when gethostbyname");
		exit(0);
	}

	sockfd = socket(AF_INET, SOCK_DGRAM, 0);             //create socket
	if (sockfd<0)
	{
		printf("error in socket");
		exit(1);
	}

	addrs = (struct in_addr **)sh->h_addr_list;
	printf("canonical name: %s\n", sh->h_name);
	for (pptr=sh->h_aliases; *pptr != NULL; pptr++)
		printf("the aliases name is: %s\n", *pptr);			//printf socket information
	switch(sh->h_addrtype)
	{
		case AF_INET:
			printf("AF_INET\n");
		break;
		default:
			printf("unknown addrtype\n");
		break;
	}

	ser_addr.sin_family = AF_INET;
	ser_addr.sin_port = htons(MYUDP_PORT);
	memcpy(&(ser_addr.sin_addr.s_addr), *addrs, sizeof(struct in_addr));
	bzero(&(ser_addr.sin_zero), 8);

	if((fp = fopen ("myfile.txt","r+t")) == NULL)
	{
		printf("File doesn't exit\n");
		exit(0);
	}

	// ti = error_free(fp, sockfd, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr_in), &len);   // receive and send
	ti = stop_wait(fp, sockfd, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr_in), &len);   // receive and send
	rt = (len/(float)ti);
	printf("Time(ms) : %.3f, Data sent(byte): %d\nData rate: %f (Kbytes/s)\n", ti, (int)len, rt);

	close(sockfd);
	exit(0);
}

float error_free(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len)
{
   	char *buf;
	long lsize, ci;
	char sends[DATALEN];
	struct ack_so ack;
	int n, slen;
	float time_inv = 0.0;
	struct timeval sendt, recvt;
	ci = 0;

	fseek (fp , 0 , SEEK_END);
	lsize = ftell (fp);
	rewind (fp);
	printf("The file length is %d bytes\n", (int)lsize);
	printf("the packet length is %d bytes\n",DATALEN);

    // allocate memory to contain the whole file.
	buf = (char *) malloc (lsize);
	if (buf == NULL) exit (2);

    // copy the file into the buffer.
    fread (buf,1,lsize,fp);
    /*** the whole file is loaded in the buffer. ***/

	buf[lsize] ='\0';									//append the end byte
	gettimeofday(&sendt, NULL);							//get the current time
    while (ci <= lsize)
    {
        if ((lsize+1-ci) <= DATALEN )
			slen = lsize + 1 - ci;
		else
			slen = DATALEN;
		memcpy(sends, (buf+ci), slen);
		if ((n = sendto(sockfd, &sends, slen, 0, addr, addrlen)) == -1)
		{
			printf("send error!");
			exit(1);
		}
		ci += slen;
    }
	if ((n= recvfrom(sockfd, &ack, 2, 0, (struct sockaddr *)&addr, &addrlen))==-1)
	{
		printf("error when receiving\n");
		exit(1);
	}
	if (ack.num != 1|| ack.len != 0)
		printf("error in transmission\n");

	gettimeofday(&recvt, NULL);
	*len = ci; 
	tv_sub(&recvt, &sendt);
	time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
	return(time_inv);
}

float stop_wait(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len)
{
   	char *buf;
	long lsize, ci;
	char sends[DATALEN];
	struct ack_so ack_rec, ack;
	int n, slen, addrlen_sto;
	float time_inv = 0.0;
	struct timeval sendt, recvt;
	struct sockaddr_in addr_sto;
	addrlen_sto = sizeof (struct sockaddr_in);
	ci = 0;
	
	//estimate rtt, RTT = weight*RTT(original) + (1-weight)*RTT(new). Initial RTT is 1ms
	float RTT = 1.0; //ms
	float weight = 0.5; //weight
	struct timeval rtt_in, rtt_out, rtt_set;

	rtt_set.tv_sec = 0;
	rtt_set.tv_usec = RTT * 1000;

	// initial ACK, ack_rec is ACK receive from server. ack is the ACK buffer
	ack_rec.len = 0;
	ack_rec.num = 0;
	ack = ack_rec;
 
	fseek (fp , 0 , SEEK_END);
	lsize = ftell (fp);
	rewind (fp);
	printf("The file length is %d bytes\n", (int)lsize);
	printf("the packet length is %d bytes\n",DATALEN);	

    // allocate memory to contain the whole file.
	buf = (char *) malloc (lsize);
	if (buf == NULL) exit (2);

    // copy the file into the buffer.
    fread (buf,1,lsize,fp);
    /*** the whole file is loaded in the buffer. ***/

	buf[lsize] ='\0';									//append the end byte
	gettimeofday(&sendt, NULL);							//get the current time
	// Alternate ACK0 and ACK1. If receive ACK0 or ACK1 twice, the data will retransmite.
    while (ci <= lsize)
    {
		if ((lsize+1-ci) <= DATALEN )
			slen = lsize + 1 - ci;
		else
			slen = DATALEN;
		memcpy(sends, (buf+ci), slen);		

		if ((n = sendto(sockfd, &sends, slen, 0, addr, addrlen)) == -1)
		{
			printf("send error!\n");
			n = errno;
			printf("error is %d",n);
			exit(1);
		}
		if ((n= recvfrom(sockfd, &ack_rec, 2, 0, (struct sockaddr *)&addr_sto, &addrlen_sto))==-1)
		{
			printf("error when receiving\n");
			exit(1);
		}

		//if ACK lost or send two same packate, the data will retransmit
		if (ack_rec.num == ack.num)
		{
			printf("Retransmit this packet");
			continue;
		}

		ci += slen;
		ack = ack_rec;
    }
	gettimeofday(&recvt, NULL);
	*len = ci; 
	tv_sub(&recvt, &sendt);
	time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
	return(time_inv);
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
