//
//  JSONHTTPClient.h
//  Versailles
//
//  Created by Abdiel on 7/11/14.
//  Copyright (c) 2014 Smartthinking. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol JSONHTTPClientDelegate;

@interface JSONHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<JSONHTTPClientDelegate>delegate;
@property (nonatomic, strong) NSString *servletName;
@property (nonatomic, strong) NSDictionary *parameters;
+ (JSONHTTPClient *)sharedJSONAPIClient;

- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)performPOSTRequestWithParameters:(NSDictionary *)parameters toServlet:(NSString *)servletName withOptions:(NSString *)option;


@end

@protocol JSONHTTPClientDelegate <NSObject>

@optional

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response;
-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToEvents:(id)response;
-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToLogin:(id)response;

@required

////// General

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error;

@end