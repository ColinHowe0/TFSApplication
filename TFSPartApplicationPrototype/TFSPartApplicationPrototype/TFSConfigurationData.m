//
//  TFSConfigurationData.m
//  TFSPartApplicationPrototype
//
//  Created by user on 4/26/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSConfigurationData.h"

@interface TFSConfigurationData ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation TFSConfigurationData

+ (instancetype)configDictionary
{
    static TFSConfigurationData *configData;
    
    if(!configData) {
        configData = [[self alloc] initSingleton];
    }
    
    return configData;
}

//prevent calling of init
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use + [TFSConfigData configDictionary]"];
    
    return nil;
}

//Designated Initializer
- (instancetype)initSingleton
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

//set a config data argument as an array
- (void)setConfigData:(NSArray *)data forKey:(NSString *)key
{
    self.dictionary[key] = data;
}

//get a config data element from a key
- (NSArray *)getConfigDataForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteConfigDataForKey:(NSString *)key
{
    //delete the config data at the given key
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

//reset the config Data object's memory by removing all its elements
- (void)resetConfigData
{
    for (NSString *key in [self.dictionary allKeys]) {
        [self deleteConfigDataForKey:key];
    }
}


@end
