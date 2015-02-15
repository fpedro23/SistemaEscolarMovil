//
//  CalendarViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "CalendarViewController.h"
#import "ElementoEscolar.h"

@implementation CalendarViewController
@synthesize eventsByDate;


-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    self.elementsData = response;
    [self createEvents];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    [self.eventView reloadData];
}


-(void)refreshTapped{
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readEvent" withOptions:nil];
    [self createEvents];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    [self.eventView reloadData];
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];
    [self.calendar setCurrentDateSelected:[NSDate date]];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readEvent" withOptions:nil];
    self.eventView.dataSource = self;
    self.calendar = [JTCalendar new];

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTapped)];
    
    [self.navigationItem setRightBarButtonItem:refreshButton];
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _jsonClient.delegate = self;

    [self.calendar reloadData]; // Must be call in viewDidAppear
}

// Update the position of calendar when rotate the screen, call `calendarDidLoadPreviousPage` or `calendarDidLoadNextPage`
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    
    self.dayEvents = eventsByDate[key];
    
    NSLog(@"Date: %@ - %ld events", date, [self.dayEvents count]);
    [self.eventView reloadData];
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark -  Data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    
    return dateFormatter;
}

- (void)createEvents
{
    
    if(!eventsByDate){
        eventsByDate = [NSMutableDictionary new];
    }else{
        [eventsByDate removeAllObjects];
    }
    
    for (ElementoEscolar *evento in self.elementsData) {
        NSString *key = [[self dateFormatter] stringFromDate:evento.fecha];
        // Use the date as key for eventsByDate
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:evento];

    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dayEvents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.textLabel setText:[(ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row] titulo]];
    [cell.detailTextLabel setText:[(ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row] remitente]];
    

    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



@end
