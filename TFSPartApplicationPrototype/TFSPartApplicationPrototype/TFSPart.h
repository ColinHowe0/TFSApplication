//
//  TFSPart.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe
//

#import <Foundation/Foundation.h>

@interface TFSPart : NSObject

@property (nonatomic, strong, readonly) NSString *partNumber; //number, represented as string
@property (nonatomic, strong, readonly) NSString *partName;  //part description field
@property (nonatomic, strong, readonly) NSString *partType; //part type field
@property (nonatomic, strong, readonly) NSString *partGroupType; //part group type (e.g. mechanical purchased part)
@property (nonatomic, strong, readonly) NSString *partClass; //class field (e.g. SS 304)

@property (nonatomic, strong, readonly) NSArray *partEndTypes; //an array of strings, that contains the end type descriptions
//of the part

//partSizes is an array of strings specifying the part's sizes
@property (nonatomic, strong, readonly) NSArray *partSizes;

@property (nonatomic, strong, readonly) NSArray *partManufacturers; //manufacturer fields for the part, denoted in strings

@property (nonatomic, strong, readonly) NSString *imageName; //the name of the image associated with this part, nil if no image

@property (nonatomic, strong) UIImage *partThumbnailImage; //the part's image as a thumbnail



/* METHODS */

+ (instancetype)randomPart; //Used for testing purposes only

//Designated Initializer
- (instancetype)initWithFields: (NSDictionary *)partCharacteristics;
- (void)setThumbnailFromImage:(UIImage *)image withDimension:(CGRect)dimension;


@end
