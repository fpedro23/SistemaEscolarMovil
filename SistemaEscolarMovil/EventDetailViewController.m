//
//  EventDetailViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "EventDetailViewController.h"

@implementation EventDetailViewController
@synthesize elementoEscolar;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.labelTitulo setText:elementoEscolar.titulo];
    [self.labelRemitente setText:elementoEscolar.remitente];
    [self.contenidoTextView setText:elementoEscolar.contenido];

    
}

@end
