//
//  HomeViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 20/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementoEscolar.h"
#import "JSONHTTPClient.h"
#import "ZeroPush.h"

@interface HomeViewController : UIViewController <JSONHTTPClientDelegate, ZeroPushDelegate>
@property (strong,nonatomic) ElementoEscolar *elementoEscolar;
@property JSONHTTPClient *jsonClient;

@end
