#import <UIKit/UIKit.h>
#import "NYSGuessPageViewController.h"
#import "NYSQuestionModel.h"
#import "NYSPopView.h"
#import <objc/runtime.h>

@interface NYSGuessPageViewController (Drcategory)
- (void)viewDidLoadDrcategory:(NSString *)DRCategory;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context DRCategory:(NSString *)DRCategory;
- (void)deallocDrcategory:(NSString *)DRCategory;
- (void)questionsDrcategory:(NSString *)DRCategory;
- (void)nextQuestion:(id)sender DRCategory:(NSString *)DRCategory;
- (void)settingData:(NYSQuestionModel *)question DRCategory:(NSString *)DRCategory;
- (void)addAnswerBtn:(NYSQuestionModel *)question DRCategory:(NSString *)DRCategory;
- (void)answerClick:(UIButton *)answerBtn DRCategory:(NSString *)DRCategory;
- (void)addOptionBtn:(NYSQuestionModel *)question DRCategory:(NSString *)DRCategory;
- (void)btnRotate:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)shakeToShow:(UIButton *)button DRCategory:(NSString *)DRCategory;
- (void)shake2ToShow:(UIButton *)button DRCategory:(NSString *)DRCategory;
- (void)btnSelect:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)beginClick:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)optionClick:(UIButton *)optionBtn DRCategory:(NSString *)DRCategory;
- (void)backDrcategory:(NSString *)DRCategory;
- (void)questionImageClicked:(UIButton *)sender DRCategory:(NSString *)DRCategory;
- (void)tip:(id)sender DRCategory:(NSString *)DRCategory;
- (void)help:(id)sender DRCategory:(NSString *)DRCategory;

@end
