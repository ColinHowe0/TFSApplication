//
//  TFSApplicationLoadingScreen.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 4/26/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSApplicationLoadingScreen.h"
#import "TFSServerRequest.h"

@interface TFSApplicationLoadingScreen ()

@end

@implementation TFSApplicationLoadingScreen

//designated initializer
- (instancetype)init
{
    self = [super initWithNibName:@"TFSApplicationLoadingScreen" bundle:nil];
    
    //initialize here
    if (self) {
        
    }
    
    return self;
}

//here, produce the configuration data by accessing the server and grabbing that data. Then notify the main application that the data has been produced and the application is ready to proceed.
- (void)viewDidLoad
{
    TFSServerRequest *configurationDataRequest = [[TFSServerRequest alloc] initWithRequestString:nil withRequestType:TFSServerConfigRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"Config Data Received" object:configurationDataRequest];
    
    [configurationDataRequest sendRequest];
}

//selector for dismissing the view once the config data has been loaded into the config data dictionary object
- (void)dismissView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Done Loading" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
