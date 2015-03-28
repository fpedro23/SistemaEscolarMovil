//
//  ElementoEscolar.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "ElementoEscolar.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"


@implementation ElementoEscolar

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"idCircular" : @"pk",
             @"titulo" : @"fields.titulo",
             @"fecha" : @"fields.fechaPublicacion",
             @"contenido" : @"fields.contenido",
             @"administrador" : @"fields.remitente"
             };
}

+ (NSValueTransformer *)fechaJSONTransformer{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateStr) {
        return [dateFormatter dateFromString:dateStr];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}





@end
