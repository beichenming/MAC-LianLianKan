//
//  GameControl.m
//  LianLiankan
//
//  Created by User on 4/17/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import "GameControl.h"

@implementation GameControl

vector<int> _boxname;
vector<BoxNSButton *> _boxbtn;
string _picpath1[10] = {"box1.png","box2.png","box3.png","box4.png","box5.png","box6.png","box7.png","box8.png","box9.png","box10.png"};

string _picpath2[10] = {"_box1.png","_box2.png","_box3.png","_box4.png","_box5.png","_box6.png","_box7.png","_box8.png","_box9.png","_box10.png"};

int _map[10][10];
int _visit[10][10];
int _direction[4][2] = {{1,0},{0,1},{-1,0},{0,-1}};
bcm _start;
bcm _end;
int _boxAllNum;
int _boxNowNum;

- (id)init
{
    if (self = [super init])
    {
        self._map_height = 10;
        self._map_width = 10;
        self._map_start_x = 600;
        self._map_start_y = 500;
        _boxAllNum = 0;
        _boxNowNum = 0;
        [self initBox];
        [self initBoxImage];
    }
    return self;
}


- (vector<int>) get_boxname
{
    return _boxname;
}

- (vector<BoxNSButton *>) get_boxbtn
{
    return _boxbtn;
}


- (void)initBox
{
    if(!_boxname.empty())
    {
        _boxbtn.clear();
    }
    
    if(!_boxname.empty())
    {
        _boxname.clear();
    }
    
    for(int i = 0; i < self._map_width; i++)
    {
      for(int j = 0; j < self._map_height; j++)
      {
        BoxNSButton *_box = [[BoxNSButton alloc]initWithFrame:NSMakeRect(self._map_start_x + i * 50, self._map_start_y + j * 50, 42, 42)];
        [_box setTitle:nil];
        [_box setBordered:NO];
        [_box set_x:i];
        [_box set_y:j];
        [_box set_nowStatus:YES];
       _boxname.push_back(i * self._map_height + j);
       _boxbtn.push_back(_box);
        _map[i][j] = -1;
      }
    }
}


- (void)initBoxImage
{
      srand((int)time(0));
      for(int i = 0; i < self._map_width; i++)
        for(int j = 0; j < self._map_height; j++)
        {
            int temp = rand() % 10;
            int x = rand() % self._map_width;
            int y = rand() % self._map_height;
            if(_map[i][j] == -1)
            {
                while(_map[x][y] != -1 || (x == i && y == j))
                {
                    x = rand() % self._map_width;
                    y = rand() % self._map_height;
                }
                _map[x][y] = temp;
                _map[i][j] = temp;
                
                if(temp != 0)
                {
                    _boxAllNum += 2;
                    for(int k = 0 ; k < _boxname.size() ; k++)
                    {
                        if([_boxbtn.at(k) _x] == i && [_boxbtn.at(k) _y] == j)
                        {
                            NSString *str1 = [NSString stringWithCString:_picpath1[temp].c_str()];
                            NSImage *image1 = [NSImage imageNamed:str1];
                            [_boxbtn.at(k) setImage:image1];
                        }
                        if([_boxbtn.at(k) _x] == x && [_boxbtn.at(k) _y] == y)
                        {
                            NSString *str2 = [NSString stringWithCString:_picpath1[temp].c_str()];
                            NSImage *image2 = [NSImage imageNamed:str2];
                            [_boxbtn.at(k) setImage:image2];
                        }
                    }
                 }
              }
          }
}



- (int)bfs:(bcm)s
{
    bcm temp;
    queue<bcm> q;
    q.push(s);
    _visit[s.x][s.y] = 0;
    while(!q.empty())
    {
        temp = q.front();
        q.pop();
        if(temp.x == _end.x && temp.y == _end.y && temp.d <= 2)
        {
            return 1;
        }
        for(int i = 0; i < 4 ;i++)
        {
             bcm _now;
            _now.x = temp.x + _direction[i][0];
            _now.y = temp.y + _direction[i][1];
            _now.c = i;
            _now.d = temp.d;
         if (_now.x >= 0 && _now.x < self._map_width && _now.y >= 0 && _now.y < self._map_height && ((_now.x == _end.x && _now.y == _end.y) || _map[_now.x][_now.y] == 0))
         {
            if (_now.c != temp.c)
            {
                _now.d++;
                if (_now.d > 2)
                    continue;
                if (_visit[_now.x][_now.y] >= _now.d)
                {
                    _visit[_now.x][_now.y] = _now.d;
                    q.push(_now);
                }
            }
            else
            {
                if (_visit[_now.x][_now.y] >= _now.d)
                {
                    _visit[_now.x][_now.y] = _now.d;
                    q.push(_now);
                }
            }
          }
        }
     }
    return 0;
}

                 
- (int)initlastX:(int)lastx lastY:(int)lasty nowX:(int)nowx nowY:(int)nowy
{
    for(int i = 0; i < self._map_width ;i ++)
    {
        for(int j = 0; j < self._map_height; j++)
        {
            _visit[i][j] = 3;
        }
    }
    _start.x = lastx;
    _start.y = lasty;
    _end.x = nowx;
    _end.y = nowy;
    _start.c = -1;
    _start.d = -1;
    if(_map[_start.x][_start.y] != _map[_end.x][_end.y] || _map[_start.x][_start.y] == 0 || _map[_end.x ][_end.y] == 0 || (_start.x == _end.x && _start.y == _end.y))
    {
        return -1;
    }
    
    int flag = [self bfs:_start];
    
    if (flag == 1)
    {
        _boxNowNum += 2;
        _map[_start.x][_start.y] = 0;
        _map[_end.x][_end.y] = 0;
        for(int k = 0 ; k < _boxname.size() ; k++)
        {
            if ([_boxbtn.at(k) _x] == _start.x && [_boxbtn.at(k) _y]  == _start.y)
            {
                [_boxbtn.at(k) setImage:nil];
            }
            if ([_boxbtn.at(k) _x] == _end.x && [_boxbtn.at(k) _y]  == _end.y)
            {
                [_boxbtn.at(k) setImage:nil];
            }
         }
        return 1;
     }
     else
     {
        return -1;
     }
    
}

- (void)makeBtnPicnowX:(int)nowx nowY:(int)nowy
{
    for(int k = 0 ; k < _boxname.size() ; k++)
    {
        if ([_boxbtn.at(k) _x] == nowx && [_boxbtn.at(k) _y] == nowy && _map[nowx][nowy] != 0)
        {
            int numFlag = _map[nowx][nowy];
            if([_boxbtn.at(k) _nowStatus] == YES)
            {
                NSString *str1 = [NSString stringWithCString:_picpath2[numFlag].c_str()];
                NSImage *image1 = [NSImage imageNamed:str1];
                [_boxbtn.at(k) setImage:image1];
                [_boxbtn.at(k) set_nowStatus:NO];
                break;
            }
           if([_boxbtn.at(k) _nowStatus] == NO)
            {
                 NSString *str1 = [NSString stringWithCString:_picpath1[numFlag].c_str()];
                 NSImage *image1 = [NSImage imageNamed:str1];
                 [_boxbtn.at(k) setImage:image1];
                 [_boxbtn.at(k) set_nowStatus:YES];
                 break;
            }
        }
    }
}

-(BOOL)IsGameOver
{
     if(_boxNowNum == _boxAllNum)
     {
         return YES;
     }
     else
     {
         return NO;
     }
}

-(void)GameOver
{
    for(int k = 0 ; k < _boxname.size() ; k++)
    {
        [_boxbtn.at(k) setImage:nil];
        [_boxbtn.at(k) releaseGState];
     }
    for(int i = 0; i < self._map_width ;i ++)
     for(int j = 0; j < self._map_height; j++)
     {
         _map[i][j] = 0;
     }
}


-(void)GameLevel:(int)level
{
    for(int i = 0; i < self._map_width ;i ++)
    {
        for(int j = 0; j < self._map_height; j++)
        {
             if (_map[i][j] != 0 && _map[i][j] <= level)
             {
                 _map[i][j] = 0;
                 _boxAllNum--;
                 for(int k = 0 ; k < _boxname.size() ; k++)
                 {
                     if ([_boxbtn.at(k) _x] == i && [_boxbtn.at(k) _y] == j)
                     {
                         [_boxbtn.at(k) setImage:nil];
                         break;
                     }
                 }
             }
        }
    }
}

-(void)GamePrompt
{
    for(int i = 0; i < self._map_width ;i ++)
      for(int j = 0; j < self._map_height; j++)
          for(int k = 0; k < self._map_width; k++)
              for(int l = 0; l < self._map_height; l++)
              {
                  if (_map[i][j] == _map[k][l] && !(i == k && j == l) && (_map[i][j] != 0 && _map[k][l] != 0))
                  {
                      int flag = _map[i][j];
                      if ([self initlastX:i lastY:j nowX:k nowY:l] == 1)
                      {
                           _map[i][j] = _map[k][l] = flag;
                           _boxNowNum = _boxNowNum - 2;
                          for(int m = 0 ; m < _boxname.size() ; m++)
                          {
                              if ([_boxbtn.at(m) _x] == i && [_boxbtn.at(m) _y] == j)
                              {
                                  NSString *str1 = [NSString stringWithCString:_picpath2[flag].c_str()];
                                  NSImage *image1 = [NSImage imageNamed:str1];
                                  [_boxbtn.at(m) setImage:image1];
                                  [_boxbtn.at(m) set_nowStatus:YES];

                              }
                              if ([_boxbtn.at(m) _x] == k && [_boxbtn.at(m) _y] == l)
                              {
                                  NSString *str1 = [NSString stringWithCString:_picpath2[flag].c_str()];
                                  NSImage *image1 = [NSImage imageNamed:str1];
                                  [_boxbtn.at(m) setImage:image1];
                                  [_boxbtn.at(m) set_nowStatus:YES];
                              }
                           }
                          return ;
                        }
                    }
                }
       return ;
}


- (void)Boom
{
    for(int i = 0; i < self._map_width ;i ++)
        for(int j = 0; j < self._map_height; j++)
            for(int k = 0; k < self._map_width; k++)
                for(int l = 0; l < self._map_height; l++)
                {
                    if (_map[i][j] == _map[k][l] && !(i == k && j == l) && (_map[i][j] != 0 && _map[k][l] != 0))
                    {
                        if ([self initlastX:i lastY:j nowX:k nowY:l] == 1)
                        {
                            return ;
                        }
                    }
                }
    return ;
}


- (void)Refersh
{
    
    
}



@end
