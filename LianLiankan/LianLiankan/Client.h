//
//  Client.h
//  LianLiankan
//
//  Created by User on 4/20/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>

@interface Client : NSObject

#define LOGIN           50
#define PUBLIC_TALK     100
#define PRIVATE_TALK    150
#define CLIENT_QUIT     200
#define SER_TO_CLI      250
#define SERVER_QUIT		300

struct node_list
{
	struct in_addr sin_addr;
	u_short sin_port;
	char name[20];
	struct node_list *next;
};

struct node_msg
{
	int type;
	struct in_addr sin_addr;
	u_short sin_port;
	char name[20];
	char msg[100];
};

-(struct node_msg)linkClientIp:(char *)ip Port:(char *)port Name:(char *)username;
-(void)sendMessage:(int)socket_fd node:(struct node_msg)package server_add:(struct sockaddr_in) server_addr name:(char *)username;
@end
