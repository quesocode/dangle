//
//  MysticFunctions.h
//  Mystic
//
//  Created by Me on 3/18/15.
//  Copyright (c) 2015 Mystic. All rights reserved.
//

#ifndef Mystic_MysticFunctions_h
#define Mystic_MysticFunctions_h



BOOL usingIOS7 ();
BOOL usingIOS8 ();


NSString *ColorToString(UIColor *c);


#pragma mark - Logs

void ILog(NSString *name, UIImage *img);
void NoLog(NSString *format, ...);
void FLog(NSString *name, CGRect frame);
void SLog(NSString *name, CGSize size);
void PLog(NSString *name, CGPoint origin);


NSString *ImageOrientationToString (UIImageOrientation imageOrientation);

NSString *ILogStr(UIImage *img);
NSString *SLogStr(CGSize size);
NSString *SLogStrd(CGSize size, int depth);
NSString *FLogStr(CGRect frame);
NSString *FLogStrd(CGRect frame, int depth);
NSString *EdgeLogStr(UIEdgeInsets insets);
NSString *PLogStr(CGPoint origin);
NSString *PLogStrd(CGPoint origin, int depth);




NSString *DPrintViewsOf(UIView *parentView, int depth);
NSString *DPrintSubviewsOf(UIView *parentView, BOOL showDesc, NSString *prefix, int depth, int d);
NSString *DContentModeToString(UIViewContentMode cmode);

#pragma mark - Value Checking

id MNull(id val);
id Mor(id obj, id obj2);
id Mord(id obj, id obj2, id _default);
NSString *MBOOLStr(BOOL val);
NSString *MBOOL(BOOL val);
NSString *MObj(id val);
BOOL isMEmpty(id obj);
BOOL ismt(id obj);
BOOL isM(id obj);
BOOL isMBOOL(id v);


#pragma mark - CGRect

NSValue *CGRectMakeValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

CGRect CGRectScale(CGRect rect, CGFloat scale);
CGRect CGRectInverseScale(CGRect rect, CGFloat scale);
CGRect CGRectMakeWithSize(CGSize size);
CGRect CGRectWithX(CGRect rect, CGFloat x);
CGRect CGRectWithY(CGRect rect, CGFloat y);
CGRect CGRectWithWidth(CGRect rect, CGFloat w);
CGRect CGRectWithHeight(CGRect rect, CGFloat w);
CGRect CGRectMakeWithPointSize(CGPoint point, CGSize size);
CGRect CGRectDifferenceABS(CGRect r1, CGRect r2);
CGRect CGRectDifference(CGRect r1, CGRect r2);
CGRect CGRectWithContentMode(CGRect rect, CGRect bounds, UIViewContentMode contentMode);
CGRect CGRectAspectFit(CGRect rect, CGRect bounds);
CGRect CGRectAspectFill(CGRect rect, CGRect bounds);
CGRect CGRectSizeCeil(CGRect r);
CGRect CGRectSizeFloor(CGRect r);

BOOL CGRectIsZero(CGRect rect);



#pragma mark - CGSize

NSValue *CGSizeMakeValue(CGFloat width, CGFloat height);

CGSize CGSizeMakeUnknownHeight(CGSize size);
CGSize CGSizeMakeUnknownWidth(CGSize size);
CGSize CGSizeFilterUnknown(CGSize size);
CGSize CGSizeScale(CGSize size, CGFloat scale);
CGSize CGSizeInverseScale(CGSize size, CGFloat scale);
CGSize CGSizeInverseScaleWithSize(CGSize size, CGSize scale);
CGSize CGSizeScaleWithSize(CGSize size, CGSize scale);
CGSize CGSizeSquareHeight(CGSize size);
CGSize CGSizeSquareWidth(CGSize size);
CGSize CGSizeSquareBig(CGSize size);
CGSize CGSizeSquareSmall(CGSize size);
CGSize CGSizePercentDifference(CGSize s1, CGSize s2);
CGSize CGSizeIntegral(CGSize size);
CGSize CGSizeDifference(CGSize s1, CGSize s2);
CGSize CGSizeDifferenceABS(CGSize s1, CGSize s2);
CGSize CGSizeMin(CGSize size1, CGSize size2);
CGSize CGSizeMax(CGSize size1, CGSize size2);
CGSize CGSizeMakeAtLeast(CGSize size1, CGSize size2);
CGSize CGSizeMakeAtMost(CGSize size1, CGSize size2);
CGSize CGSizeCeil(CGSize size);
CGSize CGSizeFloor(CGSize size);
CGSize CGSizeApplyRatio(CGSize size, CGSize fromSize);
CGSize CGAffineTransformToSize(CGAffineTransform trans);

CGFloat CGSizeRatioOf(CGSize fs);
float CGSizeBiggestPercentDifference(CGSize s1, CGSize s2);
float CGSizeSmallestPercentDifference(CGSize s1, CGSize s2);

BOOL MysticSizeHeightOnly(CGSize size);
BOOL MysticSizeWidthOnly(CGSize size);
BOOL MysticSizeHasUnknown(CGSize size);
BOOL CGSizeEqualRatio(CGSize size1, CGSize size2);
BOOL CGSizeEqualToSizeEnough(CGSize s1, CGSize s2);
BOOL CGSizeGreaterThan(CGSize size1, CGSize size2);
BOOL CGSizeLessThan(CGSize size1, CGSize size2);
BOOL CGSizeIsZero(CGSize size);


#pragma mark - CGPoint

CGPoint CGPointInverseScale(CGPoint point, CGFloat scale);
CGPoint CGPointScale(CGPoint point, CGFloat scale);
CGPoint CGPointIntegral(CGPoint point);
CGPoint CGPointDifference(CGPoint point1, CGPoint point2);
CGPoint CGPointAdd(CGPoint point1, CGPoint point2);
CGPoint CGPointWith(CGFloat n);
CGPoint CGPointDifferenceABS(CGPoint point1, CGPoint point2);

BOOL CGPointIsZero(CGPoint point);

CGFloat CGPointDistanceFrom(CGPoint point1, CGPoint point2);






#pragma mark - Helpers

float floatToNearest(float n, int decimals);
float floatRoundedUp(float n, int decimals);
float floatRoundedDown(float n, int decimals);

#pragma mark - Defined Functions



#define normalizedDegreesToRadians(x) (M_PI * (x*180) / 180.0f)
#define fromDegreesToRadians(x) (M_PI * x / 180.0f)


#endif
