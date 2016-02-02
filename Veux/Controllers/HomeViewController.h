//
//  ViewController.h
//  Veux
//
//  Created by Jonas on 10/10/15.
//  Copyright (c) 2015 Jonas. All rights reserved.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "OAuthConsumer.h"
#import "OAConsumer.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

typedef enum {
    UPLOAD_CLICK = 0,
    FINDEVENT_CLICK
}BUTTON_CLICK;

@interface HomeViewController: UIViewController<UIWebViewDelegate,FBSDKAppInviteDialogDelegate, UITextFieldDelegate>
{
    IBOutlet UIWebView *webview;
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
    NSMutableDictionary *fbUserData;
    NSString* userName;
    
    int nButtonClick;
}
@property (nonatomic,strong) OAToken* accessToken;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) NSString *isLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@property (strong, nonatomic) IBOutlet UIButton *btnFindEvents;
@property (strong, nonatomic) IBOutlet UIButton *btnUploadEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnSignFaceBook;
@property (strong, nonatomic) IBOutlet UIButton *btnSignTwitter;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIImageView *homeBackView;
@property (strong, nonatomic) IBOutlet UIImageView *grayBackView;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIView *confirmView;


- (IBAction)closeConfirmView:(id)sender;
- (IBAction)onSignFaceBook:(id)sender;
- (IBAction)onSignTwitter:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onUploadEvent:(id)sender;
- (IBAction)onFindEvents:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)signupAction:(id)sender;
- (IBAction)forgotpasswordAction:(id)sender;

@end

