//
//  BoxNSView.m
//  LianLiankan
//
//  Created by User on 4/17/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import "BoxNSView.h"

@implementation BoxNSView

- (id)init
{
    self = [super init];
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSImage *image = [NSImage imageNamed:@"bg5.jpg"];
    [image drawInRect:NSMakeRect(0,0, 200,200) fromRect: NSZeroRect operation:NSCompositeSourceOver fraction:1];
    [[NSColor colorWithPatternImage:image]set];
    NSRectFill(dirtyRect);
}










@end
