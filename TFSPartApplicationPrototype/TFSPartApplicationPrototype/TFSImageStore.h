//
//  TFSImageStore.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFSImageStore : NSObject

//singleton instance of images
+ (instancetype)images;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (void)setImageWithImageName:(NSString *)imageName forKey:(NSString *)key;

//removes all objects in the store
- (void)resetImages;

@end
