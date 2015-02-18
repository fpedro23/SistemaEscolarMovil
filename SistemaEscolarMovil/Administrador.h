//
//  Administrador.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 17/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface Administrador : MTLModel <MTLJSONSerializing>
@property NSString *idAdministrador;
@property NSString *nombreAdministrador;

@end
