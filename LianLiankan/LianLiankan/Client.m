//
//  Client.m
//  LianLiankan
//
//  Created by User on 4/20/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import "Client.h"

@implementation Client

struct node_list *head;

struct node_list *create_list()
{
	struct node_list *head;
	head = (struct node_list *)malloc(sizeof(struct node_list));
	head->next = NULL;
	return head;
}

struct node_list *insert_list(struct node_list *head, struct in_addr sin_addr, u_short sin_port, char *name)
{
    struct node_list *temp;
    temp = (struct node_list *)malloc(sizeof(struct node_list));
    temp->sin_addr = sin_addr;
    temp->sin_port = sin_port;
    strcpy(temp->name, name);
    temp->next = head->next;
    head->next = temp;
    return head;
}

struct node_list *del_list(struct node_list *head, struct in_addr sin_addr)
{
	struct node_list *p, *q;
	q = head;
	p = head->next;
	while ((p->sin_addr.s_addr != sin_addr.s_addr) && (p != NULL))
	{
		q = q->next;
		p = p->next;
	}
	if (p == NULL)
	{
		return 0;
	}
	else
	{
		q->next = p->next;
		free(p);
		p = NULL;
	}
	return head;
    
}

void child_recv(int socket_fd, struct node_msg package,
                struct sockaddr_in server_addr)
{
    printf("child\n");
	pid_t pid;
	int server_len;
	
	server_len = sizeof(struct sockaddr);
	server_addr.sin_family = AF_INET;
	pid = getppid();
    
	if ((package.type == SERVER_QUIT) &&
		(strncmp(package.msg, "quit", 4) == 0))
	{
		kill(pid, SIGUSR1);
		waitpid(pid, NULL, 0);
		exit(0);
	}
	else if (package.type == CLIENT_QUIT)
	{
		//printf(" name:%s\n msg:%s\n", package.name, package.msg);
		printf("usr list:\n");
		while (1)
		{
			printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
                   ntohs(package.sin_port), package.name);
			//printf("list recv\n");
			recvfrom(socket_fd, &package, sizeof(package), 0,
                     (struct sockaddr *)&server_addr, &server_len);
            
			if (strncmp(package.msg, "end", 3) == 0)
				break;
            
			//printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
			//		ntohs(package.sin_port), package.name);
		}
		
		printf("%s\n", package.msg);
	}
	else if(package.type == LOGIN)
	{
		printf("usr list:\n");
		while (1)
		{
			//printf("list recv\n");
			printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
                   ntohs(package.sin_port), package.name);
			recvfrom(socket_fd, &package, sizeof(package), 0,
                     (struct sockaddr *)&server_addr, &server_len);
            
			if (strncmp(package.msg, "end", 3) == 0)
				break;
            
			//printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
			//		ntohs(package.sin_port), package.name);
		}
		
		printf("%s\n", package.msg);
	}
	else
	{
		printf(" name:%s\n msg:%s\n", package.name, package.msg);
	}
}


void father_send(int socket_fd, struct sockaddr_in server_addr,
                 pid_t pid, char *argv)
{
    printf("father\n");
	char buf[100];
	struct node_msg package;
    
	package.type = PUBLIC_TALK;
	strcpy(package.name, argv);
	server_addr.sin_family = AF_INET;
    
	while (1)
	{
		getchar();
		printf(">");
		fgets(buf, sizeof(buf), stdin);
		buf[strlen(buf) - 1] = 0;
        
		if (strncmp(buf, "private", 7) == 0)
		{
			printf("now you are in the private talk\n");
			printf("you can enter 'exit' to talk with others\n");
			//printf("please input the NAME you want to talk:\n");
			
			
			while (1)
			{
				getchar();
				printf(">");
				fgets(buf, sizeof(buf), stdin);
				buf[strlen(buf) - 1] = 0;
				if (strncmp(buf, "exit", 4) == 0)
				{
					package.type = PUBLIC_TALK;
					break;
				}
				
				package.type = PRIVATE_TALK;
				strcpy(package.name, argv);
				strcpy(package.msg, buf);
				sendto(socket_fd, &package, sizeof(package), 0,
                       (struct sockaddr *)&server_addr, sizeof(server_addr));
				
				//fgets(buf,sizeof(buf), stdin);
				//buf[strlen(buf) - 1] = 0;
			}
		}
		
		if (strncmp(buf, "quit", 4) == 0)
		{
			package.type = CLIENT_QUIT;
		}
		
		strcpy(package.msg, buf);
		
		sendto(socket_fd, &package, sizeof(package), 0,
               (struct sockaddr *)&server_addr, sizeof(server_addr));
        /*
         printf("%d--%s--%d--%s\n", package.type,
         inet_ntoa(server_addr.sin_addr),
         ntohs(server_addr.sin_port),
         package.name);
         */
		if (strncmp(buf, "quit", 4) == 0)
		{
			kill(pid, SIGUSR1);
			waitpid(pid, NULL, 0);
			exit(0);
		}
	}
}

-(struct node_msg)linkClientIp:(char *)ip Port:(char *)port Name:(char *)username
{
    int socket_fd;
    struct sockaddr_in server_addr;
    int server_len;
    char buf[100];
	struct node_list temp;
	struct node_msg package;
    
    if ((socket_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("fail to socket");
        exit(-1);
    }
    
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(atoi(port));
    server_addr.sin_addr.s_addr = inet_addr(ip);
    server_len = sizeof(struct sockaddr);
    
	package.type = LOGIN;
	strcpy(package.name, username);
	strcpy(package.msg, "is login");
    sendto(socket_fd, &package, sizeof(package), 0,
           (struct sockaddr *)&server_addr, sizeof(server_addr));
	usleep(1000);
	
	//printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
	//			ntohs(package.sin_port), package.name);
	
	while (1)
	{
		//printf("recv list\n");
		recvfrom(socket_fd, &package, sizeof(package), 0,
                 (struct sockaddr *)&server_addr, &server_len);
		//printf("recv ok\n");
		
		if (strncmp(package.msg, "end", 3) == 0)
			break;
		
		printf("%s--%d--%s\n", inet_ntoa(package.sin_addr),
               ntohs(package.sin_port), package.name);
	}
	printf("%s\n", package.msg);
    [self sendMessage:socket_fd node:package server_add:server_addr name:username];
    return package;
}


-(void)sendMessage:(int)socket_fd node:(struct node_msg)package server_add:(struct sockaddr_in) server_addr name:(char *)username
{
    pid_t pid;
    if ((pid = fork()) < 0)
    {
        perror("fail to fork");
        exit(-1);
    }
    else if (pid == 0)
    {
        printf("pid %d\n",pid);
        while(1)
        {
            recvfrom(socket_fd, &package, sizeof(package), 0, NULL, NULL);
            printf("recv:%d\n", package.type);
            printf("*******recv********\n");
			child_recv(socket_fd,package,server_addr);
        }
        exit(0);
    }
    else
    {
        printf("pid %d\n",pid);
        father_send(socket_fd, server_addr, pid, username);
        exit(0);
    }
}


@end
