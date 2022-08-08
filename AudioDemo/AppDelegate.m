//
//  AppDelegate.m
//  AudioDemo
//
//  Created by dcf on 2022/7/27.
//

#import "AppDelegate.h"
#import "KFAudioEncoderViewController.h"
#import "BaseNavViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.lightGrayColor;
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:[KFAudioEncoderViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
