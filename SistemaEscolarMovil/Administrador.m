//
//  Administrador.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 17/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "Administrador.h"

@implementation Administrador

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"idAdministrador" : @"idAdministrador",
             @"nombreAdministrador" : @"nombreAdministrador"
             };
}



@end
