//
//  TFSPartResultsViewController.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSPartResultsViewController.h"
#import "TFSPartStore.h"
#import "TFSPart.h"
#import "TFSPartDetailsViewController.h"
#import "TFSImageStore.h"

@interface TFSPartResultsViewController ()

@end

@implementation TFSPartResultsViewController 

//Designated Initializer
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        
        //set the images in this method for the image store for demonstration purposes ***TEMPORARY***
        
        TFSImageStore *images = [TFSImageStore images];
        [images setImageWithImageName:@"SS-4-VCR-A1S-400" forKey:@"image1"];
        [images setImageWithImageName:@"SS-8-VCR-3-8TA"   forKey:@"image2"];
        [images setImageWithImageName:@"SS-8-VCR-6-810" forKey:@"image3"];
        [images setImageWithImageName:@"SS-8-VCR-61" forKey:@"image4"];
        [images setImageWithImageName:@"SS-8-VCR-CP" forKey:@"image5"];
        [images setImageWithImageName:@"SS-8-WVCR-1-8" forKey:@"image6"];
        [images setImageWithImageName:@"SS-8-WVCR-6-810" forKey:@"image7"];
        [images setImageWithImageName:@"SS-8-WVCR-7-8" forKey:@"image8"];
        
        //generate 2000 parts for now.
        //[self generateParts:2000];
        
        //set colors for views
        [self.view setBackgroundColor:[UIColor darkGrayColor]];
        
    }
    
    return self;
}

//method for intial testing
- (void)generateParts:(NSInteger)numParts
{
    if([[[TFSPartStore parts] allParts] count] != 0)
        [[TFSPartStore parts] resetParts];
    
    for(int i = 0; i < numParts; i++) {
        [[TFSPartStore parts] addPart:[TFSPart randomPart]];
    }
}

//create a navigation item label at the top of the screen, in the middle of the navigation bar
- (void)setNavigationItemLabel:(NSString *)labelText
{
    //The top of the screen should be the searched string, so initialize a label with the appropriate properties and then set it as the titleview of the navigation item
    UINavigationItem *navItem = self.navigationItem;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%d %@",(unsigned int)[[[TFSPartStore parts] allParts] count], labelText];
    label.textColor = [UIColor whiteColor];
    navItem.titleView = label;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

//get the number of rows in a section. There will probably only ever be one section in the table view, so this
//just returns the # of parts of a search result
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TFSPartStore parts] allParts] count];
}

//get the nth entry of the parts array and display its information as a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create the cell, and set its properties
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.layer.borderColor = (__bridge CGColorRef)[UIColor whiteColor];
    }
    
    //get the part and its associated image (if any)
    NSArray *parts = [[TFSPartStore parts] allParts];
    TFSPart *part = parts[indexPath.row];
    
    UIImage *image = [[TFSImageStore images] imageForKey:part.imageName];
    if(image) {
        [part setThumbnailFromImage:image];
    }
    
    //configure cell with part number, name, and image if any
    cell.textLabel.text = part.partNumber;
    cell.detailTextLabel.text = part.partName;
    cell.imageView.image = part.partThumbnailImage;
    
    return cell;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//when this view is about to go away, reset self and reset the part store and image store
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//When the user selects a cell, show the details of that part to the user

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFSPartDetailsViewController *dvc = [[TFSPartDetailsViewController alloc] init];
    
    NSArray *parts = [[TFSPartStore parts] allParts];
    TFSPart *selectedPart = parts[indexPath.row];
    //temporary testing for thumbnails
    if(selectedPart.partThumbnailImage) {
        NSLog(@"Still has an image.");
    }
    //give the detail view controller a pointer to the part that was selected
    dvc.part = selectedPart;
    if(!selectedPart) {
        NSLog(@"NULL");
    }
    
    
    //push this detail view controller onto the top of the stack
    [self.navigationController pushViewController:dvc animated:YES];
}

//Set the height of each cell. This is a constant value
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}




@end
