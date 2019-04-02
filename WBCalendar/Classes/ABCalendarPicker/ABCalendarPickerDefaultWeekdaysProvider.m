//
//  ABCalendarPickerDefaultWeekdaysProvider.m
//  ABCalendarPicker
//
//  Created by Anton Bukov on 06.07.12.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "ABCalendarPickerDefaultDaysProvider.h"
#import "ABCalendarPickerDefaultWeekdaysProvider.h"

@interface ABCalendarPickerDefaultWeekdaysProvider()
@property (strong,nonatomic) NSDateFormatter * dateFormatter;
@property (strong,nonatomic) ABCalendarPickerDefaultDaysProvider * daysProvider;
@end

@implementation ABCalendarPickerDefaultWeekdaysProvider

@synthesize dateOwner = _dateOwner;
@synthesize calendar = _calendar;
@synthesize dateFormatter = _dateFormatter;
@synthesize daysProvider = _daysProvider;

- (ABCalendarPickerDefaultDaysProvider*)daysProvider
{
    if (_daysProvider == nil)
    {
        _daysProvider = [[ABCalendarPickerDefaultDaysProvider alloc] init];
        _daysProvider.calendar = self.calendar;
    }
    return _daysProvider;
}

- (void)setDateOwner:(id<ABCalendarPickerDateOwner>)dateOwner
{
    _dateOwner = dateOwner;
    self.daysProvider.dateOwner = dateOwner;
}

- (void)setCalendar:(NSCalendar *)calendar
{
    _calendar = calendar;
    _calendar.minimumDaysInFirstWeek = 1;
    self.daysProvider.calendar = calendar;
}

- (id)init
{
    if (self = [super init])
    {
        self.calendar = [NSCalendar currentCalendar];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"d MMMM yyyy" options:0 locale:[NSLocale currentLocale]];
    }
    return self;
}

- (NSInteger)canDiffuse
{
    return 0;
}

- (ABCalendarPickerAnimation)animationForPrev {
    return ABCalendarPickerAnimationScrollUp;
}
- (ABCalendarPickerAnimation)animationForNext {
    return ABCalendarPickerAnimationScrollDown;
}
- (ABCalendarPickerAnimation)animationForZoomInToProvider:(id<ABCalendarPickerDateProviderProtocol>)provider {
    return ABCalendarPickerAnimationNone;
}
- (ABCalendarPickerAnimation)animationForZoomOutToProvider:(id<ABCalendarPickerDateProviderProtocol>)provider {
    NSInteger weekNumber = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:[self.dateOwner highlightedDate]];
    return (ABCalendarPickerAnimation)(ABCalendarPickerAnimationScrollUpOrDownBase - weekNumber);
}

- (NSDate*)dateForPrevAnimation
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.weekOfYear = -1;
    return [self.calendar dateByAddingComponents:components toDate:[self.dateOwner highlightedDate] options:0];
}

- (NSDate*)dateForNextAnimation
{
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.weekOfYear = 1;
    return [self.calendar dateByAddingComponents:components toDate:[self.dateOwner highlightedDate] options:0];
}

- (NSInteger)rowsCount
{
    return 1;
}

- (NSInteger)columnsCount
{
    return 7;
}

- (NSString*)columnName:(NSInteger)column
{
    return [self.daysProvider columnName:column];
}

- (NSString*)titleText
{
    return [self.dateFormatter stringFromDate:[self.dateOwner highlightedDate]];
}

- (NSDate*)dateForRow:(NSInteger)row
            andColumn:(NSInteger)column
{
    NSInteger index = column + 1 + row*7;
    NSInteger highlightedDay = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:[self.dateOwner highlightedDate]];
    NSInteger highlightedWeekday = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:[self.dateOwner highlightedDate]];
    NSInteger firstWeekday = (highlightedWeekday - highlightedDay + 35)%7 + 1;
    
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = index - firstWeekday - (highlightedDay-1);
    return [self.calendar dateByAddingComponents:dateComponents toDate:[self.dateOwner highlightedDate] options:0];
}

- (NSString*)labelForDate:(NSDate*)date
{
    NSUInteger day = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return [NSString stringWithFormat:@"%@", @(day), nil];
}

- (UIControlState)controlStateForDate:(NSDate*)date
{
    NSInteger currentMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date];
    NSInteger selectedMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:[self.dateOwner selectedDate]];
    NSInteger highlightedMonth = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:[self.dateOwner highlightedDate]];
    
    NSInteger currentDay = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger selectedDay = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.dateOwner selectedDate]];
    NSInteger highlightedDay = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.dateOwner highlightedDate]];
    
    NSInteger currentYear = [self.calendar ordinalityOfUnit:NSCalendarUnitYear inUnit:NSCalendarUnitEra forDate:date];
    NSInteger selectedYear = [self.calendar ordinalityOfUnit:NSCalendarUnitYear inUnit:NSCalendarUnitEra forDate:[self.dateOwner selectedDate]];
    //NSInteger highlightedYear = [self.calendar ordinalityOfUnit:NSCalendarUnitYear inUnit:NSCalendarUnitEra forDate:[self.dateOwner highlightedDate]];
    
    BOOL isDisabled = (currentMonth != highlightedMonth);
    BOOL isSelected = (currentDay == selectedDay) && (currentMonth == selectedMonth) && (currentYear == selectedYear);
    BOOL isHilighted = (currentDay == highlightedDay) && (currentMonth == highlightedMonth);
    
    return (isDisabled ? UIControlStateDisabled : 0)
         | (isSelected ? UIControlStateSelected : 0)
         | (isHilighted ? UIControlStateHighlighted : 0);
}

- (NSString*)labelForRow:(NSInteger)row
               andColumn:(NSInteger)column
{
    return [self labelForDate:[self dateForRow:row andColumn:column]];
}

- (UIControlState)controlStateForRow:(NSInteger)row
                           andColumn:(NSInteger)column
{
    return [self controlStateForDate:[self dateForRow:row andColumn:column]];
}

@end
