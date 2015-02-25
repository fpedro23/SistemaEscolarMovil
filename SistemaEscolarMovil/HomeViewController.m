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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
    //now ask the user if they want to recieve push notifications. You can place this in another part of your app.
    [[ZeroPush shared] registerForRemoteNotifications];
    // Do any additional setup after loading the view.
}

- (NSArray *)deserializeCircularFromJSON:(NSDictionary *)resultJSON
{
    NSError *error;
    // NSArray *works = [MTLJSONAdapter modelsOfClass:[Administrador class] fromJSONArray:resultJSON error:&error];
    NSArray *works = [MTLJSONAdapter modelOfClass:[ElementoEscolar class] fromJSONDictionary:resultJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert Elements JSON to Circular models: %@", error);
        return nil;
    }
    
    return works;
}

-(void)pushNotificationReceived:(NSNotification*)notification{
    
    EventDetailViewController *eventoDetail = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"EventDetail"];
    NSDictionary *userInfo = notification.userInfo;
    
    NSArray *result = [self deserializeCircularFromJSON:userInfo];
    NSLog(@"%@",[(ElementoEscolar*)result titulo]);
    self.elementoEscolar = (ElementoEscolar*)result;
    
    eventoDetail.elementoEscolar = self.elementoEscolar;
    
    [self.tabBarController setSelectedIndex:0 ];
    [self.navigationController pushViewController:eventoDetail animated:YES];
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
