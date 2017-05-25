//
//  UIView+BlurredImage.m
//

#import "UIView+BlurredImage.h"
#import "UIImage+ImageEffects.h"

@implementation UIView (BlurredImage)

- (CGFloat)degreesFromCurrentOrientation {
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationLandscapeLeft:
            return 90.0f;
        case UIInterfaceOrientationLandscapeRight:
            return -90.0f;
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180.0f;
        case UIInterfaceOrientationPortrait:
        default:
            return 0.0f;
    }
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if ([self isKindOfClass:[UIWindow class]]) {
        snapshotImage = [snapshotImage rotateByDegrees:[self degreesFromCurrentOrientation]];
    }
    return snapshotImage;
}

- (UIImage *)blurredImage {
    return [[self snapshotImage] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:0 maskImage:nil];
}

- (UIImage *)imageWithBlur {
    return [[self snapshotImage] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:0 maskImage:nil];
}

- (UIImage *)imageWithDarkEffect {
    return [[self snapshotImage] applyDarkEffect];
}

- (UIImage *)imageWithLightEffect {
    return [[self snapshotImage] applyLightEffect];
}

- (UIImage *)imageWithExtraLightEffect {
    return [[self snapshotImage] applyExtraLightEffect];
}

- (UIImage *)imageWithTint:(UIColor *)color {
    return [[self snapshotImage] applyTintEffectWithColor:color];
}

@end
