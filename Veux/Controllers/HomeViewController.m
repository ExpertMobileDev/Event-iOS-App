//
//  ViewController.m
//  Veux
//
//  Created by Jonas on 10/10/15.
//  Copyright (c) 2015 Jonas. All rights reserved.

#import "HomeViewController.h"
#import "AddEventViewController.h"
#import "OAuthConsumer.h"
#import "AppDelegate.h" 
#import "OAConsumer.h"
#import "SVProgressHUD.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import "AppConstant.h"
#import "FindEventViewController.h"

@interface HomeViewController ()
{
    BOOL isFBShare;
}
@end

@implementation HomeViewController
@synthesize btnFindEvents, btnUploadEvent, btnSignFaceBook, btnSignTwitter, loginView, homeBackView, grayBackView, webview,btnSkip;
@synthesize accessToken;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.userNameField.tag = 0;
    self.emailField.tag = 1;
    self.passwordField.tag = 2;
   
    loginView.layer.cornerRadius = 5;
    loginView.hidden = YES;
    webview.hidden = YES;
    webview.delegate = self;
    
    isFBShare = NO;
    
    fbUserData = [[NSMutableDictionary alloc] init];
    
    [btnUploadEvent setEnabled:YES];
    [btnFindEvents setEnabled:YES];
    [grayBackView setHidden:YES];
    
    nButtonClick = UPLOAD_CLICK;
    
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        [[self appDelegate] setUserName:userName];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if(isFBShare == NO && [strbLogin isEqualToString:@"YES"])
    {
        isFBShare = YES;
//        FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
//        content.appLinkURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/veux-fun-local-events-near-me/id1052553620?ls=1&mt=8"];
//        
//        
//        // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate
//        
//        [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:nil];
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (IBAction)onUploadEvent:(id)sender {
    nButtonClick = UPLOAD_CLICK;
    btnSkip.hidden = YES;
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
        loginView.hidden = YES;
        [self.btnFindEvents setEnabled:YES];
        [self.btnUploadEvent setEnabled:YES];
        [grayBackView setHidden:YES];
        AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
        [self.navigationController pushViewController:addEventVC animated:YES];
    }
    else {
        loginView.hidden = NO;
        [self.view bringSubviewToFront:loginView];
        [btnFindEvents setEnabled:NO];
        [btnUploadEvent setEnabled:NO];
        [grayBackView setHidden:NO];
    }
}

- (IBAction)onFindEvents:(id)sender {
    nButtonClick = FINDEVENT_CLICK;
    btnSkip.hidden = NO;
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
        loginView.hidden = YES;
        [self.btnFindEvents setEnabled:YES];
        [self.btnUploadEvent setEnabled:YES];
        [grayBackView setHidden:YES];
        FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
        [self.navigationController pushViewController:findEventVC animated:YES];
    }
    else {
        loginView.hidden = NO;
        [self.view bringSubviewToFront:loginView];
        [btnFindEvents setEnabled:NO];
        [btnUploadEvent setEnabled:NO];
        [grayBackView setHidden:NO];
    }
}

-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (BOOL) canLogin
{
    BOOL bResult = YES;
    
    if (self.userNameField.text.length == 0)
    {
        return NO;
    }
    if (self.passwordField.text.length < 4)
    {
        return NO;
    }
    if (self.emailField.text.length == 0)
    {
        return NO;
    }
    
    if (![self validateEmail:self.emailField.text]){
        return NO;
    }

    return bResult;
}


- (IBAction)loginAction:(id)sender {
    if ([self canLogin]) {
        [PFUser logInWithUsernameInBackground:self.userNameField.text password:self.passwordField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                [self.loginView setHidden:YES];
                                                [self.grayBackView setHidden:YES];
                                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
                                                userName = [self.userNameField text];
                                                [[self appDelegate] setUserName:userName];
                                                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];

                                                if (nButtonClick == UPLOAD_CLICK) {
                                                    AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                                                    [self.navigationController pushViewController:addEventVC animated:YES];
                                                }
                                                else if (nButtonClick == FINDEVENT_CLICK){
                                                    FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                                                    [self.navigationController pushViewController:findEventVC animated:YES];
                                                }

                                            } else {
                                                // The login failed. Check error to see why.
                                                UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Invaild Username Or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [message show];
                                            }
                                        }];
    }
}

- (IBAction)signupAction:(id)sender {
    if ([self canLogin]) {
        PFUser *user = [PFUser user];
        user.username = [self.userNameField text];
        user.password = self.passwordField.text;
        user.email = self.emailField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {   // Hooray! Let them use the app now.
                [self.confirmView setHidden:NO];
                [self.loginView setHidden:YES];
            } else {
                [self.loginView setHidden:YES];
                [grayBackView setHidden:YES];
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [message show];
            }
        }];
    }
}

- (IBAction)forgotpasswordAction:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:self.emailField.text];
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Password Update!" message:@"Please check your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];

}

- (IBAction)closeConfirmView:(id)sender {
    [self.confirmView setHidden:YES];
    [grayBackView setHidden:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
    userName = [self.userNameField text];
    [[self appDelegate] setUserName:userName];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
    
    if (nButtonClick == UPLOAD_CLICK) {
        AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
        [self.navigationController pushViewController:addEventVC animated:YES];
    }
    else if (nButtonClick == FINDEVENT_CLICK){
        FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
        [self.navigationController pushViewController:findEventVC animated:YES];
    }
}

- (IBAction)onSignFaceBook:(id)sender {
    loginView.hidden = YES;
    [self.btnFindEvents setEnabled:YES];
    [self.btnUploadEvent setEnabled:YES];
    [grayBackView setHidden:YES];

    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_photos", @"user_birthday", @"user_location"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"login"];
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self fetchUserData];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
            if (nButtonClick == UPLOAD_CLICK) {
                AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                [self.navigationController pushViewController:addEventVC animated:YES];
            }
            else if (nButtonClick == FINDEVENT_CLICK){
                FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                [self.navigationController pushViewController:findEventVC animated:YES];
            }
        } else {
            NSLog(@"User logged in through Facebook!");
            [self fetchUserData];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
            if (nButtonClick == UPLOAD_CLICK) {
                AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                [self.navigationController pushViewController:addEventVC animated:YES];
            }
            else if (nButtonClick == FINDEVENT_CLICK){
                FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                [self.navigationController pushViewController:findEventVC animated:YES];
            }
        }
    }];
}

- (IBAction)onSkipTapped:(id)sender {
    FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
    [self.navigationController pushViewController:findEventVC animated:YES];

}
- (IBAction)onSignTwitter:(id)sender {
    
    loginView.hidden = YES;
    [self.btnFindEvents setEnabled:YES];
    [self.btnUploadEvent setEnabled:YES];
    [grayBackView setHidden:YES];
    
    [PFUser logOut];
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        
        if (![PFTwitterUtils isLinkedWithUser:user]) {
            [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
                if ([PFTwitterUtils isLinkedWithUser:user]) {
                    NSLog(@"User logged in with Twitter!");
                    userName = [PFTwitterUtils twitter].screenName;
                    [[self appDelegate] setUserName:userName];
                    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
                    if (nButtonClick == UPLOAD_CLICK) {
                        AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                        [self.navigationController pushViewController:addEventVC animated:YES];
                    }
                    else if (nButtonClick == FINDEVENT_CLICK){
                        FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                        [self.navigationController pushViewController:findEventVC animated:YES];
                    }

                }
            }];
        }
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            [self.loginView setHidden:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"login"];
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            userName = [PFTwitterUtils twitter].screenName;
            if (userName) {
                [[self appDelegate] setUserName:userName];
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
                if (nButtonClick == UPLOAD_CLICK) {
                    AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                    [self.navigationController pushViewController:addEventVC animated:YES];
                }
                else if (nButtonClick == FINDEVENT_CLICK){
                    FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                    [self.navigationController pushViewController:findEventVC animated:YES];
                }
            }
        } else {
            NSLog(@"User logged in with Twitter!");
            userName = [PFTwitterUtils twitter].screenName;
            [[self appDelegate] setUserName:userName];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"login"];
            if (nButtonClick == UPLOAD_CLICK) {
                AddEventViewController* addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventVC"];
                [self.navigationController pushViewController:addEventVC animated:YES];
            }
            else if (nButtonClick == FINDEVENT_CLICK){
                FindEventViewController* findEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindEventVC"];
                [self.navigationController pushViewController:findEventVC animated:YES];
            }
        }
    }];
}

- (IBAction)onCancel:(id)sender {
    [loginView setHidden:YES];
    [btnUploadEvent setEnabled:YES];
    [btnFindEvents setEnabled:YES];
    [grayBackView setHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
#pragma mark-textField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            [self.userNameField setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
            break;
        case 1:
            [self.emailField setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
            break;
        case 2:
            [self.passwordField setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark ----SigninwithFB----
- (void) fetchUserData {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name,email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection* connection, id result, NSError *error) {
             if (error != nil) {
                 [SVProgressHUD dismiss];
                 [[[UIAlertView alloc] initWithTitle:@"Facebook Login Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             }
             
             NSLog(@"%@", result);
             userName = [result objectForKey:@"name"];
             [[self appDelegate] setUserName:userName];
             [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
         }];
    }
}

- (void)loginWithFacebookInfo:(NSDictionary*)user {
    NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user[@"id"]];
    
    [fbUserData setObject:user[@"first_name"] forKey:@"userName"];
    [fbUserData setObject:user[@"email"] forKey:@"email"];
    [fbUserData setObject:user[@"id"] forKey:@"fbId"];
    //    [fbUserData setObject:[SessionManager currentSession].deviceToken forKey:@"deviceToken"];
    [fbUserData setObject:fbProfilePhoto forKey:@"photoUrl"];
    [fbUserData setObject:@"" forKey:@"videoUrl"];
    [fbUserData setObject:user[@"gender"] forKey:@"sex"];
    [fbUserData setObject:user[@"birthday"] forKey:@"birthDate"];
    
    if (user[@"location"]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@", user[@"location"][@"id"]] parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (error != nil) {
                 [SVProgressHUD dismiss];
                 [[[UIAlertView alloc] initWithTitle:@"Facebook Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             }
             
             NSDictionary *data = (NSDictionary*)result;
             [fbUserData setObject:data[@"name"] forKey:@"region"];
             
             NSDictionary *location = data[@"location"];
             [fbUserData setObject:@{@"type":@"Point", @"coordinates":@[location[@"latitude"], location[@"longitude"]]} forKey:@"location"];
             
         }];
    }
    
}

@end
