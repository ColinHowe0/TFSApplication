//
//  TFSPartDetailsViewController.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//

#import "TFSPartDetailsViewController.h"
#import "TFSPart.h"
#import "TFSImageStore.h"

@interface TFSPartDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizesLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTypesLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturersLabel;


@end

@implementation TFSPartDetailsViewController


//overriding init to give this view controller a view image button
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Part Details";
        
        //Create a new bar button item that will send viewImage: to this view controller
        UIBarButtonItem *viewImageButton = [[UIBarButtonItem alloc] initWithTitle:@"View Image" style:UIBarButtonItemStylePlain target:self action:@selector(viewPartImage)];
        navItem.rightBarButtonItem = viewImageButton;
    }
    
    return self;
}

//prepare the view by populating the labels with appropriate data
- (void)viewWillAppear:(BOOL)animated
{
    int numLines = 1;
    [super viewWillAppear:animated];
    
    TFSPart *part = self.part;
    
    self.numberLabel.text = part.partNumber;
    self.nameLabel.text = part.partName;
    self.groupLabel.text = part.partGroupType;
    
    NSMutableString *sizeString = [[NSMutableString alloc] init];
    //initialize the size label by appending size strings
    for (NSString *size in part.partSizes) {
        NSString *appendString = [NSString stringWithFormat:@"%@\n",size];
        [sizeString appendString:appendString];
        numLines++;
    }
    self.sizesLabel.numberOfLines = numLines;
    self.sizesLabel.text = sizeString;
    self.classLabel.text = part.partClass;
    
    numLines = 1;
    //initialize the end types label by appending end type strings
    NSMutableString *endTypeString = [[NSMutableString alloc] init];
    for(NSString *endType in part.partEndTypes) {
        NSString *appendString = [NSString stringWithFormat:@"%@\n",endType];
        [endTypeString appendString:appendString];
        numLines++;
    }
    
    self.endTypesLabel.numberOfLines = numLines;
    self.endTypesLabel.text = endTypeString;
    
    numLines = 1;
    //initialize manufacturer's label in the same manner as above
    NSMutableString *manufacturersString = [[NSMutableString alloc] init];
    for(NSString *manufacturer in part.partManufacturers) {
        NSString *appendString = [NSString stringWithFormat:@"%@\n",manufacturer];
        [manufacturersString appendString:appendString];
        numLines++;
    }
    
    self.manufacturersLabel.numberOfLines = numLines;
    self.manufacturersLabel.text = manufacturersString;
}

//When the user taps the View Image button, display the part's associated image in a modal viewController that contains
//a UIImageView
- (void)viewPartImage
{
    TFSImageStore *images = [TFSImageStore images];
    UIViewController *imageViewController = [[UIViewController alloc] init];
    
    imageViewController.view.backgroundColor = [UIColor blackColor];
    imageViewController.view.userInteractionEnabled = YES;
    
    //Dismissal button
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navBar.backgroundColor = [UIColor clearColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = [NSString stringWithFormat:@"%@", self.part.partNumber];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleDone target:self action:@selector(dismissImageView:)];
    navItem.rightBarButtonItem = dismissButton;
    
    navBar.items = @[navItem];
    [imageViewController.view addSubview:navBar];
    
    //Image view
    UIImageView *partImageView = [[UIImageView alloc] initWithFrame:imageViewController.view.frame];
    partImageView.contentMode = UIViewContentModeScaleAspectFit;
    partImageView.image = [images imageForKey:self.part.imageName];
    
    [imageViewController.view addSubview:partImageView];
    
    [self presentViewController:imageViewController animated:YES completion:nil];
    
}

//selector for the button to dismiss the image view
- (void)dismissImageView:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
