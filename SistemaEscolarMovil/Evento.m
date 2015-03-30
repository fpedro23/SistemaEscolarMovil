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
             @"idCircular" : @"pk",
             @"titulo" : @"fields.titulo",
             @"fecha" : @"fields.fechaInicio",
             @"contenido" : @"fields.contenido",
             @"administrador" : @"fields.remitente",
             @"fechaFin" : @"fields.fechaFin",
             };
}


+ (NSValueTransformer *)fechaJSONTransformer{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX" ]];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateStr) {
        return [dateFormatter dateFromString:dateStr];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)fechaFinJSONTransformer{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX" ]];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateStr) {
        return [dateFormatter dateFromString:dateStr];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}


@end
