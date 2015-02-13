//
//  CircularesTableViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONHTTPClient.h"

@interface CircularesTableViewController : UITableViewController <JSONHTTPClientDelegate>
@property NSArray *elementsData;
@property (strong,nonatomic) UIRefreshControl *updateControl;
@end
