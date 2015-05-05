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
#import "TFSGradientView.h"
#import "TFSButton.h"

@interface TFSPartDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizesLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTypesLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturersLabel;

//like on the search page, retain a reference to this page's gradient view for the background
@property (strong, nonatomic) TFSGradientView *backgroundGradient;
//the part image
@property (strong, nonatomic) UIImage *partImage;


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
        //UIBarButtonItem *viewImageButton = [[UIBarButtonItem alloc] initWithTitle:@"View Image" style:UIBarButtonItemStylePlain target:self action:@selector(viewPartImage)];
        //navItem.rightBarButtonItem = viewImageButton;
        TFSButton *vib;
        //set the view image button in the navbar
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSLog(@"This device is an ipad.");
            vib = [[TFSButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.5f , 39) withBackgroundColor:[UIColor redColor]];
        } else {
            vib = [[TFSButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.33f, 39) withBackgroundColor:[UIColor redColor]];
        }
            
        vib.titleLabel.font = [UIFont fontWithName:@"System" size:30.0];
        vib.titleLabel.adjustsFontSizeToFitWidth = YES;
        vib.titleLabel.textAlignment = NSTextAlignmentCenter;
        vib.titleLabel.textColor = [UIColor whiteColor];
        [vib setTitle:@"View Image" forState:UIControlStateNormal];
        [vib setTitle:@"View Image" forState:UIControlStateHighlighted];
        [vib addTarget:self action:@selector(viewPartImage) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *viewImageButton = [[UIBarButtonItem alloc] initWithCustomView:vib];
        navItem.rightBarButtonItem = viewImageButton;
    }
    
    return self;
}

//prepare the view by populating the labels with appropriate data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TFSPart *part = self.part;
    
    self.numberLabel.text = part.partNumber;
    self.nameLabel.text = part.partName;
    self.groupLabel.text = part.partGroupType;
    self.typeLabel.text = part.partType;
    self.partImage = [UIImage imageWithCGImage:[[TFSImageStore images] imageForKey:part.imageName].CGImage];
    
    NSMutableString *sizeString = [[NSMutableString alloc] init];
    //initialize the size label by appending size strings, if the number of strings in the array is greater than one
    if([part.partSizes count] > 1) {
        for (int i = 0; i < [part.partSizes count] - 1; i++) {
            //if string in the part sizes array and is not "NA" (not null) and the next element in the array is not "NA".
            if(![part.partSizes[i] isEqualToString:@"NA"] && ![part.partSizes[i+1] isEqualToString:@"NA"]) {
                NSString *appendString = [NSString stringWithFormat:@"%@ X ", part.partSizes[i]];
                [sizeString appendString:appendString];
            } else if(![part.partSizes[i] isEqualToString:@"NA"] && [part.partSizes[i+1] isEqualToString:@"NA"]) {
                //if the string in the part sizes array is not "NA", but the next string is, then append to the string the last size and break the loop, since we assume that the rest of the sizes are not initialized either
                NSString *appendString = [NSString stringWithFormat:@"%@ ", part.partSizes[i]];
                [sizeString appendString:appendString];
                break;
            } else {
                //string at the index was "NA", so break and append nothing to the printed string
                break;
            }
        
        }
    }
    //if the last element in the array is not NA, then append it to the string
    if(![part.partSizes[[part.partSizes count] - 1] isEqualToString:@"NA"]) {
        NSString *appendString = [NSString stringWithFormat:@"%@", part.partSizes[[part.partSizes count] - 1]];
        [sizeString appendString:appendString];
    }
    //self.sizesLabel.numberOfLines = numLines;
    self.sizesLabel.text = sizeString;
    self.classLabel.text = part.partClass;
    
    //numLines = 1;
    //initialize the end types label by appending end type strings
    NSMutableString *endTypeString = [[NSMutableString alloc] init];
    //this loop uses the same logic as the loop above for the sizes, except for the string it prints of course
    if([part.partEndTypes count] > 1) {
        for(int i = 0; i < [part.partEndTypes count] - 1; i++) {
            if(![part.partEndTypes[i] isEqualToString:@"NA"] && ![part.partEndTypes[i+1] isEqualToString:@"NA"]) {
                NSString *appendString = [NSString stringWithFormat:@"%@ & ", part.partEndTypes[i]];
                [endTypeString appendString:appendString];
            } else if(![part.partEndTypes[i] isEqualToString:@"NA"] && [part.partEndTypes[i+1] isEqualToString:@"NA"]) {
                NSString *appendString = [NSString stringWithFormat:@"%@", part.partEndTypes[i]];
                [endTypeString appendString:appendString];
                break;
            } else {
                break;
            }
        }
    }
    
    if(![part.partEndTypes[[part.partEndTypes count] - 1] isEqualToString:@"NA"]) {
        NSString *appendString = [NSString stringWithFormat:@"%@", part.partEndTypes[[part.partEndTypes count] - 1]];
        [endTypeString appendString:appendString];
    }
    
    //self.endTypesLabel.numberOfLines = numLines;
    self.endTypesLabel.text = endTypeString;
    
    //numLines = 1;
    //initialize manufacturer's label in the same manner as above
    NSMutableString *manufacturersString = [[NSMutableString alloc] init];
    if([part.partManufacturers count] > 1) {
        for(int i = 0; i < [part.partManufacturers count] - 1; i++) {
            if(![part.partManufacturers[i] isEqualToString:@"NA - NA"] && ![part.partManufacturers[i+1] isEqualToString:@"NA - NA"]) {
                NSString *appendString = [NSString stringWithFormat:@"%@  ", part.partManufacturers[i]];
                [manufacturersString appendString:appendString];
            } else if(![part.partManufacturers[i] isEqualToString:@"NA - NA"] && [part.partManufacturers[i+1] isEqualToString:@"NA - NA"]) {
                NSString *appendString = [NSString stringWithFormat:@"%@", part.partManufacturers[i]];
                [manufacturersString appendString:appendString];
                break;
            } else {
                break;
            }
        }
    }
    
    if(![part.partManufacturers[[part.partManufacturers count] -1] isEqualToString:@"NA - NA"]) {
        NSString *appendString = [NSString stringWithFormat:@"%@", part.partManufacturers[[part.partManufacturers count] -1]];
        [manufacturersString appendString:appendString];
    }

    //self.manufacturersLabel.numberOfLines = numLines;
    self.manufacturersLabel.text = manufacturersString;
    
    if(!self.backgroundGradient) {
        TFSGradientView *viewGradient = [[TFSGradientView alloc] initWithFrame:self.view.bounds];
        viewGradient.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //dark gray color
        UIColor *firstColor = [[UIColor alloc] initWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.0f alpha:1.0f];
        //lighter gray color
        UIColor *secondColor = [[UIColor alloc] initWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.3f alpha:1.0f];
        viewGradient.layer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor], (id)[secondColor CGColor], (id)[firstColor CGColor], nil];
        self.backgroundGradient = viewGradient;
        [self.view addSubview:self.backgroundGradient];
        [self.view sendSubviewToBack:self.backgroundGradient];
    }
    
}

//When the user taps the View Image button, display the part's associated image in a modal viewController that contains
//a UIImageView
- (void)viewPartImage
{
    //create an view controller which will contain a UIImageView
    UIViewController *imageViewController = [[UIViewController alloc] init];
    
    imageViewController.view.backgroundColor = [UIColor blackColor];
    imageViewController.view.userInteractionEnabled = YES;
    imageViewController.view.frame = self.view.bounds;
    imageViewController.title = [NSString stringWithString:self.part.partNumber];
    
    //Dismissal button
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navBar.backgroundColor = [UIColor clearColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = [NSString stringWithFormat:@"%@", self.part.partNumber];
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleDone target:self action:@selector(dismissImageView:)];
    navItem.rightBarButtonItem = dismissButton;

    
    navBar.items = @[navItem];
    [imageViewController.view addSubview:navBar];
     */
    
    //Image view with a frame that has 90% the height and width of the imageViewController that contains it
    UIImageView *partImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewController.view.frame.size.width * 0.05, imageViewController.view.frame.size.height * 0.05,imageViewController.view.frame.size.width * 0.9, imageViewController.view.frame.size.height * 0.9)];
    partImageView.contentMode = UIViewContentModeScaleAspectFit;
    partImageView.image = self.partImage;
    
    [imageViewController.view addSubview:partImageView];
    
    [self.navigationController pushViewController:imageViewController animated:YES];
    
}

//selector for the button to dismiss the image view
- (void)dismissImageView:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
