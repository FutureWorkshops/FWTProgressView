//
//  AppDelegate.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //
    RistrettoTableViewController *rootViewController = [[[RistrettoTableViewController alloc] init] autorelease];
    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"Default" className:@"ViewController"],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"Custom tracks" className:@"TableViewController"],
                         ];
    rootViewController.items = samples;

    //
    self.window.rootViewController = [UINavigationController Ristretto_navigationControllerWithRootViewController:rootViewController
                                                                                             defaultHeaderEnabled:YES];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
