/*******************************
tcp_client.c: the source file of the client in tcp transmission
********************************/

#include "headsock.h"

void str_cli(FILE *fp, int sockfd);        //used for socket transmission             

int main(int argc, char **argv)
{
	int sockfd, ret;
	struct sockaddr_in ser_addr;
	char ** pptr;
	struct hostent *sh;
	struct in_addr **addrs;

	if (argc != 2) {
		printf("parameters not match");
	}

	sh = gethostbyname(argv[1]);	                            //get host's information from the input argument
	if (sh == NULL) {
		printf("error when gethostby name");
		exit(0);
	}

	printf("canonical name: %s\n", sh->h_name);
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
        
	addrs = (struct in_addr **)sh->h_addr_list;                       //get the server(receiver)'s ip address
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
	ret = connect(sockfd, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr));         //connect the socket with the server(receiver)
	if (ret != 0) {
		printf ("connection failed\n"); 
		close(sockfd); 
		exit(1);
	}
	
	str_cli(stdin, sockfd);                       //perform the transmission

	close(sockfd);
	exit(0);
}

void str_cli(FILE *fp, int sockfd)
{
	char sends[MAXSIZE];

	printf("Please input a string (less than 50 character):\n");
	if (fgets(sends, MAXSIZE, fp) == NULL) {
		printf("error input\n");
	}
	send(sockfd, sends, strlen(sends), 0);		//send the string to the server(receiver)
	printf("send out!!\n");
}

