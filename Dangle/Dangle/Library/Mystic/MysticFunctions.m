//
//  MysticFunctions.m
//  Mystic
//
//  Created by Me on 3/18/15.
//  Copyright (c) 2015 Mystic. All rights reserved.
//

#import "MysticFunctions.h"
#import "NSString+Mystic.h"



#pragma mark - Color

NSString *ColorToString(UIColor *color) {
    if(!color) return @"Color == nil";
    const CGFloat *c = CGColorGetComponents(color.CGColor);

    
    return [NSString stringWithFormat:@"(%2.2f, %2.2f, %2.2f, %2.2f)", c[0], c[1], c[2], c[3]];
}





#pragma mark - Logs

void ILog(NSString *name, UIImage *img) {
    if(!img)
    {
        DLog(@"%@ | No Image Found", name);
        return;
    }
    DLog(@"%@ | %@", name, ILogStr(img));
}
void FLog(NSString *name, CGRect frame) {
    
    DLog(@"%@ | %2.2f, %2.2f | %2.2fx%2.2f", name, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}
void SLog(NSString *name, CGSize size) {
    DLog(@"%@ | %2.2fx%2.2f", name, size.width, size.height);
}
void PLog(NSString *name, CGPoint origin) {
    DLog(@"%@ | %2.4f, %2.4f", name, origin.x, origin.y);
}
void NoLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    format = [@"\n-----------------------------------------\n" stringByAppendingString:[format stringByAppendingString:@"\n\n"]];
    NSString *formattedString = [[NSString alloc] initWithFormat: format
                                                       arguments: args];
    va_end(args);
    [[NSFileHandle fileHandleWithStandardOutput]
     writeData: [formattedString dataUsingEncoding: NSNEXTSTEPStringEncoding]];
}
NSString *FLogStr(CGRect frame) {
    return CGRectEqualToRect(frame, CGRectInfinite) ? @"CGRectInfinite" : [NSString stringWithFormat:@"%2.1f, %2.1f | %2.1fx%2.1f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}
NSString *FLogStrd(CGRect frame, int depth) {
    NSString *strFormat = [NSString stringWithFormat:@"%%2.%df, %%2.%df | %%2.%dfx%%2.%df", depth, depth, depth, depth];
    
    return CGRectEqualToRect(frame, CGRectInfinite) ? @"CGRectInfinite" : [NSString stringWithFormat:strFormat, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}
NSString *EdgeLogStr(UIEdgeInsets insets) {
    return [NSString stringWithFormat:@"top: %2.2f  |  left: %2.2f  |  bottom: %2.2f  |  right: %2.2f", insets.top, insets.left, insets.bottom, insets.right];
}
NSString *SLogStr(CGSize size) {
    return [NSString stringWithFormat:@"%2.1fx%2.1f",  size.width, size.height];
}
NSString *SLogStrd(CGSize size, int depth) {
    NSString *strFormat = [NSString stringWithFormat:@"%%2.%df x %%2.%df", depth, depth];
    return [NSString stringWithFormat:strFormat,  size.width, size.height];
}
NSString *PLogStr(CGPoint origin) {
    return [NSString stringWithFormat:@"%2.1f, %2.1f",  origin.x, origin.y];
}
NSString *PLogStrd(CGPoint origin, int depth) {
    NSString *strFormat = [NSString stringWithFormat:@"%%2.%df, %%2.%df", depth, depth];
    return [NSString stringWithFormat:strFormat,  origin.x, origin.y];
}
NSString *ILogStr(UIImage *img) {
    if(!img)
    {
        return [NSString stringWithFormat:@"No Image Found"];
    }
    if(![img isKindOfClass:[UIImage class]])
    {
        return [NSString stringWithFormat:@"ILogStr: Obj is not an image: (%@) %@", [img class], img];
    }
    
    return [NSString stringWithFormat:@"<%p> Orientation: %@ | scale: %2.1f | size: %2.1fx%2.1f | pixels: %2.1zux%2.1zu", img, ImageOrientationToString(img.imageOrientation), img.scale, img.size.width, img.size.height, CGImageGetWidth(img.CGImage), CGImageGetHeight(img.CGImage)];
}
NSString *ImageOrientationToString (UIImageOrientation imageOrientation) {
    NSString *orientation;
    switch (imageOrientation) {
            
        case UIImageOrientationUp:
            orientation = @"up";
            break;
        case UIImageOrientationLeft:
            orientation = @"left";
            break;
        case UIImageOrientationRight:
            orientation = @"right";
            break;
        case UIImageOrientationDown:
            orientation = @"down";
            break;
        case UIImageOrientationDownMirrored:
            orientation = @"down-mirrored";
            break;
        case UIImageOrientationUpMirrored:
            orientation = @"up-mirrored";
            break;
        case UIImageOrientationLeftMirrored:
            orientation = @"left-mirrored";
            break;
        case UIImageOrientationRightMirrored:
            orientation = @"right-mirrored";
            break;
            
        default:
            orientation = @"unknown";
            break;
    }
    return orientation;
}



#pragma mark - UIView Subview Log

NSString *DPrintViewsOf(UIView *parentView, int depth) {
    
    return DPrintSubviewsOf(parentView, YES, nil, depth, 0);
}
NSString *DPrintSubviewsOf(UIView *parentView, BOOL showDesc, NSString *prefix, int depth, int d) {
    prefix = prefix ? prefix : [@"\t" repeat:d+1];
    NSMutableString *str = [NSMutableString stringWithFormat:@"\n%@", prefix];
    if(showDesc)
    {
        [str appendFormat:@"%@ <%p>:  %lu subviews  %@\n%@---------------", [parentView class], parentView, (unsigned long)parentView.subviews.count, FLogStr(parentView.frame), prefix];
        
    }
    int i = 1;
    for (UIView *subview in parentView.subviews)
    {
        NSString *classStr = [NSStringFromClass([subview class]) stringByAppendingString:@"  "];
        classStr = [classStr stringByPaddingToLength:45 withString:@"." startingAtIndex:0];
        
        NSString *frameStr = FLogStr(subview.frame);
        frameStr = [frameStr stringByPaddingToLength:25 withString:@" " startingAtIndex:0];
        
        
        
        [str appendFormat:@"\n%@ %d:  %@ (%p) %@  |  Frame: %@ | Alpha: %2.1f | Clips: %@", prefix, i, classStr, subview, subview.hidden ? @"(hidden)" : @"", frameStr, subview.alpha, MBOOL(subview.clipsToBounds)];
        
        if(subview.subviews.count && (depth < 0 || d <= depth))
        {
            NSString *ns = DPrintSubviewsOf(subview, NO, nil, depth, d+1);
            [str appendString:ns];
        }
        
        i++;
    }
    
    [str appendString:@"\n"];
    return str;
}
NSString *DContentModeToString(UIViewContentMode cmode) {
    NSString *cModeString = @"---";
    switch (cmode) {
        case UIViewContentModeScaleAspectFill:
            cModeString = @"UIViewContentModeScaleAspectFill";
            break;
        case UIViewContentModeCenter:
            cModeString = @"UIViewContentModeCenter";
            break;
        case UIViewContentModeScaleAspectFit:
            cModeString = @"UIViewContentModeScaleAspectFit";
            break;
        case UIViewContentModeTop:
            cModeString = @"UIViewContentModeTop";
            break;
        case UIViewContentModeTopLeft:
            cModeString = @"UIViewContentModeTopLeft";
            break;
        case UIViewContentModeTopRight:
            cModeString = @"UIViewContentModeTopRight";
            break;
        case UIViewContentModeRight:
            cModeString = @"UIViewContentModeRight";
            break;
        case UIViewContentModeLeft:
            cModeString = @"UIViewContentModeLeft";
            break;
        case UIViewContentModeScaleToFill:
            cModeString = @"UIViewContentModeScaleToFill";
            break;
        case UIViewContentModeBottom:
            cModeString = @"UIViewContentModeBottom";
            break;
        case UIViewContentModeBottomLeft:
            cModeString = @"UIViewContentModeBottomLeft";
            break;
        case UIViewContentModeBottomRight:
            cModeString = @"UIViewContentModeBottomRight";
            break;
        case UIViewContentModeRedraw:
            cModeString = @"UIViewContentModeRedraw";
            break;
            
        default:
            break;
    }
    
    return cModeString;
}







#pragma mark - Value Checking

NSString *MBOOL(BOOL val) {
    return val ? @"YES" : @"NO ";
}
NSString *MBOOLStr(BOOL val) {
    return val ? @"YES" : @"NO ";
}
NSString *MObj(id val) {
    return val ? val : @"---";
}
id MNull(id val) {
    return val ? val : [NSNull null];
}
id Mor(id obj, id obj2) {
    return obj ? obj : obj2;
}
id Mord(id obj, id obj2, id def) {
    return obj ? obj : (obj2 ? obj2 : def);
}
BOOL isMBOOL(id v) {
    NSNumber * isSuccessNumber = (NSNumber *)v;
    if([isSuccessNumber boolValue] == YES)
    {
        // this is the YES case
        return YES;
    }
    return NO;
}
BOOL isMEmpty(id obj) {
    return obj==nil || [obj isKindOfClass:[NSNull class]] ? YES : NO;
}
BOOL ismt(id obj) {
    return !isM(obj);
}
BOOL isM(id obj) {
    if(isMEmpty(obj)) return NO;
    if([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) return NO;
    return YES;
}


#pragma mark - CGRect

BOOL CGRectIsZero(CGRect rect)
{
    return CGRectEqualToRect(rect, CGRectZero);
}

NSValue *CGRectMakeValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
    
}

CGRect CGRectScale(CGRect rect, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGRect r = CGRectZero;
    r.origin.x = rect.origin.x * scale;
    r.origin.y = rect.origin.y*scale;
    r.size.width = rect.size.width*scale;
    r.size.height = rect.size.height*scale;
    return r;
}
CGRect CGRectInverseScale(CGRect rect, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGRect r = CGRectZero;
    r.origin.x = rect.origin.x / scale;
    r.origin.y = rect.origin.y/scale;
    r.size.width = rect.size.width/scale;
    r.size.height = rect.size.height/scale;
    return r;
}

CGRect CGRectWithX(CGRect rect, CGFloat x) {
    CGRect n = rect;
    n.origin.x = x;
    return n;
}
CGRect CGRectWithY(CGRect rect, CGFloat y) {
    CGRect n = rect;
    n.origin.y = y;
    return n;
}
CGRect CGRectWithWidth(CGRect rect, CGFloat w) {
    CGRect n = rect;
    n.size.width = w;
    return n;
}
CGRect CGRectWithHeight(CGRect rect, CGFloat h) {
    CGRect n = rect;
    n.size.height = h;
    return n;
}
CGRect CGRectMakeWithPointSize(CGPoint point, CGSize size) {
    return CGRectMake(point.x, point.y, size.width, size.height);
}
CGRect CGRectMakeWithSize(CGSize size) {
    CGRect newRect = CGRectMake(0, 0, size.width, size.height);
    return newRect;
}

CGRect CGRectDifference(CGRect r1, CGRect r2) {
    CGSize s1 = r1.size; CGSize s2 = r2.size;
    return (CGRect){r1.origin.x - r2.origin.x, r1.origin.y-r2.origin.y, s1.width - s2.width, s1.height-s2.height};
}
CGRect CGRectDifferenceABS(CGRect r1, CGRect r2) {
    CGSize s1 = r1.size; CGSize s2 = r2.size;
    CGRect r = (CGRect){r1.origin.x - r2.origin.x, r1.origin.y-r2.origin.y, s1.width - s2.width, s1.height-s2.height};
    r.origin.x = ABS(r.origin.x);
    r.origin.y = ABS(r.origin.y);
    r.size.width = ABS(r.size.width);
    r.size.height = ABS(r.size.height);
    
    
    return r;
}


CGRect CGRectAspectFit(CGRect rect, CGRect bounds) {
    CGFloat originalAspectRatio = rect.size.width / rect.size.height;
    CGFloat maxAspectRatio = bounds.size.width / bounds.size.height;
    CGRect newRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    if (originalAspectRatio > maxAspectRatio) {
        newRect.size.height = bounds.size.width * rect.size.height / rect.size.width;
        newRect.origin.y += (bounds.size.height - newRect.size.height) / 2.0;
    } else {
        newRect.size.width = bounds.size.height * rect.size.width / rect.size.height;
        newRect.origin.x += (bounds.size.width - newRect.size.width) / 2.0;
    }
    
    return newRect;
}
CGRect CGRectSizeCeil(CGRect r) {
    r.size = CGSizeCeil(r.size);
    return r;
}
CGRect CGRectSizeFloor(CGRect r) {
    r.size = CGSizeFloor(r.size);
    return r;
}

#pragma mark - CGSize

BOOL CGSizeIsZero(CGSize size) {
    return CGSizeEqualToSize(size, CGSizeZero);
}
BOOL CGSizeEqualRatio(CGSize size1, CGSize size2) {
    BOOL match = CGSizeEqualToSize(size1, size2);
    if(!match)
    {
        if(size1.width > size1.height)
        {
            float ratio1 = size1.width/size1.height;
            float ratio2 = size2.width/size2.height;
            match = ratio1 == ratio2;
        }
        else
        {
            float ratio1 = size1.height/size1.width;
            float ratio2 = size2.height/size2.width;
            match = ratio1 == ratio2;
        }
    }
    return match;
}

BOOL CGSizeEqualToSizeEnough(CGSize s1, CGSize s2) {
    s1.height = floatRoundedDown(s1.height, 2);
    s1.width = floatRoundedDown(s1.width, 2);
    s2.height = floatRoundedDown(s2.height, 2);
    s2.width = floatRoundedDown(s2.width, 2);
    return CGSizeEqualToSize(s1, s2);
}
BOOL CGSizeGreaterThan(CGSize size1, CGSize size2) {
    return size1.width > size2.width || size1.height > size2.height;
}
BOOL CGSizeLessThan(CGSize size1, CGSize size2) {
    return size1.width < size2.width || size1.height < size2.height;
}

CGSize CGSizeScale(CGSize size, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGSize s = CGSizeZero;
    
    s.width = size.width*scale;
    s.height = size.height*scale;
    return s;
}
CGSize CGSizeInverseScale(CGSize size, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGSize s = CGSizeZero;
    
    s.width = size.width/scale;
    s.height = size.height/scale;
    return s;
}
CGSize CGSizeScaleWithSize(CGSize size, CGSize scale) {
    CGSize s = size;
    s.width *= scale.width;
    s.height *= scale.height;
    return s;
}
CGSize CGSizeInverseScaleWithSize(CGSize size, CGSize scale) {
    CGSize s = size;
    s.width = 1/scale.width;
    s.height = 1/scale.height;
    return s;
}
CGSize CGSizeSquareHeight(CGSize size) {
    size.width = size.height;
    return size;
}
CGSize CGSizeSquareWidth(CGSize size) {
    size.height = size.width;
    return size;
}
CGSize CGSizeSquareSmall(CGSize size) {
    
    return size.height < size.width ? CGSizeSquareHeight(size) : CGSizeSquareWidth(size);
}
CGSize CGSizeSquareBig(CGSize size) {
    
    return size.height > size.width ? CGSizeSquareHeight(size) : CGSizeSquareWidth(size);
}
CGSize CGSizePercentDifference(CGSize s1, CGSize s2) {
    CGFloat lw = MIN(s1.width, s2.width);
    CGFloat hw = lw == s1.width ? s2.width : s1.width;
    
    float d1 = lw/hw;
    
    CGFloat lh = MIN(s1.height, s2.height);
    CGFloat hh = lw == s1.height ? s2.height : s1.height;
    
    float d2 = lh/hh;
    return CGSizeMake(d1,d2);
    
    
}
CGSize CGSizeIntegral(CGSize size) {
    CGRect newRect = CGRectMakeWithSize(size);
    newRect = CGRectIntegral(newRect);
    return newRect.size;
}
CGSize CGSizeDifferenceABS(CGSize s1, CGSize s2) {
    CGRect r = CGRectDifferenceABS(CGRectMakeWithSize(s1), CGRectMakeWithSize(s2));
    return r.size;
}
CGSize CGSizeDifference(CGSize s1, CGSize s2) {
    return (CGSize){s1.width - s2.width, s1.height-s2.height};
}
CGSize CGSizeMin(CGSize size1, CGSize size2) {
    return CGSizeLessThan(size1, size2) ? size1 : size2;
}
CGSize CGSizeMax(CGSize size1, CGSize size2) {
    return CGSizeLessThan(size1, size2) ? size2 : size1;
}
CGSize CGSizeMakeAtLeast(CGSize size1, CGSize size2) {
    CGSize size = CGSizeZero;
    size.width = MAX(size1.width, size2.width);
    size.height = MAX(size1.height, size2.height);
    return size;
}
CGSize CGSizeMakeAtMost(CGSize size1, CGSize size2) {
    CGSize size = CGSizeZero;
    size.width = MIN(size1.width, size2.width);
    size.height = MIN(size1.height, size2.height);
    return size;
}
CGSize CGSizeCeil(CGSize size) {
    CGSize s = size;
    s.height = ceilf(s.height);
    s.width = ceilf(s.width);
    return s;
}
CGSize CGSizeFloor(CGSize size) {
    CGSize s = size;
    s.height = floorf(s.height);
    s.width = floorf(s.width);
    return s;
}
CGSize CGSizeApplyRatio(CGSize size, CGSize fs) {
    CGFloat r = CGSizeRatioOf(fs);
    int w = fs.width > fs.height ? 1 : 2;
    size.width *= w == 1 ? 1 : r;
    size.height *= w == 1 ? r : 1;
    return size;
}
CGSize CGAffineTransformToSize(CGAffineTransform trans) {
    return (CGSize){trans.a, trans.d};
}

CGFloat CGSizeRatioOf(CGSize fs) {
    return fs.width > fs.height ? fs.width/fs.height : fs.height/fs.width;
}
float CGSizeBiggestPercentDifference(CGSize s1, CGSize s2) {
    CGFloat lw = MIN(s1.width, s2.width);
    CGFloat hw = lw == s1.width ? s2.width : s1.width;
    
    float d1 = lw/hw;
    
    CGFloat lh = MIN(s1.height, s2.height);
    CGFloat hh = lw == s1.height ? s2.height : s1.height;
    
    float d2 = lh/hh;
    return MIN(d1,d2);
    
    
}
float CGSizeSmallestPercentDifference(CGSize s1, CGSize s2) {
    CGFloat lw = MIN(s1.width, s2.width);
    CGFloat hw = lw == s1.width ? s2.width : s1.width;
    
    float d1 = lw/hw;
    
    CGFloat lh = MIN(s1.height, s2.height);
    CGFloat hh = lw == s1.height ? s2.height : s1.height;
    
    float d2 = lh/hh;
    return MAX(d1,d2);
    
    
}





#pragma mark - CGPoint

BOOL CGPointIsZero(CGPoint point) {
    return CGPointEqualToPoint(point, CGPointZero);
}

CGPoint CGPointIntegral(CGPoint point) {
    CGRect newRect = CGRectZero;
    newRect.origin = point;
    newRect = CGRectIntegral(newRect);
    return newRect.origin;
}
CGPoint CGPointScale(CGPoint point, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGPoint s = point;
    s.x = s.x*scale;
    s.y = s.y*scale;
    return s;
}
CGPoint CGPointInverseScale(CGPoint point, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGPoint s = point;
    s.x = s.x/scale;
    s.y = s.y/scale;
    return s;
}

CGPoint CGPointDifference(CGPoint point1, CGPoint point2) {
    CGFloat xDist = (point1.x - point2.x);
    CGFloat yDist = (point1.y - point2.y);
    return CGPointMake(xDist, yDist);
}
CGPoint CGPointDifferenceABS(CGPoint point1, CGPoint point2) {
    CGPoint p = CGPointDifference(point1, point2);
    p.x = ABS(p.x);
    p.y = ABS(p.y);
    return p;
}
CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    CGFloat xDist = (point1.x + point2.x);
    CGFloat yDist = (point1.y + point2.y);
    return CGPointMake(xDist, yDist);
}
CGPoint CGPointWith(CGFloat n) {
    return (CGPoint) {n,n};
}

CGFloat CGPointDistanceFrom(CGPoint point1, CGPoint point2) {
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return (CGFloat)sqrt((xDist * xDist) + (yDist * yDist));
}


#pragma mark - Helpers

float floatRoundedDown(float n, int decimals) {
    if(decimals < 1) return floorf(n);
    float power = 1.f;
    
    while (decimals > 0) {
        power = power *10.f;
        decimals-=1;
        
    }
    return floorf(n * power) / power;
}
float floatRoundedUp(float n, int decimals) {
    if(decimals < 1) return ceilf(n);
    float power = 1.f;
    
    while (decimals > 0) {
        power = power *10.f;
        decimals-=1;
        
    }
    return ceilf(n * power) / power;
}
float floatToNearest(float n, int decimals) {
    if(decimals < 1) return n;
    float power = 1.f;
    
    while (decimals > 0) {
        power = power *10.f;
        decimals-=1;
    }
    return floorf(n * power + 0.5f) / power;
}

BOOL usingIOS8() {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // Load resources for iOS 7.1 or earlier
        return NO;
    } else {
        // Load resources for iOS 7 or later
    }
    return YES;
}
BOOL usingIOS7() {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        return NO;
    } else {
        // Load resources for iOS 7 or later
    }
    return YES;
}


