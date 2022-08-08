//
//  MainTabBarViewController.m
//  AudioDemo
//
//  Created by dcf on 2022/7/28.
//

#import "MainTabBarViewController.h"
#import "KFAudioCaptureViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //去掉UITabBarController上面的黑色线条
    self.tabBar.barStyle = UIBarStyleBlack;
    
    //设置UITabBarController的颜色
    [UITabBar appearance].translucent = NO;
    
    UIColor * tintColor = [UIColor whiteColor];
    
    [[UITabBar appearance] setBarTintColor:tintColor];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
