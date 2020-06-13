#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<arpa/inet.h>
#include<sys/socket.h>
#include<stdlib.h>
#include<unistd.h>
#include<errno.h>
#include<pthread.h>

#define HOST_PORT 9527

void sys_err(const char* str)
{
	perror(str);
	exit(1);
}

int main(int argc,char *argv[])
{
	int lfd=0;
	int cfd=0;
	char buf[4096];
	int ret=0;
	int i;
	struct sockaddr_in serv_addr,client_addr;	
	socklen_t clit_addr_len;
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(HOST_PORT);	
	serv_addr.sin_addr.s_addr=htonl(INADDR_ANY);
	lfd=socket(AF_INET,SOCK_STREAM,0);
	
	if(lfd==-1)
	{
		sys_err("error");
	}

	bind(lfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr));
	listen(lfd,5);
	clit_addr_len=sizeof(client_addr);
	cfd=accept(lfd,(struct sockaddr *)&client_addr,&clit_addr_len);

	if(cfd==-1)
	{
		sys_err("accept error");
	}

while(1)
{

	ret = read(cfd,buf,sizeof(buf));
	write(STDOUT_FILENO,buf,ret);
	for (i=0;i<ret;i++)
	{	buf[i]=toupper(buf[i]);}
	
	write(cfd,buf,ret);
}
	close(lfd);
	close(cfd);
	return 0;
}
