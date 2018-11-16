#import "NYSPopView+Drcategory.h"
@implementation NYSPopView (Drcategory)
- (void)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event DRCategory:(NSString *)DRCategory {
    NSLog(@"%@", DRCategory);
}

@end
