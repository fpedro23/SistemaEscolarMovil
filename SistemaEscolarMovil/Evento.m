//
//  Evento.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 19/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "Evento.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"


@implementation Evento

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"idCircular" : @"idCircular",
             @"titulo" : @"titulo",
             @"fecha" : @"fecha",
             @"contenido" : @"contenido",
             @"administrador" : @"administradoridAdministrador",
             @"horaInicio" : @"horaInicio",
             @"horaFinal" : @"horaFinal"
             };
}




@end
