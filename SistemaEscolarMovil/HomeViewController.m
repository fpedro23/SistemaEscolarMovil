//
//  HomeViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 20/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "HomeViewController.h"
#import "EventDetailViewController.h"
#import "Zeropush.h"
#import "Evento.h"
#import "LoginViewController.h"
#import "AFOAuth2Manager.h"


@interface HomeViewController ()

@end

@implementation HomeViewController


-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    EventDetailViewController *eventoDetail = [self.storyboard
                                               instantiateViewControllerWithIdentifier:@"EventDetail"];
    
    self.elementoEscolar = (ElementoEscolar*)[response firstObject];
    eventoDetail.elementoEscolar = self.elementoEscolar;
    [self.tabBarController setSelectedIndex:0 ];
    [self.navigationController pushViewController:eventoDetail animated:YES];

}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToEvents:(id)response{
    EventDetailViewController *eventoDetail = [self.storyboard
                                               instantiateViewControllerWithIdentifier:@"EventDetail"];
    
    self.elementoEscolar = (Evento*)[response firstObject];
    eventoDetail.elementoEscolar = (Evento*)self.elementoEscolar;
    eventoDetail.isEvent = YES;
    [self.tabBarController setSelectedIndex:0 ];
    [self.navigationController pushViewController:eventoDetail animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    _jsonClient.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
    //now ask the user if they want to recieve push notifications. You can place this in another part of your app.
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    [ZeroPush engageWithAPIKey:@"iosprod_8KN8qkdVN2N4empsY6Kk" delegate:self];
    [[ZeroPush shared] registerForRemoteNotifications];
    // Do any additional setup after loading the view.
    _jsonClient.delegate = self;

}



- (IBAction)logoutPressed:(id)sender {

    LoginViewController *login =
    [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    
    [self presentViewController:login animated:YES completion:nil];
    
}


-(void)pushNotificationReceived:(NSNotification*)notification{
    

    NSDictionary *userInfo = notification.userInfo;
    _jsonClient.delegate = self;

    //Basado en el tipo ejecutar el metodo correspondiente.
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:[userInfo objectForKey:@"idCircular"] forKey:@"id"];
    [parameters setObject:[[AFOAuthCredential retrieveCredentialWithIdentifier:@"usuario"] accessToken] forKey:@"access_token"];
    
    if([[userInfo objectForKey:@"tipo"]isEqualToString:@"circular"]){
        [_jsonClient performPOSTRequestWithParameters:parameters toServlet:@"api/circular" withOptions:nil];

        
    }else if ([[userInfo objectForKey:@"tipo"]isEqualToString:@"aviso"]){
        [_jsonClient performPOSTRequestWithParameters:parameters toServlet:@"api/aviso" withOptions:nil];

        
    }else {
        [_jsonClient performPOSTRequestWithParameters:parameters toServlet:@"api/evento" withOptions:nil];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
