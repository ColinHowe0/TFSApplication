//
//  TFSPartDataRequest.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 4/17/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSPartResultsViewController.h"

@interface TFSPartDataRequest : NSObject <NSURLSessionDelegate>

//designated initializer with request string argument
- (instancetype)initWithRequestString:(NSString *)requestString withSignal:(BOOL *)signal;

//send request and get data
- (void)sendRequest;

@end
