//
//  AddEventViewController.h
//  Veux
//
//  Created by mac on 10/21/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "DropDownView.h"
#import <MapKit/MapKit.h>
#import "ImageCropView.h"

// Following status
typedef NS_ENUM(NSInteger, InputType) {
    InputTypeDescription             = 0,    // Description input
    InputTypeOthers                  = 1,    // Others input
};


@interface AddEventViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, DropDownViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, ImageCropViewControllerDelegate>
{
    Event* event;
    int nInputType;
    DropDownView *dropDownView;
    NSArray *arrayData;
    
    UIDatePicker *datePicker;
    UIDatePicker *datePicker_time;
    
    NSDate* date;
    NSDate* time;
    
    UIImage* eventImage;
    UIImage* myImage;
    
    CLLocationCoordinate2D center;
}

@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIImageView *grayBackView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UISlider *costSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblCost;
@property (strong, nonatomic) IBOutlet UILabel *lblCostMark;

@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UITextField *eventTypeField;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UITextField *whereField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ticketField;
@property (strong, nonatomic) IBOutlet UITextField *contactField;
@property (strong, nonatomic) IBOutlet UIButton *btnUploadImg;
@property (strong, nonatomic) IBOutlet UIButton *btnPreview;
@property (strong, nonatomic) IBOutlet UIView *uploadView;
@property (strong, nonatomic) IBOutlet UIButton *btnChoosePhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *rulerImgView;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipcodeTextField;

- (IBAction)onBack:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSubmit:(id)sender;
- (IBAction)onPreview:(id)sender;
- (IBAction)onChoosePhoto:(id)sender;
- (IBAction)onTakePhoto:(id)sender;
- (IBAction)onUploadImage:(id)sender;
- (IBAction)onDone:(id)sender;

@end
