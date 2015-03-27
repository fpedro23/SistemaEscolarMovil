//
//  ElementoEscolar.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Administrador.h"


@interface ElementoEscolar : MTLModel <MTLJSONSerializing>

@property NSString *idCircular;
@property NSString *titulo;
@property NSString *contenido;
@property NSDate   *fecha;
@property NSString   *administrador;


@end
