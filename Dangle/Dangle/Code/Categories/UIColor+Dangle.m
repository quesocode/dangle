//
//  UIColor+DangleColor.m
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "UIColor+Dangle.h"

#define DEFAULT_VOID_COLOR	nil

@implementation UIColor (Dangle)

+ (instancetype) defaultBubbleColor;
{
    return [UIColor colorWithRed:0.73 green:0.5 blue:0.77 alpha:1];
}

+ (instancetype) defaultOutgoingBubbleColor;
{
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
}



+ (instancetype) hex: (NSString *) hexString;
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //    if([cString length] > 6)
    //    {
    //        cString = [cString substringToIndex:6];
    //    }
    
    if([cString length] == 3)
    {
        cString = [NSString stringWithFormat:@"%@%@", cString, cString];
    }
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    unsigned int a = 255;
    NSRange range;
    if ([cString length] == 8)
    {
        
        range.location = 0;
        range.length = 2;
        NSString *aString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        
        cString = [cString substringFromIndex:2];
        
    }
    
    
    
    
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    // Separate into r, g, b substrings
    
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:(float) a / 255.0f];
}

- (BOOL)isEqualToColor:(UIColor *)color;
{
    if(self.red != color.red || self.blue != color.blue || self.green != color.green || self.alpha != color.alpha) return NO;
    return YES;
}


- (CGColorSpaceModel) colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL) canProvideRGBComponents
{
    return (([self colorSpaceModel] == kCGColorSpaceModelRGB) ||
            ([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat) red
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat) green
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat) blue
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat) alpha
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    NSInteger num = CGColorGetNumberOfComponents(self.CGColor);
    
    if(num == 2) return c[1];
    return num > 3 ? c[num-1] : 1.0;
}

- (NSString *) hexString;
{
    CGFloat am = MAX(self.alpha, 0);
    CGFloat rm = MAX(self.red, 0);
    CGFloat gm = MAX(self.blue, 0);
    CGFloat bm = MAX(self.green, 0);
    
    CGFloat a = MIN(am, 1);
    CGFloat r = MIN(rm, 1);
    CGFloat g = MIN(gm, 1);
    CGFloat b = MIN(bm, 1);
    
    // Convert to hex string between 0x00 and 0xFF
    return [NSString stringWithFormat:@"0x%02lX%02lX%02lX%02lX",
            (long)(a * 255), (long)(r * 255), (long)(g * 255), (long)(b * 255)];
    
}
@end
