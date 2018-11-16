#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NYSMainPageViewController.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate (Drcategory)
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions DRCategory:(NSString *)DRCategory;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken DRCategory:(NSString *)DRCategory;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error DRCategory:(NSString *)DRCategory;
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification DRCategory:(NSString *)DRCategory;
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler DRCategory:(NSString *)DRCategory;
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler DRCategory:(NSString *)DRCategory;
- (void)applicationWillResignActive:(UIApplication *)application DRCategory:(NSString *)DRCategory;
- (void)applicationDidEnterBackground:(UIApplication *)application DRCategory:(NSString *)DRCategory;
- (void)applicationWillEnterForeground:(UIApplication *)application DRCategory:(NSString *)DRCategory;
- (void)applicationDidBecomeActive:(UIApplication *)application DRCategory:(NSString *)DRCategory;
- (void)applicationWillTerminate:(UIApplication *)application DRCategory:(NSString *)DRCategory;

@end
