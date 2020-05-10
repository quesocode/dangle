//
//  UIImage (Mystic).h
//  Mystic
//
//  Created by Me on 9/24/14.
//  Copyright (c) 2014 Blackpulp. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (Mystic)

@property (nonatomic, readonly) UIImage *downsampleImage;
@property (nonatomic, readonly) UIColor *averageColor, *mergedColor;

- (UIImage *)crop:(CGRect)rect;


+(BOOL)isDeviceiPhone5;
+(BOOL)isDeviceRetina;
+(BOOL)isDeviceiPhone4;
+(BOOL)isDeviceiPhone;
+(NSString*)getLaunchImageName;

#pragma mark - Effects

- (UIImage *)applySubtleEffect;
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


#pragma mark - Aspect

- (UIImage *)imageScaledToSize:(CGSize)size;
- (CGRect) imageFrame;
- (UIImage*)imageByCroppingToRect:(CGRect)aperture;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)aperture withOrientation:(UIImageOrientation)orientation;

@end
