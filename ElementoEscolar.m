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
             @"idCircular" : @"idCircular",
             @"titulo" : @"titulo",
             @"fecha" : @"fecha",
             @"remitente" : @"remitente",
             @"contenido" : @"contenido" 
             };
}


+ (NSValueTransformer *)fechaJSONTransformer{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateStr) {
        return [dateFormatter dateFromString:dateStr];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}



@end
