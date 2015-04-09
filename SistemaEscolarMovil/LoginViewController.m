//
//  LoginViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 19/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "LoginViewController.h"
#import "Administrador.h"
#import "AFOAuth2Manager.h"


@interface LoginViewController ()
@property AFOAuth2Manager *OAuth2Manager;
@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *baseURL = [NSURL URLWithString:@"http://edicomex.com.mx:8001/"];
    self.OAuth2Manager =
    [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                    clientID:@"7BIPYJfcu6KnPKHD7T38kKl7PStLs2wumB6tWXJN"                                      secret:@"qp91aGv0LIo5WTe30dT6D5ewOoVEPSwNm2Cx7H3L0M6peF0Wj1SKYuaRWlRqYlLFFUhjHAJa3iUeVW10V4q94ccJUrRkT4IxhDLQ3M1eB1sZwrpyCYOdgBJqgdJ3z4iQ"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (IBAction)loginPressed:(id)sender {
    

    self.OAuth2Manager.useHTTPBasicAuthentication = NO;
    
    
    [self.OAuth2Manager authenticateUsingOAuthWithURLString:@"/o/token/"
                                              username:[_usuarioTextField text]
                                              password:[_passwordTextField text]
     
                                                 scope:@"read write"
                                               success:^(AFOAuthCredential *credential) {
                                                   NSLog(@"Token: %@", credential.accessToken);
                                                   [AFOAuthCredential storeCredential:credential
                                                                       withIdentifier:@"usuario"];
                                                   [self performSegueWithIdentifier:@"showViews" sender:sender];

                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error: %@", error);
                                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                               message:@"Los datos de Login Son Incorrectos"
                                                                              delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                               }];
    

}
@end
