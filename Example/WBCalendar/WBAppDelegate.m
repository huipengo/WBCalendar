//
//  WBAppDelegate.m
//  WBCalendar
//
//  Created by penghui8 on 04/02/2019.
//  Copyright (c) 2019 penghui8. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBHomeViewController.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    WBHomeViewController *viewController = [[WBHomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    _window.rootViewController = nav;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
