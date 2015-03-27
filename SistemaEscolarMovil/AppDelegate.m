//
//  AppDelegate.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityLogger.h"

@interface AppDelegate ()
@end

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [ZeroPush engageWithAPIKey:@"iosdev_xhtqe3444berxEqfYhgX" delegate:self];

    //now ask the user if they want to recieve push notifications. You can place this in another part of your app.

    
}




-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];

    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenData
{
    // Call the convenience method registerDeviceToken, this helps us track device tokens for you
    [[ZeroPush shared] registerDeviceToken:tokenData];
    
    // This would be a good time to save the token and associate it with a user that you want to notify later.
    NSString *tokenString = [ZeroPush deviceTokenFromData:tokenData];
    NSLog(@"%@", tokenString);
    
    

    // For instance you can associate it with a user's email address
    // [[ZeroPush shared] subscribeToChannel:@"user@example.com"];
    // You can then use the /broadcast endpoint to notify all devices subscribed to that email address. No need to save tokens!
    // Don't forget to unsubscribe from the channel when the user logs out of your app!
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
    //Common reason for errors:
    //  1.) Simulator does not support receiving push notifications
    //  2.) User rejected push alert
    //  3.) "no valid 'aps-environment' entitlement string found for application"
    //      This means your provisioning profile does not have Push Notifications configured. https://zeropush.com/documentation/generating_certificates
}

@end
