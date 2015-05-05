//
//  TFSApplicationLoadingScreen.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 4/26/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSApplicationLoadingScreen.h"
#import "TFSServerRequest.h"
#import "TFSGradientView.h"

@interface TFSApplicationLoadingScreen ()

@property (strong, nonatomic) TFSGradientView *backgroundGradient;

@end

@implementation TFSApplicationLoadingScreen

//designated initializer
- (instancetype)init
{
    self = [super initWithNibName:@"TFSApplicationLoadingScreen" bundle:nil];
    
    if(self) {
        
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

- (void)viewWillAppear:(BOOL)animated
{
    
    if(!self.backgroundGradient) {
        TFSGradientView *viewGradient = [[TFSGradientView alloc] initWithFrame:self.view.bounds];
        viewGradient.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //dark gray color
        UIColor *firstColor = [[UIColor alloc] initWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.0f alpha:1.0f];
        //lighter gray color
        UIColor *secondColor = [[UIColor alloc] initWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.3f alpha:1.0f];
        viewGradient.layer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor], (id)[secondColor CGColor], (id)[firstColor CGColor], nil];
        self.backgroundGradient = viewGradient;
        [self.view addSubview:self.backgroundGradient];
        [self.view sendSubviewToBack:self.backgroundGradient];
    }
    
}


@end
