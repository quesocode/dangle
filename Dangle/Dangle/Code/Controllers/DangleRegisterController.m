//
//  DangleRegisterController.m
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleRegisterController.h"
#import "DangleLogoView.h"
#import "Atlas.h"
#import "DangleClient.h"
#import "DangleAPI.h"
#import "DangleTypes.h"
#import "DangleErrors.h"
#import "DangleUtilities.h"
#import <SVProgressHUD/SVProgressHUD.h>

CGFloat const DangleLogoViewBCenterYOffset = 184;
CGFloat const DangleregistrationTextFieldWidthRatio = 0.8;
CGFloat const DangleregistrationTextFieldHeight = 60;
CGFloat const DangleregistrationTextFieldBottomPadding = 20;

@interface DangleRegisterController () <UITextFieldDelegate>

@property (nonatomic) DangleLogoView *logoView;
@property (nonatomic) UITextField *registrationTextField;
@property (nonatomic) NSLayoutConstraint *registrationTextFieldBottomConstraint;

@end





@implementation DangleRegisterController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.logoView = [[DangleLogoView alloc] init];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logoView];
    
    self.registrationTextField = [[UITextField alloc] init];
    self.registrationTextField .translatesAutoresizingMaskIntoConstraints = NO;
    self.registrationTextField .delegate = self;
    self.registrationTextField .placeholder = @"My name is...";
    self.registrationTextField .textAlignment = NSTextAlignmentCenter;
    self.registrationTextField .layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.registrationTextField .layer.borderWidth = 0.5;
    self.registrationTextField .layer.cornerRadius = 2;
    self.registrationTextField.font = [UIFont systemFontOfSize:22];
    self.registrationTextField .returnKeyType = UIReturnKeyGo;
    [self.view addSubview:self.registrationTextField ];
    
    [self configureLayoutConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.registrationTextField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.registrationTextFieldBottomConstraint.constant = -rect.size.height - DangleregistrationTextFieldBottomPadding;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self registerAndAuthenticateUserWithName:textField.text];
    return YES;
}

- (void)registerAndAuthenticateUserWithName:(NSString *)name
{
    [self.view endEditing:YES];
    
    if (self.applicationController.layerClient.authenticatedUserID) {
        DLog(@"Layer already authenticated as: %@", self.applicationController.layerClient.authenticatedUserID);
        return;
    }
    
    [SVProgressHUD show];
    DLog(@"Requesting Authentication Nonce");
    [self.applicationController.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
//        DLog(@"Got a nonce %@", nonce);
//        return;
        if (error) {
            DangleAlertWithError(error);
            return;
        }
        DLog(@"Registering user: '%@'", name);
        [self.applicationController.APIManager registerUserWithName:name nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            DLog(@"User registered and got identity token: %@ (error=%@)", identityToken, error);
            if (error) {
                DangleAlertWithError(error);
                return;
            }
            DLog(@"Authenticating Layer");
            if (!identityToken) {
                NSError *error = [NSError errorWithDomain:DangleErrorDomain code:DangleInvalidIdentityToken userInfo:@{NSLocalizedDescriptionKey : @"Failed to obtain a valid identity token"}];
                DangleAlertWithError(error);
                return;
            }
            [self.applicationController.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                if (error) {
                    DangleAlertWithError(error);
                    return;
                }
                DLog(@"Layer authenticated as: %@", authenticatedUserID);
                [SVProgressHUD showSuccessWithStatus:nil];
            }];
        }];
    }];
}

- (void)configureLayoutConstraints
{
    // Logo View
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-DangleLogoViewBCenterYOffset]];
    
    // Registration View
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registrationTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registrationTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:DangleregistrationTextFieldWidthRatio constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registrationTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DangleregistrationTextFieldHeight]];
    self.registrationTextFieldBottomConstraint = [NSLayoutConstraint constraintWithItem:self.registrationTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-DangleregistrationTextFieldBottomPadding];
    [self.view addConstraint:self.registrationTextFieldBottomConstraint];
}

@end
