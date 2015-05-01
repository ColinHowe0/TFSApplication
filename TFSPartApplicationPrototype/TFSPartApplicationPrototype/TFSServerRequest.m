//
//  TFSServerRequest.m
//  TFSPartApplicationPrototype
//
//  Created by user on 4/26/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSServerRequest.h"
#import "TFSPartStore.h"
#import "TFSImageStore.h"
#import "TFSPart.h"
#import "TFSConfigurationData.h"


@interface TFSServerRequest ()

//the server's url + the query appended in the proper format
@property (nonatomic, copy) NSURL *serverURLAndQuery;
//http request to send to php script on server
@property (nonatomic, strong) NSMutableURLRequest *request;
//session object for transfer tasks
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TFSServerRequest

static TFSServerRequestType rt;

//designated initializer
- (instancetype)initWithRequestString:(NSString *)requestString withRequestType:(TFSServerRequestType)requestType
{
    self = [super init];
    
    if(self) {
        rt = requestType;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        //Make url compatible
        requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //previous method ignores "/" character, so replace with url encode of "/"
        requestString = [requestString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
        requestString = [requestString stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
        NSLog(@"Modified Request String: %@", requestString);
        //if our request is to fetch the part data, then use the query string
        if(rt == TFSServerPartDataRequest) {
            NSString *req = [NSString stringWithFormat:@"http://45.56.71.18:8080/SDServe/webresources/server/%@",requestString];
            self.serverURLAndQuery = [NSURL URLWithString:req];
        }
        else //otherwise fetch the config data
            self.serverURLAndQuery = [NSURL URLWithString:[NSString stringWithFormat:@"http://45.56.71.18:8080/SDServe/webresources/server/config"]];
        
        self.request = [NSMutableURLRequest requestWithURL:self.serverURLAndQuery];
    }
    
    return self;
}

- (void)sendRequest
{
    //get the data for the parts and the image data from a json
    if(rt == TFSServerPartDataRequest) {
        NSLog(@"%@ %@", @"Doing a data request at", self.serverURLAndQuery);
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //parse json
            NSError *jsonError;
            if(!error) {
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if(jsonObject && !jsonError)
                {
            
                //initialize parts based on dictionary of part info within json parts array
                    if(jsonObject[@"parts"]) {
                        NSArray *partInfoArray = jsonObject[@"parts"];
                        if(partInfoArray)
                        {
                            for(NSDictionary *thing in partInfoArray) {
                                [[TFSPartStore parts] addPart:[[TFSPart alloc] initWithFields:thing]];
                            }
                        }
                    }
                    if(jsonObject[@"images"]) {
                        NSArray *imageDataArray = jsonObject[@"images"];
                        for(NSDictionary *imageDict in imageDataArray) {
                            for(NSString *imageName in [imageDict allKeys]) {
                                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageDict[imageName] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                                [[TFSImageStore images] setImage:[UIImage imageWithData:imageData] forKey:imageName];
                            }
                        }
                    }
                } else {
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
        }
        else {
            NSLog(@"Connection Error: %@", [error localizedDescription]);
        }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Part Data Received" object:self];
        
    }];
        [dataTask resume];
        

    } else {
        NSLog(@"%@ at %@", @"Doing a configuration request", self.serverURLAndQuery);
        //get the config data and load it into the config data dictionary
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //parse json
            NSError *jsonError;
            if(!error) {
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    NSLog(@"%@", jsonObject);
                if(jsonObject && !jsonError) {
                    NSArray *sizeArr = [[NSArray alloc] initWithArray:jsonObject[@"size"]];
                    NSArray *groupArr = [[NSArray alloc] initWithArray:jsonObject[@"group"]];
                    NSArray *partArr = [[NSArray alloc] initWithArray:jsonObject[@"part"]];
                    NSArray *classArr = [[NSArray alloc] initWithArray:jsonObject[@"class"]];
                    NSArray *endArr = [[NSArray alloc] initWithArray:jsonObject[@"end"]];
                    NSArray *mfgArr = [[NSArray alloc] initWithArray:jsonObject[@"mfg"]];
                    [[TFSConfigurationData configDictionary] setConfigData:sizeArr forKey:@"size"];
                    [[TFSConfigurationData configDictionary] setConfigData:groupArr forKey:@"group"];
                    [[TFSConfigurationData configDictionary] setConfigData:partArr forKey:@"part"];
                    [[TFSConfigurationData configDictionary] setConfigData:classArr forKey:@"class"];
                    [[TFSConfigurationData configDictionary] setConfigData:endArr forKey:@"end"];
                    [[TFSConfigurationData configDictionary] setConfigData:mfgArr forKey:@"mfg"];
                }
                else {
                    NSLog(@"%@", [jsonError localizedDescription]);
                }
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
            NSLog(@"Configuration Data Loaded.");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Config Data Received" object:self];

        }];
        [dataTask resume];
    }
    
    
}


@end
