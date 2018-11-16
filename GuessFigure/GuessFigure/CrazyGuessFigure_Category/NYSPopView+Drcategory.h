#import <UIKit/UIKit.h>
#import "NYSPopView.h"

@interface NYSPopView (Drcategory)
- (void)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName DRCategory:(NSString *)DRCategory;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event DRCategory:(NSString *)DRCategory;

@end
