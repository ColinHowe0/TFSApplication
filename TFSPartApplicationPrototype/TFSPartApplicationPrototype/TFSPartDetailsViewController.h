//
//  TFSPartDetailsViewController.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSPart;

@interface TFSPartDetailsViewController : UIViewController

//this is a property so that the details view controller can hold on to the part for populating its fields
@property (nonatomic, strong) TFSPart *part;


@end
