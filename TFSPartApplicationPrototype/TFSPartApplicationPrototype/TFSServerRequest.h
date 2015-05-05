//
//  TFSPartDataRequest.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 4/17/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSPartResultsViewController.h"

@interface TFSServerRequest : NSObject <NSURLSessionDelegate>

typedef NS_ENUM(NSUInteger, TFSServerRequestType) {
    TFSServerConfigRequest,
    TFSServerPartDataRequest
};

//designated initializer with request string argument
- (instancetype)initWithRequestString:(NSString *)requestString withRequestType:(TFSServerRequestType)requestType;

//send request and get data
- (void)sendRequest;


@end
