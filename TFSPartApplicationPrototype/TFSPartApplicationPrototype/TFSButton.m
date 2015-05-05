//
//  TFSButton.m
//  TFSPartApplicationPrototype
//
//  Created by user on 5/3/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

/* This code is courtesy of http://blog.ijasoneverett.com/2013/02/a-uibutton-subclass-creating-glossy-buttons-without-images/ with possibly some modifications */

#import "TFSButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TFSButton()

@property (nonatomic) UIColor *unhighlightedColor;
@property (nonatomic) UIColor *highlightedColor;

@end

@implementation TFSButton

- (instancetype)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)backgroundColor
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self makeButtonShiny:backgroundColor];
    }
    
    return self;
}

//here we make the button shiny by adding a gradient layer which contains varying levels of white to backgroundColor
- (void)makeButtonShiny:(UIColor *)backgroundColor
{
    //Set button border and corner rounding radius
    CALayer *buttonLayer = self.layer;
    buttonLayer.cornerRadius = 8.0f;
    buttonLayer.masksToBounds = YES;
    buttonLayer.borderWidth = 2.0f;
    buttonLayer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    //create the gradient layer for the shinyness
    CAGradientLayer *shine = [CAGradientLayer layer];
    shine.frame = self.layer.bounds;
    //set the colors
    shine.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor, nil];
    //set the relative positions of these gradient colors
    shine.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.8f], [NSNumber numberWithFloat:1.0f], nil];
    
    //add the gradient to the button
    [self.layer addSublayer:shine];
    //set the normal button color to the argument, and the highlighted color to the inverse of that color
    //note that the current method is flawed in that it produces a transparent highlighted color if the original color is white. This may or may not be an issue in the future.
    self.unhighlightedColor = backgroundColor;
    const CGFloat *normalColorRGBa = CGColorGetComponents(backgroundColor.CGColor);
    self.highlightedColor = [[UIColor alloc] initWithRed:(1.0 - normalColorRGBa[0]) green:(1.0 - normalColorRGBa[1]) blue:(1.0 - normalColorRGBa[2]) alpha:normalColorRGBa[3]];
    
    [self setBackgroundColor:backgroundColor];
    
}

//highlighting logic
- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(highlighted) {
        [self setBackgroundColor:self.highlightedColor];
    } else {
        [self setBackgroundColor:self.unhighlightedColor];
    }
}

@end
