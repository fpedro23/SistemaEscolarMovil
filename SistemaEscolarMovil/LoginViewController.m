//
//  LoginViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 19/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "LoginViewController.h"
#import "JSONHTTPClient.h"
#import "Administrador.h"

@interface LoginViewController ()
@property JSONHTTPClient *jsonClient;
@end

@implementation LoginViewController

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}


-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToLogin:(id)response{
    self.administratorData = response;
        [self shouldPerformSegueWithIdentifier:@"showViews" sender:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([[self.administratorData success ] isEqualToString:@"false"]){
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Los datos de Login Son Incorrectos"
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return NO;
    
        
    }
    else{
        [self performSegueWithIdentifier:@"showViews" sender:sender];
        
        return YES;

    }
    
}


- (IBAction)loginPressed:(id)sender {
    NSMutableDictionary * dictionary = [NSMutableDictionary new];
    [dictionary setObject:[_usuarioTextField text] forKey:@"nombre"];
    [dictionary setObject:[_passwordTextField text] forKey:@"password"];
    [_jsonClient performPOSTRequestWithParameters:dictionary toServlet:@"mobileLogin" withOptions:nil];
}
@end
