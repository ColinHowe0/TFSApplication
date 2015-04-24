//
//  TFSPartResultsViewController.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import <UIKit/UIKit.h>

@interface TFSPartResultsViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic) NSInteger numParts;

//method for setting the navigation item's label text
- (void)setNavigationItemLabel:(NSString *)labelText;

//method for generating the parts in the partStore (TEMPORARY, USED IN TESTING)
- (void)generateParts:(NSInteger)numParts;



@end
