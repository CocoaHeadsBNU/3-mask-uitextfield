//
//  AppDelegate.m
//  textfieldmasks
//
//  Created by Lucas Eduardo Schlögl on 08/07/15.
//  Copyright (c) 2015 Lucas Eduardo Schlögl. All rights reserved.
//

#import "AppDelegate.h"
#import "MasksViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MasksViewController alloc] init]];
    [navigationController setNavigationBarHidden:YES];
    

    [self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];

    return YES;
}


@end
