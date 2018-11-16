#import <Foundation/Foundation.h>
#import "NYSHelp.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NYSHelp (Drcategory)
+ (void)sharedScreenShotDrcategory:(NSString *)DRCategory;
+ (void)allocWithZone:(struct _NSZone *)zone DRCategory:(NSString *)DRCategory;
- (void)copyWithZone:(NSZone *)zone DRCategory:(NSString *)DRCategory;
- (void)embedApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions DRCategory:(NSString *)DRCategory;
- (void)userDidTakeScreenshot:(NSNotification *)notification DRCategory:(NSString *)DRCategory;
- (void)timerStepStartDrcategory:(NSString *)DRCategory;
- (void)imageWithScreenshotDrcategory:(NSString *)DRCategory;
- (void)dataWithScreenshotInPNGFormatDrcategory:(NSString *)DRCategory;
- (void)deallocDrcategory:(NSString *)DRCategory;
+ (void)playButtonEventWithFileName:(NSString *)fileName DRCategory:(NSString *)DRCategory;
+ (void)getUserGameRecordDrcategory:(NSString *)DRCategory;

@end
