//
//  AppDelegate.m
//  LianLiankan
//
//  Created by User on 4/16/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import "AppDelegate.h"
#include "GameControl.h"
#include "Client.h"

@implementation AppDelegate

int _width;
int _height;
int _lastX;
int _lastY;
int _score;
int _timeAll;
int _PropmtTime;
int _nowLevel;
int _levelNum;
int _boomNum;
int _refershNum;
BOOL _lock;
BOOL _clickStatus;
BOOL _isopenWin;
string _serverIp;
string _serverPort;
string _userName;
string _sendInforn;
GameControl *_gameControl;
Client *_client;

- (void)initInform
{
    _width = [_gameControl _map_width];
    _height = [_gameControl _map_height];
    _lastX = -1;
    _lastY = -1;
    _clickStatus = NO;
    _score = 0;
    _timeAll = 180;
    _PropmtTime = 3;
    _levelNum = 6;
    _nowLevel = 1;
    _boomNum = 10;
    _refershNum = 10;
    _lock = NO;
    _isopenWin = NO;
    self._gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CalcuRemainTime) userInfo:nil repeats:YES];
    [self._gameTimer setFireDate:[NSDate distantFuture]];
    self._propmtTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(PropmTime) userInfo:nil repeats:YES];
    [self._propmtTimer setFireDate:[NSDate distantFuture]];
    [self._overText setStringValue:@""];
    [self._timeControl setIntegerValue:_timeAll];
    [self._scoreText setStringValue:@"0"];
}


- (void)initGame
{
    _gameControl = [[GameControl alloc]init];
    for(int i = 0; i < [_gameControl get_boxbtn].size(); i++)
    {
        [[_gameControl get_boxbtn].at(i) setIdentifier:[NSString stringWithFormat:@"%d",[_gameControl get_boxname].at(i)]];
        [[_gameControl get_boxbtn].at(i) setAction:@selector(BoxButtonAction:)];
        [self._view addSubview:[_gameControl get_boxbtn].at(i)];
    }
}


- (void)PropmTime
{
    if (_PropmtTime == 0)
    {
        [_gameControl GamePrompt];
    }
    _PropmtTime--;
}


- (void)CalcuRemainTime
{
    if (_timeAll < 0.0)
    {
        [self._gameTimer invalidate];
        [self._overText setStringValue:[NSString stringWithFormat:@"恭喜你的得分是:%d",_score]];
        [_gameControl GameOver];
        [self._startBtn setTitle:@"Start"];
        [self._scoreText setStringValue:@""];
        _lock = NO;
        [self._propmtTimer invalidate];
        return ;
    }
    _timeAll--;
    if([_gameControl IsGameOver] == YES)
    {
        if(_nowLevel < _levelNum)
        {
            _nowLevel++;
            _lastX = -1;
            _lastY = -1;
            _clickStatus = NO;
            [self initGame];
            [_gameControl GameLevel:(_levelNum - _nowLevel)];
        }
        else
        {
            [_gameControl GameOver];
        }
    }
    
    [self._timeText setStringValue:[NSString stringWithFormat:@"%d",_timeAll]];
    [self._timeControl setIntValue:_timeAll];
}


- (void)Addscore
{
    _score += 10;
    NSString *scoreString = [NSString stringWithFormat:@"%d",_score];
    [self._scoreText setStringValue:scoreString];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [NSApp setMainMenu:[NSMenu new]];
    NSMenuItem *appMenuItem = [NSMenuItem new];
    [[NSApp mainMenu] addItem:appMenuItem];
    NSMenu *appMenu = [NSMenu new];
    [appMenuItem setSubmenu:appMenu];
    NSString *appName = [[NSProcessInfo processInfo] processName];
    NSString *quitTitle = [@"Quit " stringByAppendingString:appName];
    NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:quitTitle action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenu addItem:quitMenuItem];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initGame];
    [self initInform];
    NSImage *image1 = [NSImage imageNamed:@"boom.png"];
    [self._boomBtn setImage:image1];
    [self._boomBtn setBordered:NO];
    [self._boomBtn setTitle:@""];
    NSImage *image2 = [NSImage imageNamed:@"refersh.png"];
    [self._refershBtn setImage:image2];
    [self._refershBtn setBordered:NO];
    [self._refershBtn setTitle:@""];
    [self._boomNumText setStringValue:[NSString stringWithFormat:@"X %d",_boomNum]];
    [self._refershNumText setStringValue:[NSString stringWithFormat:@"X %d",_refershNum]];
    [_gameControl GameLevel:(_levelNum - _nowLevel)];
}

- (IBAction)BoxButtonAction:(id)sender
{
  if(_lock == YES && _timeAll > 0)
  {
      _PropmtTime = 3;
    int num = [[sender identifier] intValue];
    int _nowX = num / _width;
    int _nowY = num % _height;
    [_gameControl makeBtnPicnowX:_lastX nowY:_lastY];
    [_gameControl makeBtnPicnowX:_nowX nowY:_nowY];
    if(_clickStatus == NO){
        _clickStatus = YES;
        _lastX = _nowX;
        _lastY = _nowY;
    }
    else
    {
        _clickStatus = NO;
        if ([_gameControl initlastX:_lastX lastY:_lastY nowX:_nowX nowY:_nowY] == 1)
        {
            [self Addscore];
        }
        _lastX = _nowX;
        _lastY = _nowY;
    }
     NSLog(@"%d",num);
    }
}


- (IBAction)StartGameAction:(id)sender
{
    if (_isopenWin == YES)
    {
        return ;
    }
    
    if (_lock == NO)
    {
        if (_timeAll < 0)
        {
            [self initGame];
            [self initInform];
            [_gameControl GameLevel:(_levelNum - _nowLevel)];
        }
        _lock = YES;
        [self._startBtn setTitle:@"Stop"];
        [self._gameTimer setFireDate:[NSDate date]];
        [self._propmtTimer setFireDate:[NSDate date]];
    }
    else
    {
        _lock = NO;
        _isopenWin = YES;
        [self._windowStop setIsVisible:YES];
        [self._startBtn setTitle:@"Start"];
        [self._gameTimer setFireDate:[NSDate distantFuture]];
        [self._propmtTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)ContinueButtonAction:(id)sender
{
    _isopenWin = NO;
    [self._windowStop close];
    if (_timeAll < 0)
    {
        [self initGame];
        [self initInform];
        [_gameControl GameLevel:(_levelNum - _nowLevel)];
    }
    _lock = YES;
    [self._startBtn setTitle:@"Stop"];
    [self._gameTimer setFireDate:[NSDate date]];
    [self._propmtTimer setFireDate:[NSDate date]];
}


- (void)BoomButtonAction:(id)sender
{
    if (_isopenWin == YES)
     {
        return ;
     }
    
    if (_boomNum > 0 && _lock == YES)
      {
          [_gameControl Boom];
          [self Addscore];
          _boomNum--;
          [self._boomNumText setStringValue:[NSString stringWithFormat:@"X %d",_boomNum]];
      }
}


-(void)RefershButtonAction:(id)sender
{
    if (_isopenWin == YES)
    {
        return ;
    }
    
    if (_refershNum > 0 && _lock == YES)
    {
        _lastX = -1;
        _lastY = -1;
        _clickStatus = NO;
        [_gameControl GameOver];
        [self initGame];
        [_gameControl GameLevel:(_levelNum - _nowLevel)];
        _refershNum--;
        [self._refershNumText setStringValue:[NSString stringWithFormat:@"X %d",_refershNum]];
    }
}


-(IBAction)SendInfornButtonAction:(id)sender
{
    
}


-(IBAction)BindServerButtonAction:(id)sender
{
    char username[20];
    char ip[20];
    char port[6];
    int i,j,k;
    
    _serverIp = [[self._serverIPText stringValue] UTF8String];
    _serverPort =[[self._serverPortText stringValue] UTF8String];
    _userName = [[self._usernameText stringValue] UTF8String];
  
    for(i = 0 ;i < _userName.size(); i++){
        username[i] = _userName.at(i);
    }
    username[i] = '\0';
    
    for(j = 0; j < _serverIp.size(); j++){
        ip[j] = _serverIp.at(j);
    }
    ip[j] = '\0';
    
    for(k = 0; k < _serverPort.size(); k++){
        port[k] = _serverPort.at(k);
    }
    port[k] = '\0';
   
   _client = [[Client alloc]init];
    struct node_msg my_msg = [_client linkClientIp:ip Port:port Name:(username)];
    [self._InfornView setString:[NSString stringWithFormat:@"%s--%d--%s--%s",inet_ntoa(my_msg.sin_addr),ntohs(my_msg.sin_port),my_msg.name,my_msg.msg]];
}




@end
