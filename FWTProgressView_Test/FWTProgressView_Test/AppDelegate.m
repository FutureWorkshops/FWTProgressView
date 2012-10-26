//
//  AppDelegate.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    UIViewController *vc = [[[SamplePickerViewController alloc] init] autorelease];
    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
