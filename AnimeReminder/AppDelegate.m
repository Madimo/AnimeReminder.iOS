//
//  AppDelegate.m
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import "AppDelegate.h"
#import "AnimeAPI.h"
#import "AnimeAPITest.h"
#import <AFNetworkActivityIndicatorManager.h>

#define TEST_MODE

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

#ifdef TEST_MODE
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TestAnimeAPI" bundle:nil];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
    [self.window makeKeyAndVisible];
    
    
    /**
     *  test code below here...
     */
    
    AnimeAPITest *test = [[AnimeAPITest alloc] init];
    
    //[test testLoginWithUsername:@"a" password:@"a"];
    
    //[test testRegisterWithUsername:@"222@123.com" password:@"123456"];
    
    //[test testGetSubscription];
    
    //[test testChangePasswordWithOldPassword:@"123456" newPassword:@"111111"];
    
    //[test testSetEmailEnable:YES];
    
    //[test testGetEmailReminderEnable];
    
    [test testGetUpdateSchedule];
    
    
#else
    

    
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
