//
//  InSideNav.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InSideNav.h"


@implementation InSideNav

@synthesize window;
@synthesize navController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [window release];
    [navController release];
    [super dealloc];
}

@end
