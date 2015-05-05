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
#import "TFSGradientView.h"
#import "TFSApplicationLoadingScreen.h"
#import "TFSButton.h"

@interface TFSPartResultsViewController ()

@property (nonatomic, strong, retain) TFSPartDetailsViewController *dvc;

@end

@implementation TFSPartResultsViewController


//Designated Initializer
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        
       //initialize the table's layout
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
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
    
    TFSButton *emailRequestButton;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        emailRequestButton = [[TFSButton alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width * 0.15f, 39) withBackgroundColor:[UIColor redColor]];
    else
        emailRequestButton = [[TFSButton alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width * 0.25f, 39) withBackgroundColor:[UIColor redColor]];
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

//this is changed to return 1 in order to provide spacing in between cells. See below for a more detailed explanation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//get the nth entry of the parts array and display its information as a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create the cell, and set its properties
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        //initialize cell view and set its selection style
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //set the part # label properties
        cell.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.7f;
        cell.textLabel.font = [UIFont fontWithName:@"System" size:30.0];
        cell.textLabel.textColor = [UIColor greenColor];
        //set the part description label properties
        cell.detailTextLabel.textColor = [UIColor colorWithHue:(CGFloat)(208.0/360.0) saturation:0.68f brightness:1.0f alpha:0.8f];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        cell.detailTextLabel.minimumScaleFactor = 0.5f;
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.font = [UIFont fontWithName:@"System" size:22.0];
        //set the part image properties in the cell
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.imageView.layer.cornerRadius = self.view.frame.size.width / 15.0 > 20.0 ? 20.0 : self.view.frame.size.width / 15.0;
        cell.imageView.clipsToBounds = YES;
        [cell.imageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.imageView.layer setBorderWidth:0.5f];
        //set other cell properties such as background color, border color, etc.
        cell.backgroundColor = [UIColor clearColor];
        [cell.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
        [cell.layer setBorderWidth:0.5];
        [cell.layer setCornerRadius:self.view.frame.size.width / 15.0 > 20.0 ? 20.0 : self.view.frame.size.width / 15.0 ];
        [cell.layer setMasksToBounds:YES];

    }
    
    //get the part and its associated image (if any)
    NSArray *parts = [[TFSPartStore parts] allParts];
    TFSPart *part = parts[indexPath.section];
    
    //set the cell's image thumbnail according to the cell's height and one third of the width. If the width is more than 50 points greater than the height, then set the width to the height plus 20 points and vice versa
    UIImage *image = [[TFSImageStore images] imageForKey:part.imageName];
    if(image) {
        CGFloat thumbnailHeight = self.view.frame.size.height / 6.0;
        CGFloat thumbnailWidth = self.view.frame.size.width / 3.0;
        
        if(thumbnailHeight > 120.0)
            thumbnailHeight = 120.0;
        if(thumbnailWidth - thumbnailHeight > 50.0) thumbnailWidth = thumbnailHeight + 50.0;
        else if(thumbnailHeight - thumbnailWidth > 50.0) thumbnailHeight = thumbnailWidth + 50.0;
        
        [part setThumbnailFromImage:image withDimension:CGRectMake(0,0, thumbnailWidth - 10.0, thumbnailHeight - 10.0)];
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
    //setting the table view's gradient doesn't seem to be working currently. Should consider finding more information on how to set up a gradient
    /*
    //here we want to create a mask over the view, so that cells at the end are faded and cells in the middle are not.
    if(!tableMask) {
        NSLog(@"%@", @"Got Here.");
        CGColorRef inner = [[UIColor colorWithWhite:1.0 alpha:0.0] CGColor];
        CGColorRef outer = [[UIColor colorWithWhite:1.0 alpha:1.0] CGColor];
        tableMask.colors = [NSArray arrayWithObjects: (__bridge id)outer, (__bridge id)inner, (__bridge id)inner, (__bridge id)outer, nil];
        //locations of each color in the mask. Inner colors start from 20% in the view to 80% in the view
        tableMask.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:1.0], nil];
        tableMask.bounds = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
        tableMask.anchorPoint = CGPointZero;
    }
    
    UIView *tableBackground = [[UIView alloc] init];
    [tableBackground.layer insertSublayer:tableMask atIndex:0];
    [self.tableView setBackgroundView:tableBackground];
     */
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //if this device is an ipad, set this page's navigation controller objects back to a loading screen
    /*
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.navigationController setViewControllers:[NSArray arrayWithObject:[[TFSApplicationLoadingScreen alloc] init]] animated:YES];
    }
     */
}

//When the user selects a cell, show the details of that part to the user

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFSPartDetailsViewController *dvc = [[TFSPartDetailsViewController alloc] init];
    
    NSArray *parts = [[TFSPartStore parts] allParts];
    TFSPart *selectedPart = parts[indexPath.section];
    //temporary testing for thumbnails
    if(selectedPart.partThumbnailImage) {
        NSLog(@"Still has an image.");
    }
    //give the detail view controller a pointer to the part that was selected
    dvc.part = selectedPart;
    if(!selectedPart) {
        NSLog(@"NULL");
    }
    
    //if this device is an ipad, then set the detail view controller property, otherwise
    //just push to the navigation controller the detail view controller
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.dvc = dvc;
        UINavigationController *dvcNav = self.navigationController.splitViewController.viewControllers.lastObject;
        [dvcNav setViewControllers:[NSArray arrayWithObject:self.dvc] animated:YES];
    } else {
        //push this detail view controller onto the top of the stack
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

//Set the height of each cell such that ~5 cells are visible in the view. This number is currently a constant, so cells in large screens may be too large and cells in small ones may be too small. If it's the case that the height of the table cells actually exceeds 120.0, then just return 120.0 as the height. This will cause the tableview to contain more than 5 cells at one time on larger screens
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.view.frame.size.height / 6.0 <= 120.0) {
        return self.view.frame.size.height / 6.0;
    } else
        return 120.0;
}

//set the cell's gradient layer properties, so the cells are stylized
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    //colors for the normal cell background (unselected) same as the search page
    UIColor *unselectedFirstColor = [UIColor colorWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.36f alpha:0.3f];
    UIColor *unselectedSecondColor = [UIColor colorWithHue:(CGFloat)(240.0/360.0) saturation:0.1f brightness:0.9f alpha:0.3f];
    
    //colors for the selected cell background
    UIColor *selectedFirstColor = [UIColor colorWithHue:(CGFloat)(240.0/360.0) saturation:1.0f brightness:0.5f alpha:0.3f];
    UIColor *selectedSecondColor = [UIColor colorWithHue:(CGFloat)(240.0/360.0) saturation:1.0f brightness:1.0f alpha:0.3f];
    
    
    TFSGradientView *grad = [[TFSGradientView alloc] initWithFrame:cell.bounds];
    grad.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    grad.layer.colors = [NSArray arrayWithObjects:(id)[unselectedFirstColor CGColor], (id)[unselectedSecondColor CGColor], (id)[unselectedFirstColor CGColor], nil];
    [cell setBackgroundView:grad];
    
    TFSGradientView *selectedGrad = [[TFSGradientView alloc] initWithFrame:cell.bounds];
    selectedGrad.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    selectedGrad.layer.colors = [NSArray arrayWithObjects:(id)[selectedFirstColor CGColor], (id)[selectedSecondColor CGColor], (id)[selectedFirstColor CGColor], nil];
    
    [cell setSelectedBackgroundView:selectedGrad];
    
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

/* Set the spacing in between cells by using numberOfSectionsInTableView: instead of numberOfRowsInTableView: . Then use the method tableView:tableView forHeaderInSection which 
    specifies the distance in between each successive cell. Then set the header's color to a 
    clear color so that the background shows and not the arbitrary header. */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[TFSPartStore parts] allParts] count];
}

//set the distance in between each cell. For now use 2% of the table view's height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.height * 0.02;
}

//make the header clear so it doesn't show
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//set the detail view controller associated with this results view controller for ipad uisplitviewcontroller
- (void)setDetailViewController:(id)dvc
{
    self.dvc = (TFSPartDetailsViewController *)dvc;
}




@end
