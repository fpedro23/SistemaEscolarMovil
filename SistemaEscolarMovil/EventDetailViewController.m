//
//  EventDetailViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "EventDetailViewController.h"

#import "Administrador.h"



@implementation EventDetailViewController
@synthesize elementoEscolar;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    // The Add button is initially disabled
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    
    self.labelTitulo.adjustsFontSizeToFitWidth = YES;
    self.labelTitulo.numberOfLines = 2;
    self.labelTitulo.clipsToBounds = YES;
    
    NSString *stringRemitente = [NSString stringWithFormat:@"Remitente: %@",self.elementoEscolar.administrador.nombreAdministrador];
    
    [self.labelTitulo setText:elementoEscolar.titulo];
    
    [self.labelFecha setText:[NSString stringWithFormat:@"Emitida: %@",[[self dateFormatterLong] stringFromDate:self.elementoEscolar.fecha]]];
    [self.labelRemitente setText:stringRemitente];
    [self.contenidoTextView setText:elementoEscolar.contenido];
    [_contenidoTextView scrollRangeToVisible:NSMakeRange(0, 0)];

    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm";
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
             EventDetailViewController * __weak weakSelf = self;
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
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (void)addEvent:(id)sender
{
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    EKEvent *newEvent = [EKEvent eventWithEventStore:self.eventStore];

    newEvent.title = self.elementoEscolar.titulo;
    newEvent.calendar = self.defaultCalendar;
    addController.event = newEvent;
    addController.editing = NO;
    
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
    EventDetailViewController * __weak weakSelf = self;
    

    
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
