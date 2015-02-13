//
//  FirstViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "FirstViewController.h"
#import "ElementoEscolar.h"

@interface FirstViewController ()
@property NSArray *elementsData;
@property (nonatomic, strong) JSONHTTPClient *jsonClient;

@end

@implementation FirstViewController

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    self.elementsData = response;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    
    NSDictionary* dict = @{
                          @"mobile": @"true"
                          };
    
    
    
    [_jsonClient performPOSTRequestWithParameters:dict toServlet:@"readCircular"                     withOptions:nil];
//http://192.168.100.36:8080/SistemaEscolar/readCircular?mobile=true
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
