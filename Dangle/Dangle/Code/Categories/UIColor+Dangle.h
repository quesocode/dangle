//
//  UIColor+DangleColor.h
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Dangle)

+ (instancetype) defaultBubbleColor;
+ (instancetype) defaultOutgoingBubbleColor;
+ (instancetype) hex: (NSString *) hexString;


@property (nonatomic, readonly) NSString *hexString;
@property (nonatomic, readonly) CGFloat red, blue, green, alpha;

- (BOOL)isEqualToColor:(UIColor *)color;
@end
