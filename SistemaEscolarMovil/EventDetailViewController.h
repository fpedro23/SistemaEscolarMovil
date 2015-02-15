//
//  EventDetailViewController.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementoEscolar.h"

@interface EventDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UILabel *labelRemitente;
@property (weak, nonatomic) IBOutlet UITextView *contenidoTextView;
@property (weak,nonatomic)  ElementoEscolar *elementoEscolar;
@end
