//
//  AddEventViewController.m
//  Veux
//
//  Created by mac on 10/21/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "AddEventViewController.h"
#import "PreviewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "EventMapViewController.h"


@implementation AddEventViewController
@synthesize btnCancel, btnSubmit, descriptionTextView, descriptionView, scrollView, grayBackView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    nInputType = InputTypeDescription;

    descriptionView.layer.cornerRadius = 5;
    btnSubmit.layer.cornerRadius = 5;
    btnCancel.layer.cornerRadius = 5;
    self.btnPreview.layer.cornerRadius = 5;
    self.inputView.layer.cornerRadius = 5;
    self.uploadView.layer.cornerRadius = 5;
        
    [descriptionTextView.layer setBorderWidth:0.5];
    [descriptionTextView setDelegate:self];
    
    self.btnTakePhoto.layer.cornerRadius = 5;
    self.btnChoosePhoto.layer.cornerRadius = 5;
    self.btnDone.layer.cornerRadius = 5;
    [self.uploadView setHidden:YES];

    [self.eventTypeField setTag:727];
    [self.whereField setTag:422];
    arrayData = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects:@"Family",@"Networking",@"Mingle",@"Charity",@"Party",@"Festival",@"Game",@"Tournament",@"Your",@"Showcase",@"Retreat",@"Expo",@"Theatre",@"Convention",@"Race",@"Seminar",@"Other",nil]];
    
    dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:30 heightTableView:30 * 10 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:self.eventTypeField animation:BLENDIN openAnimationDuration:0 closeAnimationDuration:0];
    
    dropDownView.delegate_ = self;
    
    UITapGestureRecognizer *eventTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownType:)];
    [self.eventTypeField addGestureRecognizer:eventTypeGesture];

    [self.inputView addSubview:dropDownView.view];
    [self.inputView setHidden:YES];
    [descriptionView setHidden:NO];
    [grayBackView setHidden:NO];
    
    event = [[Event alloc] init];
    
    [self setTextFieldProperty];
    [self.costSlider setThumbImage:[UIImage imageNamed:@"thumb_20.png"] forState:UIControlStateNormal];
    
    event.strCost = [NSString stringWithFormat:@"$%d", (int)self.costSlider.value];
    float rTumbXOffset = self.rulerImgView.frame.size.width / 4;
    
    int nOriginX = self.rulerImgView.frame.origin.x + rTumbXOffset - self.costSlider.currentThumbImage.size.width / 2;
    [self.lblCost setText:@"25"];
    [self.lblCost setFrame:CGRectMake(nOriginX, self.lblCost.frame.origin.y, self.lblCost.frame.size.width, self.lblCost.frame.size.height)];
    
    [scrollView setContentOffset:CGPointZero animated:YES];
    
    
}

- (void) dropDownType:(UITapGestureRecognizer*)sender {
    [dropDownView openAnimation];
}

-(void)updateTextField:(id)sender
{
    datePicker = (UIDatePicker*)self.dateField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *theDate = [dateFormat stringFromDate:datePicker.date];
    self.dateField.text = [NSString stringWithFormat:@"%@",theDate];
    date = datePicker.date;
}

-(void)updateTextField_time:(id)sender
{
    datePicker_time = (UIDatePicker*)self.timeField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm a"];
    NSString *theDate = [dateFormat stringFromDate:datePicker_time.date];
    self.timeField.text = [NSString stringWithFormat:@"%@",theDate];
    time = datePicker_time.date;
}

- (NSDate*) getDateAndTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:datePicker.date];
    NSDateComponents *timeComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitSecond fromDate:datePicker_time.date];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
    newComponents.timeZone = [NSTimeZone systemTimeZone];
    [newComponents setDay:[dateComponents day]];
    [newComponents setMonth:[dateComponents month]];
    [newComponents setYear:[dateComponents year]];
    [newComponents setHour:[timeComponents hour]];
    [newComponents setMinute:[timeComponents minute]];
    [newComponents setSecond:[timeComponents second]];
    
    NSDate *combDate = [calendar dateFromComponents:newComponents];
    
    NSLog(@" \ndate : %@ \ntime : %@\ncomDate : %@",datePicker.date,datePicker_time.date,combDate);
    return combDate;
}

- (NSDate*) getLocalDateAndTime {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* localDate_ = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:sourceTimeZone];
    
    return localDate_;
}

- (void) setTextFieldProperty {
    NSAttributedString *strType = [[NSAttributedString alloc] initWithString:@"Event Type" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }];
    self.eventTypeField.attributedPlaceholder = strType;
    
    NSAttributedString *strDate = [[NSAttributedString alloc] initWithString:@"Date" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }];
    self.dateField.attributedPlaceholder = strDate;
    [self.dateField setTag:0];
    NSDate *defualtDate = [self getLocalDateAndTime];
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:defualtDate];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateField setInputView:datePicker];

    NSAttributedString *strTime = [[NSAttributedString alloc] initWithString:@"Time" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }];
    self.timeField.attributedPlaceholder = strTime;
    [self.timeField setTag:1];
    datePicker_time = [[UIDatePicker alloc]init];
    [datePicker_time setDate:defualtDate];
    [datePicker_time setDatePickerMode:UIDatePickerModeTime];
    [datePicker_time addTarget:self action:@selector(updateTextField_time:) forControlEvents:UIControlEventValueChanged];
    [self.timeField setInputView:datePicker_time];

    
    NSAttributedString *strWhere = [[NSAttributedString alloc] initWithString:@"123 Robin Avenue RCC Road" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor],
                      NSFontAttributeName :[UIFont italicSystemFontOfSize:10.f]}];
    self.whereField.attributedPlaceholder = strWhere;
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.whereField addGestureRecognizer:singleTap];
    
    NSAttributedString *strState = [[NSAttributedString alloc] initWithString:@"North Carolina" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName :[UIFont italicSystemFontOfSize:10.f]}];
    self.stateTextField.attributedPlaceholder = strState;
    
    NSAttributedString *strCity = [[NSAttributedString alloc] initWithString:@"Charlotte" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName :[UIFont italicSystemFontOfSize:10.f]}];
    self.cityTextField.attributedPlaceholder = strCity;
    
    NSAttributedString *strZipCode = [[NSAttributedString alloc] initWithString:@"0026" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName :[UIFont italicSystemFontOfSize:10.f]}];
    self.zipcodeTextField.attributedPlaceholder = strZipCode;
    self.zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;

    NSAttributedString *strName = [[NSAttributedString alloc] initWithString:@"Name of the event" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }];
    self.nameField.attributedPlaceholder = strName;
    NSAttributedString *strTicket = [[NSAttributedString alloc] initWithString:@"www.loremipsum.com" attributes:@{       NSForegroundColorAttributeName : [UIColor grayColor],                                                                                                                   NSFontAttributeName :[UIFont italicSystemFontOfSize:10.f]}];
    self.ticketField.attributedPlaceholder = strTicket;
    NSAttributedString *strContact = [[NSAttributedString alloc] initWithString:@"Contact the organizer" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor]}];
    self.contactField.attributedPlaceholder = strContact;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
}


- (IBAction)onBack:(id)sender {
//    HomeViewController* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:homeVC animated:YES];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)onCancel:(id)sender {
    [descriptionTextView resignFirstResponder];
//    //NSString* strDescription = [descriptionTextView text];
//    if (![descriptionTextView text] || [[descriptionTextView text] isEqualToString:@""]) {
//        [[[UIAlertView alloc] initWithTitle:@"Invalidate Event!" message:@"Please enter the description!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        return;
//    }
    event.strDescription = @"";
    [descriptionView setHidden:YES];
    [grayBackView setHidden:YES];
    [self.inputView setHidden:NO];
    
    nInputType = InputTypeOthers;
}

- (IBAction)onSubmit:(id)sender {
    [descriptionTextView resignFirstResponder];
    NSString* strDescription = [descriptionTextView text];
    if (strDescription == nil || [strDescription isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalidate Event!" message:@"Please enter the description!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    event.strDescription = strDescription;
    [self.inputView setHidden:NO];
    [descriptionView setHidden:YES];
    [grayBackView setHidden:YES];

    nInputType = InputTypeOthers;
}

- (IBAction)onPreview:(id)sender {
    event.strEventType = [self.eventTypeField text];
    NSString *strData = [self.dateField text];
    NSString * strTime = [self.timeField text];
    event.strDate = strData;
    event.strTime = strTime;
    event.strUserName = [[self appDelegate] getUserName];
    event.strWhere = [self.nameField text];
    event.strTickets = [self.ticketField text];
    event.strContactOrganizer = [self.contactField text];
    event.strWhere = [self.whereField text];  //123 Robin Avenue RCC Road 0026 USA
    event.strName = [self.nameField text];
    event.strLike = @"NO";
        
    NSDate* eventDateTime = [self getDateAndTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd h:mm a"];
    NSString* dateString = [formatter stringFromDate:eventDateTime];
    event.strDateTime = dateString;
    [self getLocationFromAddressString:event.strWhere];
}

-(BOOL) getLocationFromAddressString: (NSString*) addressStr {
    NSString* strState = self.stateTextField.text;
    NSString* strCity = self.cityTextField.text;
    NSString* strZipCode = self.zipcodeTextField.text;
    NSString* strWhere = self.whereField.text;
    
    NSString* strAddress = [[strWhere stringByAppendingString:@" "] stringByAppendingString:strCity];
    strAddress = [[strAddress stringByAppendingString:@" "] stringByAppendingString:strState];
    strAddress = [[strAddress stringByAppendingString:@" "] stringByAppendingString:strZipCode];
    
    event.strWhere = strAddress;
    double latitude = 0, longitude = 0;
    center.latitude=latitude;
    center.longitude = longitude;
    
    if ([strState isEqualToString:@""] || [strCity isEqualToString:@""] || [strZipCode isEqualToString:@""] || [strWhere isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalidate Event!" message:@"Please input address correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:strAddress
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         
                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(topResult.location.coordinate, 1000, 1000);
                         center = region.center;
                         
                         if (center.latitude == 0 || center.longitude == 0) {
                             [[[UIAlertView alloc] initWithTitle:@"Invalidate Event!" message:@"Please input address correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                             return;
                         }
                         [[self appDelegate] setEventLatAndLong:[NSString stringWithFormat:@"%f", center.latitude] andEventLong:[NSString stringWithFormat:@"%f", center.longitude]];
                         //[[self appDelegate] setEventLatAndLong:@"42.89478252" andEventLong:@"129.56128522"];
                         event.strLat = [[self appDelegate] getEventLatitute];
                         event.strLong = [[self appDelegate] getEventLongitude];
                         
                         if (![event validateEvent]) {
                             NSString* strError = [NSString stringWithFormat:@"Please input %@ correctly.", event.strError];
                             [[[UIAlertView alloc] initWithTitle:@"Invalidate Event!" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                             return;
                         }
                         [[self appDelegate] setSelEvent:event];
                         PreviewController* previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewVC"];
                         [self.navigationController pushViewController:previewVC animated:YES];
                     }
                 }
     ];
    
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
 
    return YES;
}

- (IBAction)onChoosePhoto:(id)sender {
    [self.uploadView setHidden:YES];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing=YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)onTakePhoto:(id)sender {
    [self.uploadView setHidden:YES];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing=YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)onDone:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.uploadView setHidden:YES];
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)onUploadImage:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.uploadView setHidden:NO];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark-textview delegates

- (void)textViewDidBeginEditing:(UITextView *)textViews{
    descriptionTextView.text =@"";
}
- (void)textViewDidEndEditing:(UITextView *)textViews{
    if(descriptionTextView.text.length==0)
        descriptionTextView.text =@"Type event description....";
    if(textViews==descriptionTextView){
        [descriptionTextView resignFirstResponder];
        event.strDescription = descriptionTextView.text;
    }
}

- (BOOL) textView: (UITextView*) textViews shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text{
    if(textViews==descriptionTextView){
        if ([text isEqualToString:@"\n"]) {
            [descriptionTextView resignFirstResponder];
            return NO;
        }
        return textViews.text.length + (text.length - range.length) <= 100;
    }
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return YES;
}

#pragma mark ---keyboardEvent----

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
   
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin;
    CGFloat buttonHeight = 0.0f;
    CGRect visibleRect;
    if (nInputType == InputTypeDescription) {
        buttonOrigin = CGPointMake(btnSubmit.frame.origin.x + descriptionView.frame.origin.x, btnSubmit.frame.origin.y + descriptionView.frame.origin.y);

        buttonHeight = btnSubmit.frame.size.height;

        visibleRect = self.view.frame;

        visibleRect.size.height -= keyboardSize.height;
    

        if (!CGRectContainsPoint(visibleRect, buttonOrigin)){

            CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
            [scrollView setContentOffset:scrollPoint animated:YES];
            [scrollView setScrollEnabled:YES];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [scrollView setContentOffset:CGPointZero animated:YES];
    
}

#pragma mark-textField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.eventTypeField resignFirstResponder];
    [self.dateField resignFirstResponder];
    [self.timeField resignFirstResponder];
    [self.whereField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.ticketField resignFirstResponder];
    [self.contactField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 727) {
       [dropDownView openAnimation];
       return NO;
    }
    return YES;
}

#pragma mark ---- imagePickerDelegate -----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    myImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
   
    if(myImage != nil){
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:myImage];
        controller.delegate = self;
        controller.blurredBackground = YES;
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) uploadViewhidden {
    [UIView animateWithDuration:0.5f animations:^{
//        [self.uploadView setFrame:CGRectMake(0, self.view.frame.size.height, self.uploadView.frame.size.width, self.uploadView.frame.size.height)];
        [self.uploadView setHidden:YES];
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:2.0f animations:^{
            
        } completion:nil];
        
    }];
}

- (IBAction)sliderValueChanged:(id)sender
{
    // Set the label text to the value of the slider as it changes
    event.strCost = [NSString stringWithFormat:@"$%d", (int)self.costSlider.value];
    float rTumbXOffset = self.rulerImgView.frame.size.width * self.costSlider.value / 100.0f;
    
    int nOriginX = self.rulerImgView.frame.origin.x + rTumbXOffset - self.costSlider.currentThumbImage.size.width / 2;
    NSString* strCost = [NSString stringWithFormat:@"%d", (int)self.costSlider.value];
    [self.lblCost setText:strCost];
    [self.lblCost setFrame:CGRectMake(nOriginX, self.lblCost.frame.origin.y, self.lblCost.frame.size.width, self.lblCost.frame.size.height)];
    
    if (self.lblCost.frame.origin.x < self.lblCostMark.frame.origin.x + self.lblCostMark.frame.size.width) {
        [self.lblCostMark setHidden:YES];
    }
    else {
        [self.lblCostMark setHidden:NO];
    }
}


#pragma mark- DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex{
    NSString* strRemainder = [arrayData objectAtIndex:returnIndex];
    [self.eventTypeField setText:strRemainder];
}

#pragma mark---ImageCropViewDelegate---
- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    eventImage = croppedImage;
    NSData *imageData = UIImageJPEGRepresentation(eventImage, 0.8);
    event.imageData = imageData;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    eventImage = myImage;
    NSData *imageData = UIImageJPEGRepresentation(eventImage, 0.8);
    event.imageData = imageData;
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
