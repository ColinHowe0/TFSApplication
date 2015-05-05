//
//  TFSButton.h
//  TFSPartApplicationPrototype
//
//  Created by user on 5/3/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFSButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)backgroundColor;
- (void)makeButtonShiny:(UIColor *)backgroundColor;

@end
