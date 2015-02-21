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
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ElementoEscolar.h"

@interface CalendarViewController : UIViewController <EKEventEditViewDelegate,JTCalendarDataSource,JSONHTTPClientDelegate, UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;
@property (strong,nonatomic) NSMutableDictionary *eventsByDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property NSArray *elementsData;
@property NSMutableArray *dayEvents;

@property JSONHTTPClient *jsonClient;
@property (weak, nonatomic) IBOutlet UITableView *eventView;
@property (strong,nonatomic) NSString *selectedDate;
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

// Used to add events to Calendar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property ElementoEscolar *elementoEscolar;


@end
