//
//  TFSImageStore.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSImageStore.h"

@interface TFSImageStore ()

//dictionary of images with key = imageName and value = image reference or data
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation TFSImageStore

+ (instancetype)images
{
    static TFSImageStore *images;
    
    if(!images) {
        images = [[self alloc] initSingleton];
    }
    
    return images;
}

//prevent calling of init
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[TFSImageStore images]"];
    
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

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}

- (void)resetImages
{
    for(NSString *key in [self.dictionary allKeys])
    {
        [self deleteImageForKey:key];
    }
}


//get an image by finding its path and loading the image into the store from
//the file. This method will need to change in the future depending upon future implementation.
- (void)setImageWithImageName:(NSString *)imageName forKey:(NSString *)key
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [self setImage:image forKey:key];
}
@end
