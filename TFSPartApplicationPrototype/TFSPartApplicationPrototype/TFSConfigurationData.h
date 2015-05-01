//
//  TFSConfigurationData.h
//  TFSPartApplicationPrototype
//
//  Created by user on 4/26/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFSConfigurationData : NSObject

+ (instancetype)configDictionary;

- (void)setConfigData:(NSArray *)data forKey:(NSString *)key;
- (NSArray *)getConfigDataForKey:(NSString *)key;

- (void)resetConfigData;


@end
