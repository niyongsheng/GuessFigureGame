//
//  NYSQuestionModel.h
//  CrazyGuessFigure
//
//  Created by 倪永胜 on 2018/10/31.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSQuestionModel : NSObject

/** 答案 */
@property (nonatomic, copy) NSString *answer;
/** 题目 */
@property (nonatomic, copy) NSString *title;
/** 图片 */
@property (nonatomic, copy) NSString *icon;
/** 选项 */
@property (nonatomic, strong) NSArray *options;

@end

NS_ASSUME_NONNULL_END
