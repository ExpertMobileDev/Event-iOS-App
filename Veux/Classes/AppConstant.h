//
//  AppConstant.h
//  Dopple
//
//  Created by Jonas on 21/10/2015.
//  Copyright (c) 2015 Mitchell Williams. All rights reserved.
//

#ifndef Veux_AppConstant_h
#define Veux_AppConstant_h

#pragma mark - Notifications
#define kNotifSignOut                   @"signout"
#define kNotifLogin                     @"trylogin"

#define kNotifShowMBProgressBar         @"showProgress"
#define kNotifHideMBProgressBar         @"hideProgress"

#define kNotifGoMainScreen              @"gomainscreen"

#define kNotifGotCandidates             @"gotCandidates"
#define kNotifGotImageFromUser          @"gotimagefromuser"
#define kNotifShowPostTextView          @"showposttextview"
#define kNotifShowImagePickerVC         @"showimagepickervc"
#define kNotifGotNewAvatar              @"gotnewavatar"

#pragma mark - Constants
#define kLoggedIn                       @"loggedin"
#define kFullName                       @"fullname"
#define kUserId                         @"userid"
#define kPassword                       @"password"
#define kToken                          @"token"
#define kAvatarUrl                      @"avatarurl"
#define kFBFriends                      @"fbfriends"
#define kTwitterFriends                 @"twitterfriends"
#define kUserPhoto                      @"userphoto"
#define kUserInfo                       @"userinfo"
#define kConnectedFB                    @"connectfb"
#define kConnectedTwitter               @"connecttwitter"
#define kTurnOnPN                       @"turnonpn"


#pragma mark - Segues
#define kSegueLogin                     @"LoginSegue"
#define kSegueMainPage                  @"MainPageSegue"



#pragma mark - Facebook 
#define kFBAppId                        @"186361531698966"
#define kFBApplicationID                @"ycq4B3eMCFWLczeLNtGd0eEbvfsAMiwPZ5POG7GQ"
#define kFBClientKey                    @"cVVu3yw0AlGMfy9ivjDeZEjRDp0m5rUUzNMeE7d2"
#pragma mark - Twitter
#define TwitterConsumerKey              @"Z2sgvc657LWmpKFehzqlgKTvJ"
#define TwitterConsumerSecret           @"4vDqaWbgcZDccUZFPRQAIDght73wPWRutjavtRmoHYAX4v3KK0"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#pragma mark - Dopple Manager
#define URL_IMAGE_SEARCH                @"https://www.google.com/searchbyimage?&image_url="
#define URL_SEARCH_DOPPLE(_ImageUrl)    [NSString stringWithFormat:@"%@%@", URL_IMAGE_SEARCH, _ImageUrl]

typedef  enum {
    TodayEvent_like = 0,
    Tomorrow_like,
    Future_like
}LikeState;

#endif
