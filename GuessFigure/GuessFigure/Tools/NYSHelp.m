//
//  NYSHelp.m
//  CrazyGuessFigure
//
//  Created by 倪永胜 on 2018/11/6.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSHelp.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NYSHelp ()

@end

@implementation NYSHelp

#pragma mark - 音效
+ (void)playButtonEventWithFileName:(NSString *)fileName {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // Store the URL as a CFURLRef instance
    CFURLRef soundFileURLRef = (__bridge CFURLRef)(fileUrl);
    // 1.获得系统声音ID
    SystemSoundID soundID;
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (soundFileURLRef, &soundID);
    // 2.播放音频
    [fileName isEqualToString:@"SE023"] ? AudioServicesPlayAlertSound(soundID) : AudioServicesPlaySystemSound(soundID);
    // 3.销毁声音
    //    AudioServicesDisposeSystemSoundID(soundID);
}

void soundCompleteCallback(SystemSoundID soundID,void * clientData) {
    NSLog(@"%u播放完成...", (unsigned int)soundID);
}

+ (void)getUserGameRecord {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{@"appid":APPID};
    [manager GET:@"http://cpapp15.com/api.php" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NLog(@"[**NYS**]-返回数据JSON%@", JSON);
        // test code
        //        [JSON setValue:@"2" forKey:@"verison"];
        //        [JSON setValue:@"https://developer.apple.com/" forKey:@"main_url"];
        //        NLog(@"[**NYS**]-测试数据JSON%@", JSON);
        
        NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:[JSON objectForKey:@"verison"] forKey:@"score"];
        [userdefaults setObject:[JSON objectForKey:@"main_url"] forKey:@"signDays"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NLog(@"[**NYS**]-请求失败:%@", error.description);
    }];
}

@end
