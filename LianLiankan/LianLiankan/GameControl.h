//
//  GameControl.h
//  LianLiankan
//
//  Created by User on 4/17/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <iostream>
#include <vector>
#include <string>
#include <queue>
#import "BoxNSButton.h"
#import "BoxNSView.h"
using namespace std;

@interface GameControl : NSObject

struct bcm
{
    int x,y,c,d;
};

@property int _map_width;
@property int _map_height;
@property int _map_start_x ;
@property int _map_start_y ;



-(void)initBox;
-(vector<int>) get_boxname;
-(vector<BoxNSButton *>) get_boxbtn;
-(void)initBoxImage;
-(int)bfs:(bcm)s;
-(int)initlastX:(int)lastx lastY:(int)lasty nowX:(int)nowx nowY:(int)nowy;
-(void)makeBtnPicnowX:(int)nowx nowY:(int)nowy;
-(BOOL)IsGameOver;
-(void)GameOver;
-(void)GameLevel:(int)level;
-(void)GamePrompt;
-(void)Boom;
-(void)Refersh;


@end
