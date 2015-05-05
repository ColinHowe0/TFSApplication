//
//  TFSPartStore.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSPartStore.h"
#import "TFSPart.h"

@interface TFSPartStore ()

@property (nonatomic) NSMutableArray *parts;

@end

@implementation TFSPartStore

//get a static reference to the parts
+ (instancetype)parts
{
    static TFSPartStore *partStore;
    
    if (!partStore) {
        
        partStore = [[self alloc] initSingleton];
    }
    
    return partStore;
}

//to prevent standard initializer, raise exception when using standard init
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[TFSPartStore parts]"];
    return nil;
}

//Designated initializer
- (instancetype)initSingleton
{
    self = [super init];
    
    if (self) {
        _parts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//return the parts array
- (NSArray *)allParts
{
    return [self.parts copy];
}

//remove all the parts from the parts array
- (void)resetParts
{
    while([self.parts count] != 0)
        [self.parts removeLastObject];
}

//add a part to the part store
- (void)addPart:(TFSPart *)part
{
    [self.parts addObject:part];
    
}




@end
