//
//  EventDetailViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ElementoEscolar.h"


@interface EventDetailViewController : UIViewController <EKEventEditViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UILabel *labelRemitente;
@property (weak, nonatomic) IBOutlet UITextView *contenidoTextView;
@property (weak,nonatomic)  ElementoEscolar *elementoEscolar;
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

// Used to add events to Calendar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
