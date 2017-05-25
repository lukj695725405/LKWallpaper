//
//  UIView+BlurredImage.h
//

#import <UIKit/UIKit.h>

@interface UIView (BlurredImage)
- (UIImage *)blurredImage;

- (UIImage *)imageWithBlur;

- (UIImage *)imageWithDarkEffect;

- (UIImage *)imageWithLightEffect;

- (UIImage *)imageWithExtraLightEffect;

- (UIImage *)imageWithTint:(UIColor *)color;
@end
