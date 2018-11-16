//
//  NYSPopView.m
//  CrazyGuessFigure
//
//  Created by 倪永胜 on 2018/11/6.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSPopView.h"

@implementation NYSPopView

- (instancetype)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 半透明遮罩
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = frame;
        
        UIImageView *doSignImageView = [[UIImageView alloc] init];
        [doSignImageView setImage:[UIImage imageNamed:imageName]];
        doSignImageView.layer.cornerRadius = 10.f;
        doSignImageView.clipsToBounds = YES;
        doSignImageView.frame = CGRectMake(0, ScreenHeight/2 - (ScreenWidth * 0.9)/2, ScreenWidth, ScreenWidth);
        [effectView.contentView addSubview:doSignImageView];
        [self addSubview:effectView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WS(weakSelf);
    [UIView transitionWithView:self.superview
                      duration:.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ {
                        [weakSelf removeFromSuperview];
                    } completion:nil];
}

@end
