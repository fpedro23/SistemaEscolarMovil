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
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAll];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
