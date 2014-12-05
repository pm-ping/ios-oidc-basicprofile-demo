//
//  UserInfoAppAppDelegate.m
//  Copyright (c) 2013 Ping Identity. All rights reserved.
//

#import "UserInfoAppAppDelegate.h"
#import "UserInfoAppCurrentSession.h"

@implementation UserInfoAppAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // This will handle the app call back from when we redirect out to Safari and return back into the app:
    //  - Implicit grant type - com.pingidentity.OIDCUserInfoApp://oidc_callback
    
    if (!url) {
        // The URL is nil. There's nothing more to do.
        NSLog(@"Received a message in handleOpenURL (app callback) for URL: No URL specified!");
        return NO;
    }
    
    NSLog(@"Received a message in handleOpenURL (app callback) for URL: %@", [url absoluteURL]);
    
    if ([[url host] isEqualToString:@"oidc_callback"])
    {
        NSLog(@"Handling a callback for an authorization code grant type");
        
        [[UserInfoAppCurrentSession session].OIDCBasicProfile processCallback:[url query]];
        
        if([[UserInfoAppCurrentSession session] inErrorState])
        {
            // Error - handle it
            NSString *errorText = [[[[UserInfoAppCurrentSession session] getLastError] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            NSLog(@"An error occurred: %@", errorText);
        } else {
            // Call back to swap the code for the token(s)
            [[UserInfoAppCurrentSession session].OIDCBasicProfile swapCodeForToken];
            
            // All done.  Next step is to call the UserInfo endpoint which we will do back in the ViewController
        }
        
    }
    
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    return YES;
}

@end
