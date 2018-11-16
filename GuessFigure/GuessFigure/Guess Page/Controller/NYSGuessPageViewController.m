//
//  NYSGuessPageViewController.m
//  CrazyGuessFigure
//
//  Created by 倪永胜 on 2018/10/31.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSGuessPageViewController.h"
#import "NYSQuestionModel.h"
#import "NYSPopView.h"
#import <objc/runtime.h>

@interface NYSGuessPageViewController ()

- (IBAction)tip:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)nextQuestion:(id)sender;
- (IBAction)back;

/** 分数 */
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
/** 存放正确答案 */
@property (weak, nonatomic) IBOutlet UIView *answerView;
/** 待选项 */
@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@property (weak, nonatomic) IBOutlet UILabel *UILabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *questionImage;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;

/** 题目数组 */
@property (nonatomic, strong) NSMutableArray *questions;
/** 题目索引 */
@property (nonatomic, assign) NSInteger index;
/** 分数 */
@property (nonatomic, assign) NSInteger scores;
@property (nonatomic, strong) UILabel *label;

@end

@implementation NYSGuessPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // KVO监听分数
    [self addObserver:self forKeyPath:@"scores" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    // 截屏动画使用
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.backgroundColor = [UIColor whiteColor];
    label.alpha = 1.0;
    self.label = label;
    self.scores = [self.scoreBtn titleForState:UIControlStateNormal].intValue;
    
    // 索引默该为-1，app默认image设置成模型里第一张image
    self.index = -1;
    [self nextQuestion:[[UIButton alloc] init]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 判断是否为self.myKVO的属性“num”:
    if([keyPath isEqualToString:@"scores"] && object == self) {
        // 响应变化处理：UI更新
        [self.scoreBtn setTitle:[NSString stringWithFormat:@"%ld",self.scores] forState:UIControlStateNormal];
        if (self.scores <= 0) {
            WS(weakSelf);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示📌" message:@"你的积分输光了，请重新开始！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf back];
            }]];
        }
        NSLog(@"\\noldnum:%@ newnum:%@",
              [change valueForKey:@"old"],
              [change valueForKey:@"new"]);
    }
}

- (void)dealloc {
    /* 移除KVO */
    [self removeObserver:self forKeyPath:@"scores" context:nil];
}

// 题目的懒加载
- (NSMutableArray *)questions {
    if (_questions == nil) {
        _questions = [NYSQuestionModel mj_objectArrayWithFilename:self.questionFileName];
    }
    return _questions;
}

// 下一题
- (IBAction)nextQuestion:(id)sender {
    if (self.index != -1) { [NYSHelp playButtonEventWithFileName:@"SE005"]; }
    [self beginClick:sender];
    // 判读是否为最后一题
    if(self.index == self.questions.count - 1) {
        [NYSHelp playButtonEventWithFileName:@"huanhu"];
        // 创建弹窗
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜🎉" message:@"恭喜你通关了，敬请期待后续更新！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        // 监听确定按钮点击
        WS(weakSelf);
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf back];
        }]];
        
        return;
    }
    
    // 1.增加索引
    self.index++;
    
    // 2.取出模型
    NYSQuestionModel *question = self.questions[self.index];
    
    // 3.设置控件的数据
    [self settingData:question];
    
    // 4.添加正确答案
    [self addAnswerBtn:question];
    
    // 5.添加答案备选项
    [self addOptionBtn:question];
}

/**
 设置控件数据
 
 @param question 控件数据
 */
- (void)settingData:(NYSQuestionModel *)question
{
    // 3.1设置序%lu
    self.UILabel.text = [NSString stringWithFormat:@"%ld/%ld", self.index + 1, self.questions.count];
    
    // 3.2设置标题
    self.titleLabel.text = question.title;
    NSLog(@"%@",self.titleLabel.text);
    
    // 3.3设置图片
    [UIView transitionWithView:self.questionImage
                      duration:.5f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^ { [self.questionImage setBackgroundImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal]; }
                    completion:nil];
    objc_setAssociatedObject(_questionImage, @"imageName", question.icon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.questionImage addTarget:self action:@selector(questionImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.4设置下一题按钮的状态
    self.nextQuestionBtn.enabled = self.index != self.questions.count - 1;
}

/**
 添加正确答案
 @param question 正确答案
 */
- (void)addAnswerBtn:(NYSQuestionModel *)question
{
    // 5.1删除之前所有答案提示框
    // 让数组中所有对象都执行removeFromSuperview
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; // 等效下面for循环
    //    for (UIView *subview in self.answerView.subviews)
    //    {
    //        [subview removeFromSuperview];
    //    }
    
    // 5.2添加一个答案提示框
    NSUInteger length = question.answer.length;
    for (int i = 0; i < question.answer.length; i++ ) {
        UIButton *answerBtn = [[UIButton alloc] init];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置背景色
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"wordBackground"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"wordBackground"] forState:UIControlStateHighlighted];
        // 设置frame
        CGFloat margin = 10;
        CGFloat answerW = self.answerView.frame.size.height;
        CGFloat answerH = answerW;
        CGFloat firstAnswerX = (ScreenWidth - length *answerW - margin * (length - 1)) / 2;
        CGFloat answerX = firstAnswerX + i * (answerW + margin);
        answerBtn.frame = CGRectMake(answerX, 0, answerW, answerH);
        
        // 添加到view
        [self.answerView addSubview:answerBtn];
        
        // 监听点击
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)answerClick:(UIButton *)answerBtn
{
    // 让所有的待选按钮能被点击
    for (UIButton *optionBtn in self.optionView.subviews) {
        optionBtn.enabled = YES;
    }
    
    // 1.让答案备选项重新显示出来
    for (UIButton *optionBtn in self.optionView.subviews) {
        // 答案按钮的文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal]; // 等效：NSString *answerTitle = answerBtn.currentTitle;
        
        // 待选按钮的文字
        NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
        
        if ([optionTitle isEqualToString:answerTitle] && optionBtn.hidden == YES) { // 找到了跟答案按钮一样的待选按钮
            optionBtn.hidden = NO;
            break;
        }
    }
    
    // 2.被点击的答案文字消失
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    
    // 3.让所有的答案按钮变为黑色
    for (UIButton *answerBtn in self.answerView.subviews) {
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

/**
 添加答案备选项
 
 @param question 答案备选项
 */
- (void)addOptionBtn:(NYSQuestionModel *)question
{
    WS(weakSelf);
    // 6.1删除之前所有答案备选项
    for (UIView *subview in self.optionView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 6.2添加答案备选项
    NSUInteger count = question.options.count;
    for (NSUInteger i = 0; i < count; i++) {
        // 6.2.1创建按钮
        UIButton *optionBtn = [[UIButton alloc] init];
        
        // 6.2.2设置背景色
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"wordBackground"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"wordBackground"] forState:UIControlStateHighlighted];
        
        // 6.2.3设置frame
        CGFloat optionW = 50;
        CGFloat optionH = optionW;
        CGFloat margin = (ScreenWidth - optionW * 7) / 8;
        //CGFloat viewW = self.view.frame.size.width;
        
        NSUInteger col = i % 7;
        CGFloat optionX = margin + col * (optionW + margin);
        
        NSUInteger row = i / 7;
        CGFloat optionY = row *(optionH + margin);
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        
        // 6.2.4设置文字
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 6.2.5添加到view
        [UIView transitionWithView:optionBtn
                          duration:.5f
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^ { [weakSelf.optionView addSubview:optionBtn]; }
                        completion:nil];
        //        [self btnRotate:optionBtn];
        [self shakeToShow:optionBtn];
        
        // 6.2.6监听点击答案备选项
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


/** 旋转 */
- (void)btnRotate:(UIButton *)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    int rotate = sender.tag == 7? 1: -1;
    sender.transform = CGAffineTransformRotate(sender.transform, M_PI_4*rotate);
    [UIView commitAnimations];
}

/** 自定义节奏缩放1 */
- (void)shakeToShow:(UIButton *)button {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}

/** 自定义节奏缩放2 */
- (void)shake2ToShow:(UIButton *)button {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .17f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}

#pragma mark --- 震动动画
- (void)btnSelect:(UIButton *)sender {
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    sender.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        sender.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                sender.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma mark --- 抖动动画
- (void)beginClick:(UIButton *)sender {
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.37;
    keyAnimaion.repeatCount = 0;
    [sender.layer addAnimation:keyAnimaion forKey:nil];
}

/** 监听点击答案备选项 */
- (void)optionClick:(UIButton *)optionBtn {
    [NYSHelp playButtonEventWithFileName:@"ball0"];
    // 1.被点击后消失
    optionBtn.hidden = YES;
    
    // 2.显示文字到正确答案上
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字
            // 设置答案按钮的文字为备选项按钮的文字
            NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            break; // 停止遍历
        }
    }
    // 3.检测答案是否填满
    BOOL full = YES;
    NSMutableString *tempAnswerTitle = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字
            full = NO;
            //break; // 停止遍历
        }
        // 拼接按钮文字
        if (answerTitle) {
            [tempAnswerTitle appendString:answerTitle];
        }
    }
    // 4.答案已经满了
    if(full){
        // 让所有的待选按钮不能被点击
        for (UIButton *optionBtn in self.optionView.subviews) {
            optionBtn.enabled = NO;
        }
        
        NYSQuestionModel *question = self.questions[self.index];
        
        if ([tempAnswerTitle isEqualToString:question.answer]) { // 答对了
            [NYSHelp playButtonEventWithFileName:@"luo"];
            NSLog(@"正确");
            // 显示文字为绿色
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor colorWithRed:0.24 green:0.75 blue:0.49 alpha:1.00] forState:UIControlStateNormal];
            }
            
            // 加分
            self.scores += 500;
            
            // 延时一秒进入下一题
            [self performSelector:@selector(nextQuestion:) withObject:nil afterDelay:0.5];
            
        } else {
            [NYSHelp playButtonEventWithFileName:@"SE023"];
            NSLog(@"错误");
            // 显示文字为红色
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor colorWithRed:0.90 green:0.27 blue:0.18 alpha:1.00] forState:UIControlStateNormal];
                [self btnSelect:answerBtn];
            }
        }
    }
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)questionImageClicked:(UIButton *)sender {
    NYSPopView *view = [[NYSPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) andImageName:objc_getAssociatedObject(sender, @"imageName")];
    // 转场动画
    WS(weakSelf);
    [UIView transitionWithView:self.view
                      duration:.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [weakSelf.view addSubview:view]; }
                    completion:nil];
}

- (IBAction)tip:(id)sender {
    [NYSHelp playButtonEventWithFileName:@"SE005"];
    [self beginClick:sender];
    // 1.点击所有答案按钮让答案回位
    for(UIButton *answerBtn in self.answerView.subviews){
        [self answerClick:answerBtn];
    }
    
    // 2.取出第一个答案文字并显示出来
    NYSQuestionModel *question = self.questions[self.index];
    
    // 截取答案的第一个字
    NSString *firstAnswer = [question.answer substringToIndex:1];
    NSLog(@"%@",firstAnswer);
    for(UIButton *optionBtn in self.optionView.subviews){
        if ([optionBtn.currentTitle isEqualToString:firstAnswer]) {
            [self optionClick:optionBtn];
            break;
        }
    }
    
    // 3.减分
    self.scores -= 1000;
}

- (IBAction)help:(id)sender {
    [NYSHelp playButtonEventWithFileName:@"SE005"];
    [self beginClick:sender];
    
    WS(weakSelf);
    [UIView animateWithDuration:1.2f animations:^{
        [self.view addSubview:weakSelf.label];
        weakSelf.label.alpha = 0;
        
    }completion:^(BOOL finished) {
        weakSelf.label.alpha = 1.0;
        [weakSelf.label removeFromSuperview];
    }];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view.layer renderInContext:context];
    UIImage * shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *shareText = @"帮助";
    //    NSURL *shareURL = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, nil];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"%@",activityType);
        if (completed) {
            NSLog(@"分享成功");
        } else {
            NSLog(@"分享失败");
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
