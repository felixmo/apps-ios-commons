//
//  MWApiRequestBuilder.m
//  mwapi
//
//  Created by Brion on 11/6/12.
//  Copyright (c) 2012 Wikimedia Foundation. All rights reserved.
//

#import "MWApiRequestBuilder.h"
#import "NSURLRequest+DictionaryRequest.h"
#import "MWApi.h"

@implementation MWApiRequestBuilder

@synthesize params = params_;
@synthesize api = api_;


-(id) initWithApi:(MWApi *)mwapi
{
    self = [super init];
    if(self){
        params_ = [[NSMutableDictionary alloc] init];
        api_ = mwapi;
        dataType_ = @"json"; //default reponse format is set to json
    }
    return self;
}

-(id) param:(NSString *) key : (id) value
{
    [params_ setObject:value forKey:key];
    return self;
}

-(id) params:(NSDictionary *) keyval {
    for (NSString *key in keyval) {
        [self param:key :keyval[key]];
    }
    return self;
}

-(void)dataType:(NSString *)type
{
    dataType_ = type;
}

-(NSURLRequest *)buildRequest:(NSString *)requestType
{
    [params_ setValue:dataType_ forKey:@"format"];
    if([requestType isEqualToString:@"POST"])
        return [NSURLRequest postRequestWithURL:api_.apiURL parameters:params_];
    else
        return [NSURLRequest getRequestWithURL:api_.apiURL parameters:params_];
}

@end
