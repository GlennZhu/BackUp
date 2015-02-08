//
//  AppDelegate.m
//  OwlExpress
//
//  Created by Beck Chen on 1/30/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "AppDelegate.h"
#import "AWSCore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set up AWS
    NSString * ACCESS_KEY_ID = @"AKIAJXLZ7RTIESCHWUKQ";
    NSString * SECRET_KEY = @"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";
    
    AWSStaticCredentialsProvider *cred = [AWSStaticCredentialsProvider credentialsWithAccessKey:ACCESS_KEY_ID secretKey:SECRET_KEY];
    AWSServiceConfiguration *config = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSWest2 credentialsProvider:cred];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = config;
    
    // Customize UITabBar
    UIColor *tintColor = [UIColor colorWithRed:1.0 green:204.0/255.0 blue:51.0/255.0 alpha:1.0];
    [[UITabBar appearance] setBackgroundImage:[AppDelegate imageFromColor:[UIColor blackColor] forSize:CGSizeMake(320, 49) withCornerRadius:0]];
    [[UITabBar appearance] setTintColor:tintColor];
    
    // Customize UITabBarItem
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"Bradley Hand" size:10.0f]};
    [[UITabBarItem appearance] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    // Customize UINavigationBar
    [[UINavigationBar appearance] setBarTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Bradley Hand" size:20.0]}];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"return"]];
    
    return YES;
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
