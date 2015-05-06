//
//  TFSPart.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe
//

#import "TFSPart.h"
#import "TFSImageStore.h"

@implementation TFSPart


+ (instancetype)randomPart
{
    NSArray *randomNumbers = @[@"1076-150-273011", @"1076-207-017150", @"1078-160-032330"];
    NSArray *randomClass = @[@"PFA", @"Carbon Steel, PTFE Lined 150 lb.", @"Polypropylene, 150lb"];
    NSArray *randomAdjectives = @[@"Large", @"Sharp", @"Pointy", @"Lame", @"Cool", @"Fluffy"];
    NSArray *randomAdjectives2 = @[@"Extreme", @"Enigmatic", @"Cold", @"Sizeable", @"Destructive", @"Calming"];
    NSArray *randomName = @[@"Pipe", @"Elbow", @"Hinge", @"Nut", @"Bolt", @"Thing"];
    NSArray *randomPossession = @[@"Scissors", @"PC", @"Kitten", @"JetPack", @"Asteroid", @"HappyFunBall"];
    NSArray *imageNames = @[@"image1",@"image2",@"image3",@"image4",@"image5",@"image6",@"image7",@"image8"];
    
    int desc1 = arc4random() % 6, desc2 = arc4random() % 6, desc3 = arc4random() % 6, desc4 = arc4random() %6;
    int imageDesignation = arc4random() % 8;
    
    NSString *randomPartName = [NSString stringWithFormat:@"%@ %@ %@ %@", randomAdjectives[desc1], randomAdjectives2[desc2],randomPossession[desc4], randomName[desc3]];
    
    int index = arc4random() % 3;
    NSArray *partInfo = [[NSArray alloc] initWithObjects:randomNumbers[index], randomPartName, @"This is a random type.", @"This is a random group type", randomClass[index], @[@"random end type 1", @"random end type 2"], @[@"1 3/4\"", @"1/2\""], @[@"manufacturer 1", @"manufacturer 2"], imageNames[imageDesignation], nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"partNumber",@"partName", @"partType", @"partGroupType", @"partClass", @"partEndTypes", @"partSizes", @"partManufacturers", @"partImageName", nil];
    NSDictionary *partCharacteristics = [[NSDictionary alloc] initWithObjects:partInfo forKeys:keys];
    
    
    TFSPart *newPart = [[self alloc] initWithFields:partCharacteristics];
    
    return newPart;
}

//Designated Initializer
- (instancetype)initWithFields:(NSDictionary *)partCharacteristics
{
    self = [super init];
    
    if (self) {
        _partNumber = partCharacteristics[@"PNum"];
        _partName = partCharacteristics[@"PName"];
        _partType = partCharacteristics[@"PT"];
        _partGroupType = partCharacteristics[@"Group"];
        _partClass = partCharacteristics[@"Class"];
        _partEndTypes = [[NSArray alloc] initWithObjects:partCharacteristics[@"ET1"] ? partCharacteristics[@"ET1"] : @"NA", partCharacteristics[@"ET2"] ? partCharacteristics[@"ET2"] : @"NA", partCharacteristics[@"ET3"] ? partCharacteristics[@"ET3"] : @"NA",nil];
        _partSizes = [[NSArray alloc] initWithObjects:partCharacteristics[@"Size1"] ? partCharacteristics[@"Size1"] : @"NA", partCharacteristics[@"Size2"] ? partCharacteristics[@"Size2"] : @"NA", partCharacteristics[@"Size3"] ? partCharacteristics[@"Size3"] : @"NA", nil];
        NSString *mfgOneString = [NSString stringWithFormat:@"%@ - %@", partCharacteristics[@"MFG1"] ? partCharacteristics[@"MFG1"] : @"NA", partCharacteristics[@"MFGN1"] ? partCharacteristics[@"MFGN1"] : @"NA"];
        NSString *mfgTwoString = [NSString stringWithFormat:@"%@ - %@", partCharacteristics[@"MFG2"] ? partCharacteristics[@"MFG2"] : @"NA", partCharacteristics[@"MFGN2"] ? partCharacteristics[@"MFGN2"] : @"NA" ];
        NSString *mfgThreeString = [NSString stringWithFormat:@"%@ - %@", partCharacteristics[@"MFG3"] ? partCharacteristics[@"MFG3"] : @"NA", partCharacteristics[@"MFGN3"] ? partCharacteristics[@"MFGN3"] : @"NA" ];
        
        
        _partManufacturers = [[NSArray alloc] initWithObjects:mfgOneString, mfgTwoString, mfgThreeString, nil];
        _imageName = partCharacteristics[@"ImageName"];
        
        if(!_partNumber) _partNumber = @"NA";
        if(!_partName) _partName = @"NA";
        if(!_partType) _partType = @"NA";
        if(!_partGroupType) _partGroupType = @"NA";
        if(!_partClass) _partClass = @"NA";
        if(!_imageName) _imageName = @"NO IMAGE";
       
       
    }
    
    return self;
}

- (void)setThumbnailFromImage:(UIImage *)image withDimension:(CGRect)dimension
{
   
    
    CGSize origImageSize = image.size;
    
    //The rectangle of the thumbnail
    CGRect newRect = dimension;
    
    //Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height/origImageSize.height);
    //Create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    
    //Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    //Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //Draw the image on it
    [image drawInRect:projectRect];
    
    //Get the image rom the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.partThumbnailImage = smallImage;
    
    //Cleanup image context resources; we're done
    UIGraphicsEndImageContext(); 
}




@end
