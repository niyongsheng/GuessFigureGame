#import <UIKit/UIKit.h>
#import "NYSMainPageViewController.h"
#import "NYSGuessPageViewController.h"
#import <StoreKit/StoreKit.h>

@interface NYSMainPageViewController (Drcategory)
- (void)viewWillAppear:(BOOL)animated DRCategory:(NSString *)DRCategory;
- (void)viewDidLoadDrcategory:(NSString *)DRCategory;
- (void)idiomClicked:(id)sender DRCategory:(NSString *)DRCategory;
- (void)starClicked:(id)sender DRCategory:(NSString *)DRCategory;
- (void)carLogoClicked:(id)sender DRCategory:(NSString *)DRCategory;
- (void)protocol:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)grade:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)openScheme:(NSString *)scheme DRCategory:(NSString *)DRCategory;
- (void)loadAppStoreControllerWithAppID:(NSString *)appID DRCategory:(NSString *)DRCategory;
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController DRCategory:(NSString *)DRCategory;
- (void)shakeToShow:(UIButton *)button DRCategory:(NSString *)DRCategory;

@end
