//
//  TFSPartStore.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import <Foundation/Foundation.h>

@class TFSPart;

@interface TFSPartStore : NSObject

//the array of all result parts for a given search result. This should be reset when another search is
//performed

@property (nonatomic, readonly, copy) NSArray *allParts;

//this grabs the result parts array singleton
+ (instancetype)parts;
//add a part to the result part storage
- (void)addPart:(TFSPart *)part;

//remove all parts from the part storage
- (void)resetParts;

@end
