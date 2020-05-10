//
//  ATLLogoView.m
//  QRCodeTest
//
//  Created by Kevin Coleman on 2/15/15.
//  Copyright (c) 2015 Layer. All rights reserved.
//

#import "DangleLogoView.h"
#import "Atlas.h"
#import "DangleTypes.h"

@interface DangleLogoView ()

@property (nonatomic) UILabel *dangleLabel;
@property (nonatomic) UILabel *poweredByLabel;
@property (nonatomic) UIImageView *logoImageView;

@end

@implementation DangleLogoView

CGFloat const DangleLogoSize = 18;
CGFloat const DangleLogoLeftPadding = 4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableAttributedString *dangleString = [[NSMutableAttributedString alloc] initWithString:@"DANGLE"];
        [dangleString addAttribute:NSFontAttributeName value:DangleUltraLightFont(46) range:NSMakeRange(0, dangleString.length)];
        [dangleString addAttribute:NSForegroundColorAttributeName value:ATLBlueColor() range:NSMakeRange(0, dangleString.length)];
        [dangleString addAttribute:NSKernAttributeName value:@(12.0) range:NSMakeRange(0, dangleString.length)];
        
        _dangleLabel = [[UILabel alloc] init];
        _dangleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dangleLabel.attributedText = dangleString;
        [_dangleLabel sizeToFit];
        [self addSubview:_dangleLabel];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Powered By "];
        [attributedString addAttribute:NSForegroundColorAttributeName value:ATLGrayColor() range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:DangleLightFont(9) range:NSMakeRange(0, attributedString.length)];
        
        _poweredByLabel = [[UILabel alloc] init];
        _poweredByLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _poweredByLabel.attributedText = attributedString;
        [_poweredByLabel sizeToFit];
        [self addSubview:_poweredByLabel];
        
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoImageView.image = [UIImage imageNamed:@"layer-logo-gray"];
        [self addSubview:_logoImageView];
        
        [self configureLayoutConstraints];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(320, 80);
}

- (void)configureLayoutConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dangleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dangleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    CGFloat poweredByLabelOffset = (DangleLogoSize + DangleLogoLeftPadding) / DangleLogoLeftPadding;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_poweredByLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-poweredByLabelOffset]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_poweredByLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dangleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_poweredByLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:DangleLogoLeftPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_poweredByLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

@end
