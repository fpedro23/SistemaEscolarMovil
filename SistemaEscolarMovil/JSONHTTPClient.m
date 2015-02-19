//
//  JSONHTTPClient.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "JSONHTTPClient.h"
#import "ElementoEscolar.h"
#import "MTLJSONAdapter.h"
#import "Evento.h"


@implementation JSONHTTPClient

+ (JSONHTTPClient *)sharedJSONAPIClient
{
    static JSONHTTPClient *_sharedJSONAPIClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedJSONAPIClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.25.200.152:8080/SistemaEscolar/"]]; //readCircular?mobile=true
    });
    
    return _sharedJSONAPIClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.requestSerializer =  [AFHTTPRequestSerializer serializer];
    }
    
    return self;
}


-(void)performPOSTRequestWithParameters:(NSDictionary *)parameters toServlet:(NSString *)servletName withOptions:(NSString *)option{

    self.servletName = servletName;
    self.parameters = parameters;
    [self GET:servletName parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *JSONResponse = responseObject;
        //Eventos
        if ([servletName isEqual:@"mobileReadEvents"]) {
            NSArray *eventosData = [self deserializeEventsFromJSON:JSONResponse];
            if([self.delegate respondsToSelector:@selector(JSONHTTPClientDelegate:didResponseToEvents:)]){
                [self.delegate JSONHTTPClientDelegate:self didResponseToEvents:eventosData];

            }
        }
        else{
            NSArray *elementsData = [self deserializeElementsFromJSON:JSONResponse];
            
            if ([self.delegate respondsToSelector:@selector(JSONHTTPClientDelegate:didResponseToElements:)]) {
                [self.delegate JSONHTTPClientDelegate:self didResponseToElements:elementsData];
                
            }
            //El servidor notifica si la respuesta es valida o no
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSString *errorStr = [error localizedDescription];
        
        if ([self.delegate respondsToSelector:@selector(JSONHTTPClientDelegate:didFailResponseWithError:)]) {
            [self.delegate JSONHTTPClientDelegate:self didFailResponseWithError:error];
        }

        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Hubo un error al hacer la búsqueda"
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
    }];
    
}


- (NSArray *)deserializeElementsFromJSON:(NSArray *)resultJSON
{
    NSError *error;
    NSArray *works = [MTLJSONAdapter modelsOfClass:[ElementoEscolar class] fromJSONArray:resultJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert Elements JSON to Element models: %@", error);
        return nil;
    }
    
    return works;
}


- (NSArray *)deserializeEventsFromJSON:(NSArray *)resultJSON
{
    NSError *error;
    NSArray *works = [MTLJSONAdapter modelsOfClass:[Evento class] fromJSONArray:resultJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert Elements JSON to Element models: %@", error);
        return nil;
    }
    
    return works;
}
     

@end
