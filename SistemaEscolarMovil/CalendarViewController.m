//
//  CalendarViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "CalendarViewController.h"
#import "ElementoEscolar.h"
#import "ElementoTableViewCell.h"
#import "EventDetailViewController.h"
#import "Evento.h"

@implementation CalendarViewController
@synthesize eventsByDate;


-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToEvents:(id)response{
    self.elementsData = response;
    [self createEvents];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    [self.eventView reloadData];
}


-(void)refreshTapped{
    [_jsonClient performPOSTRequestWithParameters:nil toServlet:@"mobileReadEvents" withOptions:nil];
    [self createEvents];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    [self.eventView reloadData];
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];
    [self.calendar setCurrentDateSelected:[NSDate date]];
}


- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.eventView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.eventView indexPathForRowAtPoint:location];
    
    //Check if index path is valid
    if(indexPath)
    {
        //Get the cell out of the table view
        UITableViewCell *cell = [self.eventView cellForRowAtIndexPath:indexPath];
        
        //Update the cell or model
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.eventView];
    
    NSIndexPath *indexPath = [self.eventView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.elementoEscolar = (ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row];
        [self addEvent:(ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row]];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];

    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:nil toServlet:@"mobileReadEvents" withOptions:nil];
    self.eventView.dataSource = self;
    self.eventView.delegate = self;
    self.calendar = [JTCalendar new];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.eventView addGestureRecognizer:lpgr];

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
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _jsonClient.delegate = self;
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];

    [self.calendar reloadData]; // Must be call in viewDidAppear
    [self.eventView reloadData];
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
    self.selectedDate =[[self dateFormatterLong] stringFromDate:date];
    
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
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterLong
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [self selectedDate];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElementoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ElementViewCell"];
    
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[(Evento*)[self.dayEvents objectAtIndex:indexPath.row]  fecha]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    
    if ([(Evento*)[self.dayEvents objectAtIndex:indexPath.row] horaInicio]!=nil) {
        dateString = [NSString stringWithFormat:@"%@, %@"
                      ,dateString
                      ,[(Evento*)[self.dayEvents objectAtIndex:indexPath.row] horaInicio]];
    }else{
        dateString = [NSString stringWithFormat:@"%@",dateString];
    }
    
    
    
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.text = [(ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row] titulo];
    cell.remitenteLabel.adjustsFontSizeToFitWidth = YES;
    cell.remitenteLabel.text = [[(ElementoEscolar*)[self.dayEvents objectAtIndex:indexPath.row] administrador]nombreAdministrador];
    cell.fechaEmisionLabel.text = dateString;
    
    
    //[cell.textLabel setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] titulo]];
    
    //[cell.detailTextLabel setText:[[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] administrador ]nombreAdministrador]];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ElementoTableViewCell *cell = (ElementoTableViewCell*)[self.eventView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"showEvento" sender:cell];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EventDetailViewController *destinationViewController = (EventDetailViewController *)segue.destinationViewController;
    
    if([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.eventView indexPathForCell:sender];
        //Your code here
        destinationViewController.elementoEscolar = [self.dayEvents objectAtIndex:indexPath.row];
        destinationViewController.isEvent = YES;
        
    }
    
}


#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             CalendarViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    // Enable the Add button
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

#pragma mark -
#pragma mark Generate dates

-(NSDate*)generateStartDate{
    NSString *stringDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.elementoEscolar.fecha];
    
    
    stringDate = [NSString stringWithFormat:@"%@ %@",stringFromDate, [(Evento*)self.elementoEscolar horaInicio] ];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *fechaInicio = [formatter dateFromString:stringDate];
    
    return fechaInicio;
}


-(NSDate*)generateEndDate{
    NSString *stringDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.elementoEscolar.fecha];
    
    if([(Evento*)self.elementoEscolar horaFinal]!=nil){
            stringDate = [NSString stringWithFormat:@"%@ %@",stringFromDate, [(Evento*)self.elementoEscolar horaFinal] ];
    }else{
            stringDate = [NSString stringWithFormat:@"%@ %@",stringFromDate, [(Evento*)self.elementoEscolar horaInicio] ];
        
    }

    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *fechaInicio = [formatter dateFromString:stringDate];
    
    return fechaInicio;
}


#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (void)addEvent:(id)sender
{
    
    ElementoEscolar  *newElementoEscolar = (ElementoEscolar*)sender;
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    EKEvent *newEvent = [EKEvent eventWithEventStore:self.eventStore];
    
    newEvent.title          = self.elementoEscolar.titulo;
    newEvent.calendar       = self.defaultCalendar;
    newEvent.startDate      = [self generateStartDate];
    newEvent.endDate        = [self generateEndDate];
    
    addController.event     = newEvent;
    addController.editing   = NO;
    
    // Set addController's event store to the current event store
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    CalendarViewController * __weak weakSelf = self;
    
    
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             
         }
     }];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return self.defaultCalendar;
}



@end
