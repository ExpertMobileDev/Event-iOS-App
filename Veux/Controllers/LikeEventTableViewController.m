//
//  LikeEventTableViewController.m
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "LikeEventTableViewController.h"
#import "LikeTableCell.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

@implementation LikeEventTableViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    
    todayLikeEventArray = [[self appDelegate] getTodayLikeEventArry];
    tomorrowLikeEventArray = [[self appDelegate] getTomorrowLikeEventArry];
    futureLikeEventArray = [[self appDelegate] getFutureLikeEventArry];
    
    UITapGestureRecognizer *todayTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayTab:)];
    [self.todayTabImgView addGestureRecognizer:todayTapGesture];

    UITapGestureRecognizer *tomorrowTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tomorrowTab:)];
    [self.tomorrowTabImgView addGestureRecognizer:tomorrowTapGesture];

    UITapGestureRecognizer *futureTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(futureTab:)];
    [self.futureTabImgView addGestureRecognizer:futureTapGesture];
    
    nStateIdx = TodayEvent_like;
    selectEventArray = todayLikeEventArray;
    
    eventImgArray = [[self appDelegate] getEventImgArray];
    
    cellHeight = self.likeTableView.frame.size.height/4;
}

- (void) todayTab:(UITapGestureRecognizer*)sender {
    [self.todayTabImgView setImage:[UIImage imageNamed:@"tab_back1.png"]];
    [self.lblToday setTextColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.todayView];
    [self.tomorrowTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblTomorrow setTextColor:[UIColor whiteColor]];
    [self.futureTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblFuture setTextColor:[UIColor whiteColor]];
    nStateIdx = TodayEvent_like;
    selectEventArray = todayLikeEventArray;
    [self.likeTableView reloadData];
}

- (void) tomorrowTab:(UITapGestureRecognizer*)sender {
    [self.tomorrowTabImgView setImage:[UIImage imageNamed:@"tab_back1.png"]];
    [self.lblTomorrow setTextColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.tomorrowView];
    [self.todayTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblToday setTextColor:[UIColor whiteColor]];
    [self.futureTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblFuture setTextColor:[UIColor whiteColor]];
    nStateIdx = Tomorrow_like;
    selectEventArray = tomorrowLikeEventArray;
    [self.likeTableView reloadData];
}

- (void) futureTab:(UITapGestureRecognizer*)sender {
    [self.futureTabImgView setImage:[UIImage imageNamed:@"tab_back1.png"]];
    [self.lblFuture setTextColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.futureView];
    [self.todayTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblToday setTextColor:[UIColor whiteColor]];
    [self.tomorrowTabImgView setImage:[UIImage imageNamed:@"tab_back.png"]];
    [self.lblTomorrow setTextColor:[UIColor whiteColor]];
    nStateIdx = Future_like;
    selectEventArray = futureLikeEventArray;
    [self.likeTableView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nRowNum = 0;
    if (nStateIdx == TodayEvent_like)
        nRowNum = (int)[todayLikeEventArray count];
    else if (nStateIdx == Tomorrow_like)
        nRowNum = (int)[tomorrowLikeEventArray count];
    else if (nStateIdx == Future_like)
        nRowNum = (int)[futureLikeEventArray count];
    return nRowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LikeCell";
    LikeTableCell *cell= (LikeTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
    if (cell == nil)
    {
        cell = [[LikeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFObject* curEvent = [selectEventArray objectAtIndex:indexPath.row];
    NSString* strDate;
    if (nStateIdx == TodayEvent_like) {
        strDate = @"due today";
    }
    else if (nStateIdx == Tomorrow_like) {
        strDate = @"due tomorrow";
    }
    else if (nStateIdx == Future_like) {
        strDate = @"due future";
    }
    NSString* strUserName = [curEvent objectForKey:@"user_name"];
    NSString* strRankNum = [curEvent objectForKey:@"event_rank"];
    PFFile* imgFile = [curEvent objectForKey:@"event_imagefile"];
    NSData* data = [imgFile getData];
    UIImage* event_image = [UIImage imageWithData:data];
    [cell.eventImgView setImage:event_image];
    [cell.lblEventName setText:[curEvent objectForKey:@"event_name"]];

    [cell drawCell:strUserName andRank:strRankNum andDate:strDate];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int nSelId = (int)indexPath.row;
    PFObject* selEvent = [selectEventArray objectAtIndex:nSelId];
    [[self appDelegate] setCurEvent:selEvent];
    DetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
