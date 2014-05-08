//
//  AppDelegate.m
//  LianLiankan
//
//  Created by User on 4/16/14.
//  Copyright (c) 2014 wu.yike. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id)init
{
    if (self = [super init]) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp activateIgnoringOtherApps:YES];
    }
    return self;
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
    /*
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 300, 300) styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
    [window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
    [window setTitle:[[NSProcessInfo processInfo] processName]];
    [window makeKeyAndOrderFront:self];
    [window makeMainWindow];
    self.window = window;
    */
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
}

-(IBAction)_bitn1:(id)sender
{
    NSLog(@"dsds");
    NSImage *_image = [NSImage imageNamed:@"qq.jpg"];
    [self._btn1 setImage:_image];
    [self._btn1 setHidden:NO];
    [sender setEnabled:YES];
}

- (IBAction)_bitn2:(id)sender
{
    NSLog(@"dsds");
}




@end
