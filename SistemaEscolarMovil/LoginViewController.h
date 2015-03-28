//
//  LoginViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 19/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONHTTPClient.h"
@class Administrador;

@interface LoginViewController : UIViewController
@property Administrador *administratorData;
@property (weak, nonatomic) IBOutlet UITextField *usuarioTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginPressed:(id)sender;

@end
