//
//  WBHomeViewController.m
//  WBCalendar_Example
//
//  Created by penghui8 on 2019/4/2.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "WBHomeViewController.h"
#import "ABCalendarPicker.h"

@interface WBHomeViewController ()

@property (weak, nonatomic) IBOutlet ABCalendarPicker *calendarPicker;

@end

@implementation WBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarPicker.bottomExpanding = NO;
    self.calendarPicker.swipeNavigationEnabled = NO;
}

@end
