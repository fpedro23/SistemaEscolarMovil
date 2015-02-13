//
//  AvisosTableViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONHTTPClient.h"


@interface AvisosTableViewController : UITableViewController<JSONHTTPClientDelegate>
@property NSArray *elementsData;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end
