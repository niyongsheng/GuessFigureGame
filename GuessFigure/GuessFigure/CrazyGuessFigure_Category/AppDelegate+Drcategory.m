#import "AppDelegate+Drcategory.h"
@implementation AppDelegate (Drcategory)
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)applicationWillResignActive:(UIApplication *)application DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)applicationDidEnterBackground:(UIApplication *)application DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)applicationWillEnterForeground:(UIApplication *)application DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)applicationDidBecomeActive:(UIApplication *)application DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)applicationWillTerminate:(UIApplication *)application DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}

@end
