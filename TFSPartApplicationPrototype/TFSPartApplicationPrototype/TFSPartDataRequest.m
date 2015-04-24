//
//  TFSPartDataRequest.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 4/17/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSPartDataRequest.h"
#import "TFSPartStore.h"
#import "TFSImageStore.h"
#import "TFSPart.h"


@interface TFSPartDataRequest ()

//the server's url + the query appended in the proper format
@property (nonatomic, copy) NSURL *serverURLAndQuery;
//http request to send to php script on server
@property (nonatomic, strong) NSMutableURLRequest *request;
//session object for transfer tasks
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TFSPartDataRequest

static BOOL *signalForLoading;

//designated initializer
- (instancetype)initWithRequestString:(NSString *)requestString withSignal:(BOOL *)signal;
{
    self = [super init];
    
    if(self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Modified Request String: %@", requestString);
        self.serverURLAndQuery = [NSURL URLWithString:[NSString stringWithFormat:@"http://45.56.71.18/test.php?query=%@",requestString]];
        self.request = [NSMutableURLRequest requestWithURL:self.serverURLAndQuery];
        signalForLoading = signal;
    }
    
    return self;
}

- (void)sendRequest
{
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //parse js
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonObject && !error && !jsonError)
        {
            
            //initialize parts based on dictionary of part info within json parts array
            NSArray *partInfoArray = jsonObject[@"parts"];
            if(partInfoArray)
            {
                for(NSDictionary *thing in partInfoArray) {
                    [[TFSPartStore parts] addPart:[[TFSPart alloc] initWithFields:thing]];
                }
            }
            //no errors so parse the jsonObject into the part store
            //and then use async dispatch to signal main thread that the data is loaded
            //NSLog(@"%@", jsonObject);
        }
        else
            NSLog(@"%@\n%@", [error localizedDescription], [jsonError localizedDescription]);
        
        *signalForLoading = YES;
        
    }];
    [dataTask resume];
}


@end
