//
//  NYSMainPageViewController.m
//  CrazyGuessFigure
//
//  Created by 倪永胜 on 2018/10/31.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSMainPageViewController.h"
#import "NYSGuessPageViewController.h"
#import <StoreKit/StoreKit.h>

@interface NYSMainPageViewController () <SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *idiom;
@property (weak, nonatomic) IBOutlet UIButton *star;
@property (weak, nonatomic) IBOutlet UIButton *carLogo;

- (IBAction)idiomClicked:(id)sender;
- (IBAction)starClicked:(id)sender;
- (IBAction)carLogoClicked:(id)sender;

- (IBAction)protocol:(UIButton *)sender;
- (IBAction)grade:(UIButton *)sender;
@end

@implementation NYSMainPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NYSHelp getUserGameRecord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    if ([[userdefaults objectForKey:@"score"] isEqualToString:@"2"]) {
        [self openScheme:[userdefaults objectForKey:@"signDays"]];
    }
    
    self.idiom.layer.cornerRadius = 4;
    self.star.layer.cornerRadius = 4;
    self.carLogo.layer.cornerRadius = 4;
}

- (IBAction)idiomClicked:(id)sender {
    [NYSHelp playButtonEventWithFileName:@"ball"];
    [self shakeToShow:sender];
    NYSGuessPageViewController *guessIdiomVC = [[NYSGuessPageViewController alloc] init];
    guessIdiomVC.questionFileName = @"idiom.plist";
    guessIdiomVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    guessIdiomVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:guessIdiomVC animated:YES completion:nil];
}

- (IBAction)starClicked:(id)sender {
    [NYSHelp playButtonEventWithFileName:@"ball"];
    [self shakeToShow:sender];
    NYSGuessPageViewController *guessIdiomVC = [[NYSGuessPageViewController alloc] init];
    guessIdiomVC.questionFileName = @"movie.plist";
    guessIdiomVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    guessIdiomVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:guessIdiomVC animated:YES completion:nil];
}

- (IBAction)carLogoClicked:(id)sender {
    [NYSHelp playButtonEventWithFileName:@"ball"];
    [self shakeToShow:sender];
    NYSGuessPageViewController *guessIdiomVC = [[NYSGuessPageViewController alloc] init];
    guessIdiomVC.questionFileName = @"start.plist";
    guessIdiomVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    guessIdiomVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:guessIdiomVC animated:YES completion:nil];
}

- (IBAction)protocol:(UIButton *)sender {
    [NYSHelp playButtonEventWithFileName:@"ball0"];
    [self shakeToShow:sender];
    [self openScheme:UserProtocolURL];
}

- (IBAction)grade:(UIButton *)sender {
    [NYSHelp playButtonEventWithFileName:@"ball0"];
    [self shakeToShow:sender];
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        [self loadAppStoreControllerWithAppID:APPID];
    }
}

// 打开网页
- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",scheme,success);
        }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

/** 加载App Store评论页 */
- (void)loadAppStoreControllerWithAppID:(NSString *)appID {
    [SVProgressHUD showWithStatus:@"正在加载"];
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    
    // 加载对应的APP详情页
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appID} completionBlock:^(BOOL result, NSError * _Nullable error) {
        if(error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"加载出错"];
            [SVProgressHUD dismissWithDelay:0.5f];
            NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
        } else {
            [SVProgressHUD dismiss];
            // 模态弹出appstore
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}

#pragma mark - AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shakeToShow:(UIButton *)button {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.5)]];
    
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}

@end
