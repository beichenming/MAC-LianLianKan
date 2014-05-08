//
//  AppDelegate.h
//  LianLiankan
//
//  Created by User on 4/16/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BoxNSButton.h"
#include "BoxNSView.h"
#include <iostream>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *_windowStop;
@property (assign) IBOutlet BoxNSView *_view;
@property (assign) IBOutlet NSButton *_startBtn;
@property (assign) IBOutlet NSButton *_to_sinaBtn;
@property (assign) IBOutlet NSButton *_boomBtn;
@property (assign) IBOutlet NSButton *_refershBtn;
@property (assign) IBOutlet NSButton *_continueBtn;
@property (assign) IBOutlet NSTextField *_scoreText;
@property (assign) IBOutlet NSTextField *_timeText;
@property (assign) IBOutlet NSTextField *_overText;
@property (assign) IBOutlet NSTextField *_boomNumText;
@property (assign) IBOutlet NSTextField *_refershNumText;
@property (assign) IBOutlet NSTimer *_gameTimer;
@property (assign) IBOutlet NSTimer *_propmtTimer;
@property (assign) IBOutlet NSControl *_timeControl;
@property (assign) IBOutlet NSTextField *_serverIPText;
@property (assign) IBOutlet NSTextField *_serverPortText;
@property (assign) IBOutlet NSTextField *_usernameText;
@property (assign) IBOutlet NSTextField *_sendInfornText;
@property (assign) IBOutlet NSButton *_bindServerBtn;
@property (assign) IBOutlet NSButton *_sendInfornBtn;
@property (assign) IBOutlet NSTextView *_InfornView;




-(IBAction)BoxButtonAction:(id)sender;
-(IBAction)StartGameAction:(id)sender;
-(IBAction)ToSinaAction:(id)sender;
-(IBAction)BoomButtonAction:(id)sender;
-(IBAction)RefershButtonAction:(id)sender;
-(IBAction)ContinueButtonAction:(id)sender;
-(IBAction)BindServerButtonAction:(id)sender;
-(IBAction)SendInfornButtonAction:(id)sender;


@end

