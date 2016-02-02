//
//  EventListViewController.m
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "EventListViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "LikeEventTableViewController.h"
#import "iToast.h"

static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1

@implementation EventListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    nSelIdx = 0;
    eventSearchResult = [[self appDelegate] getSearchResultViaMiles];
    
    if ([eventSearchResult count] == 0)
    {
        _btnDetail.hidden = YES;
        _btnDislike.hidden = YES;
        _btnLike.hidden = YES;
        _btnPrevious.hidden = YES;
        _btnTriple.hidden = YES;
        return;
    }
    
    eventImgArray = [[self appDelegate] getEventImgArray];
    
    PFObject* firstEvent = [eventSearchResult objectAtIndex:0];   
    
    [self.lblEventName setText:[firstEvent objectForKey:@"event_name"]];
    [self.lblEventPostName setText:[firstEvent objectForKey:@"user_name"]];
    [self.lblRank setText:[firstEvent objectForKey:@"event_rank"]];
    
    todayLikeEventArray = [[self appDelegate] getTodayLikeEventArry];
    tomorrowLikeEventArray = [[self appDelegate] getTomorrowLikeEventArry];
    futureLikeEventArray = [[self appDelegate] getFutureLikeEventArry];
    
    [self getLocalDateAndTime];
    
    allEvents = [[NSMutableArray alloc] init];
    loadedEvents = [[NSMutableArray alloc] init];
    [self loadEvents];
}

-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:self.eventView.frame];
    tempImg = [eventImgArray objectAtIndex:index];
    draggableView.information.image = tempImg; //%%% placeholder for card-specific information
    draggableView.delegate = self;
    return draggableView;
}

-(void)loadEvents
{
    if([eventSearchResult count] > 0) {
        NSInteger numLoadedCardsCap =(([eventSearchResult count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[eventSearchResult count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[eventSearchResult count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allEvents addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedEvents addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedEvents count]; i++) {
            if (i>0) {
                [self.view insertSubview:[loadedEvents objectAtIndex:i] belowSubview:[loadedEvents objectAtIndex:i-1]];
            } else {
                [self.view addSubview:[loadedEvents objectAtIndex:i]];
            }
            nIdx++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    
    [loadedEvents removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    if (nIdx < [allEvents count] && [loadedEvents count] > 0) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedEvents addObject:[allEvents objectAtIndex:nIdx]];
        nIdx++;//%%% loaded a card, so have to increment count
        [self.view insertSubview:[loadedEvents objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedEvents objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self setDislikeEvent];
}

-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
  
    [loadedEvents removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    if (nIdx < [allEvents count] && [loadedEvents count] > 0) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedEvents addObject:[allEvents objectAtIndex:nIdx]];
        nIdx++;//%%% loaded a card, so have to increment count
        [self.view insertSubview:[loadedEvents objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedEvents objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    [self setLikeEvent];
}

-(void)swipeRight
{
    DraggableView *dragView = [loadedEvents firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.8 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedEvents firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.8 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (IBAction)OnPreviousEvent:(id)sender {
    if (nSelIdx - 1 < 0) {
        [[[UIAlertView alloc] initWithTitle:@"First Event!" message:@"This event is a first event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [self.btnDetail setEnabled:YES];
    [self.btnDislike setEnabled:YES];
    [self.btnLike setEnabled:YES];
    [self.rakingImgView setHidden:NO];

    nSelIdx--;
    DraggableView* newCard = [self createDraggableViewWithDataAtIndex:nSelIdx];
    
    if ([loadedEvents count] == 2)
        [loadedEvents removeLastObject];
    nIdx--;
    if (nIdx < [allEvents count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedEvents insertObject:newCard atIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
        for (int i = 0; i<[loadedEvents count]; i++) {
            if (i>0) {
                [self.view insertSubview:[loadedEvents objectAtIndex:i] belowSubview:[loadedEvents objectAtIndex:i-1]];
            } else {
                [self.view addSubview:[loadedEvents objectAtIndex:i]];
            }
        }
    }
    
    PFObject* prevEvent = [eventSearchResult objectAtIndex:nSelIdx];
    self.lblEventName.text = [prevEvent objectForKey:@"event_name"];
    self.lblEventPostName.text = [prevEvent objectForKey:@"user_name"];
    self.lblRank.text = [prevEvent objectForKey:@"event_rank"];
}

- (IBAction)onDislike:(id)sender {
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
        [self swipeLeft];
    }
    else
    {
        [[[iToast makeText:@"Please login to dislike event"]setGravity:iToastGravityBottom] show];
    }
    
//    [self setDislikeEvent];
}

- (void) setDislikeEvent {
    PFObject* curEvent = [eventSearchResult objectAtIndex:nSelIdx];
    if ([self existEventInArry:todayLikeEventArray whereKey:curEvent])
        [todayLikeEventArray removeObjectAtIndex:nDislikedIdx];
    else if ([self existEventInArry:tomorrowLikeEventArray whereKey:curEvent])
        [tomorrowLikeEventArray removeObjectAtIndex:nDislikedIdx];
    else if ([self existEventInArry:futureLikeEventArray whereKey:curEvent])
        [futureLikeEventArray removeObjectAtIndex:nDislikedIdx];
    
    [[self appDelegate] setLikeTodayEvent:todayLikeEventArray];
    [[self appDelegate] setLikeTomorrowEvent:tomorrowLikeEventArray];
    [[self appDelegate] setLikeFutureEvent:futureLikeEventArray];
    
    if (nSelIdx + 1 >= [eventSearchResult count]) {
        [[[UIAlertView alloc] initWithTitle:@"Final Event!" message:@"This event is the last event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.lblEventName setText:@""];
        [self.lblEventPostName setText:@""];
        [self.lblRank setText:@""];
        [self.btnDetail setEnabled:NO];
        [self.btnDislike setEnabled:NO];
        [self.btnLike setEnabled:NO];
        [self.rakingImgView setHidden:YES];
        return;
    } else {
        nSelIdx++;
        PFObject* nextEvent = [eventSearchResult objectAtIndex:nSelIdx];
        [self.lblEventName setText:[nextEvent objectForKey:@"event_name"]];
        [self.lblEventPostName setText:[nextEvent objectForKey:@"user_name"]];
        [self.lblRank setText:[nextEvent objectForKey:@"event_rank"]];
    }
}

- (IBAction)onLike:(id)sender {
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
        [self swipeRight];
    }
    else
    {
        [[[iToast makeText:@"Please login to like event."]setGravity:iToastGravityBottom] show];
    }
    
}

- (void) setLikeEvent {
    PFObject* curEvent = [eventSearchResult objectAtIndex:nSelIdx];
    NSString* strEventDateTime = [curEvent objectForKey:@"event_datetime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd h:mm a"];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:sourceTimeZone];
    
    NSDate* eventDate = [formatter dateFromString:strEventDateTime];
    NSTimeInterval differenceTime = [eventDate timeIntervalSinceDate:currentDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:eventDate];
    int nEventDay = (int)[dateComponents day];
    
    dateComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:currentDate];
    int nCurrentDay = (int)[dateComponents day];
    int nDiffDay = nEventDay - nCurrentDay;
    
    if (differenceTime < 3600 * 24) {
        if (nDiffDay == 1) {
            if (![self existEventInArry:tomorrowLikeEventArray whereKey:curEvent])
                [tomorrowLikeEventArray addObject:curEvent];
        }
        else {
            if (![self existEventInArry:todayLikeEventArray whereKey:curEvent])
                [todayLikeEventArray addObject:curEvent];
        }
    }
    else if (differenceTime > 3600 * 24 && differenceTime < 3600 * 48) {
        if (nDiffDay == 2) {
            if (![self existEventInArry:futureLikeEventArray whereKey:curEvent])
                [futureLikeEventArray addObject:curEvent];
        }
        else {
            if (![self existEventInArry:tomorrowLikeEventArray whereKey:curEvent])
                [tomorrowLikeEventArray addObject:curEvent];
        }
    }
    else if (differenceTime > 3600 * 48) {
        if (![self existEventInArry:futureLikeEventArray whereKey:curEvent])
            [futureLikeEventArray addObject:curEvent];
    }
    
    [[self appDelegate] setLikeTodayEvent:todayLikeEventArray];
    [[self appDelegate] setLikeTomorrowEvent:tomorrowLikeEventArray];
    [[self appDelegate] setLikeFutureEvent:futureLikeEventArray];
    
    PFQuery* eventQuery = [PFQuery queryWithClassName:@"Veux_Event"];
    [eventQuery whereKey:@"event_name" equalTo:[curEvent objectForKey:@"event_name"]];
    
    [eventQuery getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
        if (!error) {
            int nRank = (int)[[object objectForKey:@"event_rank"] integerValue];
            nRank++;
            [object setObject:@"YES" forKey:@"event_like"];
            [object setObject:[NSString stringWithFormat:@"%d", nRank] forKey:@"event_rank"];
            [object saveInBackground];
        } else {
            NSLog(@"Error:%@", error.localizedDescription);
        }
    }];
    
    if (nSelIdx + 1 >= [eventSearchResult count]) {
        [[[UIAlertView alloc] initWithTitle:@"Final Event!" message:@"This event is the last event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.lblEventName setText:@""];
        [self.lblEventPostName setText:@""];
        [self.lblRank setText:@""];
        [self.btnDetail setEnabled:NO];
        [self.btnDislike setEnabled:NO];
        [self.btnLike setEnabled:NO];
        [self.rakingImgView setHidden:YES];
        nSelIdx++;
        return;
    } else {
        nSelIdx++;
        PFObject* nextEvent = [eventSearchResult objectAtIndex:nSelIdx];
        [self.lblEventName setText:[nextEvent objectForKey:@"event_name"]];
        [self.lblEventPostName setText:[nextEvent objectForKey:@"user_name"]];
        [self.lblRank setText:[nextEvent objectForKey:@"event_rank"]];
    }
}

- (IBAction)onDetail:(id)sender {
    PFObject* event = [eventSearchResult objectAtIndex:nSelIdx];
    [[self appDelegate] setCurEvent:event];
    tempImg = [eventImgArray objectAtIndex:nSelIdx];
    [[self appDelegate] setEventImage:tempImg];
    DetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    [self.navigationController pushViewController:detailVC animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];   
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoTableView:(id)sender {
    NSString* strbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([strbLogin isEqualToString:@"YES"]) {
    LikeEventTableViewController* likeEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikeEventTableVC"];
    [self.navigationController pushViewController:likeEventVC animated:YES];
        return;
    }
    [[[iToast makeText:@"Please login to view details."]setGravity:iToastGravityBottom]show];
}

- (void) getLocalDateAndTime {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    currentDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
}

- (BOOL) existEventInArry:(NSMutableArray*) eventArray whereKey:(PFObject*) myEvent {
    NSString* myEvent_name = [myEvent objectForKey:@"event_name"];
    for (int i = 0; i < [eventArray count]; i++) {
        PFObject* event = [eventArray objectAtIndex:i];
        NSString* event_name = [event objectForKey:@"event_name"];
        if ([myEvent_name isEqualToString:event_name]) {
            nDislikedIdx = i;
            return YES;
        }
    }
    return NO;
}


@end
