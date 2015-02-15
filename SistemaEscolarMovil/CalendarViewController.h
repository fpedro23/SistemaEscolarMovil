//
//  CalendarViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JSONHTTPClient.h"

@interface CalendarViewController : UIViewController <JTCalendarDataSource,JSONHTTPClientDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;
@property (strong,nonatomic) NSMutableDictionary *eventsByDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property NSArray *elementsData;
@property NSMutableArray *dayEvents;

@property JSONHTTPClient *jsonClient;
@property (weak, nonatomic) IBOutlet UITableView *eventView;



@end
