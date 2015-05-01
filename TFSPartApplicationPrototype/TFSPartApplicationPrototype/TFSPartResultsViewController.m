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
        /*
        TFSImageStore *images = [TFSImageStore images];
        [images setImageWithImageName:@"SS-4-VCR-A1S-400" forKey:@"image1"];
        [images setImageWithImageName:@"SS-8-VCR-3-8TA"   forKey:@"image2"];
        [images setImageWithImageName:@"SS-8-VCR-6-810" forKey:@"image3"];
        [images setImageWithImageName:@"SS-8-VCR-61" forKey:@"image4"];
        [images setImageWithImageName:@"SS-8-VCR-CP" forKey:@"image5"];
        [images setImageWithImageName:@"SS-8-WVCR-1-8" forKey:@"image6"];
        [images setImageWithImageName:@"SS-8-WVCR-6-810" forKey:@"image7"];
        [images setImageWithImageName:@"SS-8-WVCR-7-8" forKey:@"image8"];
         */
        
        //generate 2000 parts for now.
        //[self generateParts:2000];
        
        //set colors for views
        [self.view setBackgroundColor:[UIColor blackColor]];
        self.emailRequestString = [[NSString alloc] init];
        
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width / 3.0, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%d %@",(unsigned int)[[[TFSPartStore parts] allParts] count], labelText];
    label.textColor = [UIColor blackColor];
    navItem.titleView = label;
    
    UIButton *emailRequestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailRequestButton.frame = CGRectMake(0, 0, 100, 32);
    [emailRequestButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [emailRequestButton setTitle:@"Request" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] init];
    [rightBarButton setCustomView:emailRequestButton];
    navItem.rightBarButtonItem=rightBarButton;
    
}

//send email to cah103120@utdallas.edu of part details for testing
- (void)sendEmail
{
    //email subject
    NSString *emailTitle = @"Test email for part application";
    //Email content/body
    NSString *message = [NSString stringWithFormat:@"%@\nComments: \n", self.emailRequestString];
    //To addresses
    NSArray *toAddress = @[@"cah103120@utdallas.edu", @"kevins@resultsgroup.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:message isHTML:NO];
    [mc setToRecipients:toAddress];
    
    
    //show on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
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
        cell.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.7f;
        cell.textLabel.font = [UIFont fontWithName:@"System" size:30.0];
        cell.textLabel.textColor = [UIColor greenColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        cell.detailTextLabel.minimumScaleFactor = 0.5f;
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.font = [UIFont fontWithName:@"System" size:22.0];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.layer.borderColor = (__bridge CGColorRef)[UIColor whiteColor];
        cell.layer.backgroundColor = (__bridge CGColorRef)[UIColor blackColor];
    }
    
    //get the part and its associated image (if any)
    NSArray *parts = [[TFSPartStore parts] allParts];
    TFSPart *part = parts[indexPath.row];
    
    //set the cell's image thumbnail according to the cell's height and one third of the width. If the width is more than 50 points greater than the height, then set the width to the height plus 20 points and vice versa
    UIImage *image = [[TFSImageStore images] imageForKey:part.imageName];
    if(image) {
        CGFloat thumbnailHeight = self.view.frame.size.height / 6.0;
        CGFloat thumbnailWidth = self.view.frame.size.width / 3.0;
        
        if(thumbnailHeight > 120.0)
            thumbnailHeight = 120.0;
        if(thumbnailWidth - thumbnailHeight > 50.0) thumbnailWidth = thumbnailHeight + 50.0;
        else if(thumbnailHeight - thumbnailWidth > 50.0) thumbnailHeight = thumbnailWidth + 50.0;
        
        [part setThumbnailFromImage:image withDimension:CGRectMake(0,0, thumbnailWidth - 5.0, thumbnailHeight - 5.0)];
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

//Set the height of each cell such that ~6 cells are visible in the view. This number is currently a constant, so cells in large screens may be too large and cells in small ones may be too small. If it's the case that the height of the table cells actually exceeds 120.0, then just return 120.0 as the height. This will cause the tableview to contain more than 10 cells at one time on larger screens
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.view.frame.size.height / 6.0 <= 120.0) {
        return self.view.frame.size.height / 6.0;
    } else
        return 120.0;
}

//EMAIL SEND DELEGATE METHODS
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
            
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}




@end
