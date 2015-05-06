//
//  TFSSearchPageViewController.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSSearchPageViewController.h"
#import "TFSPartResultsViewController.h"
#import "TFSServerRequest.h"
#import "TFSPartStore.h"
#import "TFSImageStore.h"
#import "TFSConfigurationData.h"
#import "TFSGradientView.h"
#import "TFSPartDetailsViewController.h"
#import "TFSPart.h"

@interface TFSSearchPageViewController ()


//Dictionary containing arrays for the selection terms of any given "pull down" menu (text field in interface)
@property (strong, nonatomic) NSDictionary *selectionTermsDictionary;

//Picker view for text field "pull down" menus
@property (strong, nonatomic) UIPickerView *selectionTermsPicker;

//terms for the picker view to select from
@property (strong, nonatomic) NSArray *selectionTermsForPicker;

//the view controller for the search results
@property (strong, nonatomic) TFSPartResultsViewController *searchResultsViewController;

//the ui gesture tap recongnizer for the picker view
@property (strong, nonatomic) UITapGestureRecognizer *pickerViewRecognizer;

//the UIAlertView for when the application is getting the part data from the server
@property (strong, nonatomic) UIAlertView *searchDataAlertView;
//to prevent multiple gradient views from being drawin in the background over and over again, retain a reference to the current background gradient
@property (strong, nonatomic) TFSGradientView *backgroundGradient;









@end

@implementation TFSSearchPageViewController

//variables for the picker view to determine selection
static NSString *currentSelection;
//reference to a selectedTextField
static UITextField *selectedTextField = nil;
//bool to prevent multiple rapid presses of search button to send multiple requests and receive too many results
static BOOL enableSearchButtonPress = YES;
static BOOL buttonsSet = NO;



//Designated initializer
- (id)init
{
    self = [super initWithNibName:@"TFSSearchPageViewController" bundle:nil];
    
    if(self) {
        //Further initialization
        NSLog(@"Intializing search page.\n");
        self.view.backgroundColor = [UIColor clearColor];
        
        currentSelection = [[NSString alloc] init];
        
        //initialize the dictionary of terms
        [self initializeSelectionTermsDictionary];

      
        
        
    }
    
    return self;
    
}

//once the view appears, set the title of the page by changing the title shown on the navigation view controller
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"Search Page";
    
    [[TFSPartStore parts] resetParts];
    [[TFSImageStore images] resetImages];
    //set buttons if they haven't been set already (do once)
    if(!buttonsSet) {
        [self.searchButton makeButtonShiny:[UIColor redColor]];
        [self.clearFieldsButton makeButtonShiny:[UIColor redColor]];
        buttonsSet = YES;
    }
    
}

//before search page appears, reset image and part data stores for memory management
- (void)viewWillAppear:(BOOL)animated
{
    
    //set the fonts of the text fields and labels ***SETTING THIS PROGRAMATICALLY IS BUGGED AND INTERFERES WITH THE
    //SETTINGS IN THE NIB FILE***
    /*
    [_generalSearchLabel setFont:[UIFont fontWithName:@"System" size:40.0]];
    [_materialClassLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_manufacturerLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_groupTypeLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_partTypeLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_sizeLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_endTypeLabel setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_generalSearchTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_groupTypeTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_partTypeTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_endTypeOneTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_endTypeThreeTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_endTypeTwoTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_sizeOneTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_sizeTwoTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_sizeThreeTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_materialClassTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_partTypeTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
    [_manufacturerTextField setFont:[UIFont fontWithName:@"System" size:30.0]];
     */
    
    
    
    
    //set other properties of text fields and labels
    _generalSearchLabel.lineBreakMode = NSLineBreakByClipping;
    _generalSearchLabel.numberOfLines = 1;
    _generalSearchLabel.adjustsFontSizeToFitWidth = YES;
    _generalSearchLabel.minimumScaleFactor = 14.0/30.0;
    
    _generalSearchTextField.adjustsFontSizeToFitWidth = YES;
    _generalSearchTextField.minimumFontSize = 14;
    _generalSearchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _groupTypeLabel.lineBreakMode = NSLineBreakByClipping;
    _groupTypeLabel.numberOfLines = 1;
    _groupTypeLabel.adjustsFontSizeToFitWidth = YES;
    _generalSearchLabel.minimumScaleFactor = 14.0/30.0;
    
    _groupTypeTextField.adjustsFontSizeToFitWidth = YES;
    _groupTypeTextField.minimumFontSize = 14;
    
    _partTypeLabel.lineBreakMode = NSLineBreakByClipping;
    _partTypeLabel.numberOfLines = 1;
    _partTypeLabel.adjustsFontSizeToFitWidth = YES;
    _partTypeLabel.minimumScaleFactor = 14.0/30.0;
    
    _partTypeTextField.adjustsFontSizeToFitWidth = YES;
    _partTypeTextField.minimumFontSize = 14;
    
    _materialClassLabel.adjustsFontSizeToFitWidth = YES;
    _materialClassLabel.lineBreakMode = NSLineBreakByClipping;
    _materialClassLabel.minimumScaleFactor = 14.0/30.0;
    _materialClassLabel.numberOfLines = 1;
    
    _materialClassTextField.adjustsFontSizeToFitWidth = YES;
    _materialClassTextField.minimumFontSize = 14;
    
    _sizeLabel.lineBreakMode = NSLineBreakByClipping;
    _sizeLabel.adjustsFontSizeToFitWidth = YES;
    _sizeLabel.minimumScaleFactor = 14.0/30.0;
    _sizeLabel.numberOfLines = 1;
    
    _sizeOneTextField.adjustsFontSizeToFitWidth = YES;
    _sizeTwoTextField.adjustsFontSizeToFitWidth = YES;
    _sizeThreeTextField.adjustsFontSizeToFitWidth = YES;
    _sizeOneTextField.minimumFontSize = 7;
    _sizeTwoTextField.minimumFontSize = 7;
    _sizeThreeTextField.minimumFontSize = 7;
    
    _endTypeLabel.adjustsFontSizeToFitWidth = YES;
    _endTypeLabel.minimumScaleFactor = 14.0/30.0;
    _endTypeLabel.numberOfLines = 1;
    _endTypeLabel.lineBreakMode = NSLineBreakByClipping;
    
    _endTypeOneTextField.adjustsFontSizeToFitWidth = YES;
    _endTypeTwoTextField.adjustsFontSizeToFitWidth = YES;
    _endTypeThreeTextField.adjustsFontSizeToFitWidth = YES;
    
    _endTypeOneTextField.minimumFontSize = 14;
    _endTypeTwoTextField.minimumFontSize = 14;
    _endTypeThreeTextField.minimumFontSize = 14;
    
    _manufacturerLabel.lineBreakMode = NSLineBreakByClipping;
    _manufacturerLabel.minimumScaleFactor = 14.0/30.0;
    _manufacturerLabel.adjustsFontSizeToFitWidth = YES;
    _manufacturerLabel.numberOfLines = 1;
    
    _manufacturerTextField.minimumFontSize = 14;
    _manufacturerTextField.adjustsFontSizeToFitWidth = YES;
    
    //set the view's gradient color for improved appearance. NOTE: using CGGradient over
    //CAGradientLayer produces a better image (less noticeable "stepping") but has a tremendous
    //effect on performance, so I'm using CAGradientLayer here.
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
    
    //NSLog(@"Number of subviews: %@", [NSNumber numberWithInt:[[self.view subviews] count]]);
    
    
    
}

//when the user selects a textfield, initialize the picker view with the appropriate terms, and set the user's selection
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //prepare a toolbar for the picker view
    UIToolbar *pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    pickerDoneButtonView.barStyle = UIBarStyleBlackOpaque;
    //prepare the done button for that toolbar which will dismiss the picker upon pressing
    TFSButton *doneButton = [[TFSButton alloc] initWithFrame:CGRectMake(0,0, pickerDoneButtonView.frame.size.width/3.0, 33)withBackgroundColor:[UIColor redColor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    doneButton.titleLabel.numberOfLines = 1;
    doneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    doneButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    pickerDoneButtonView.items = [[NSArray alloc] initWithObjects:barButtonItem, nil];
    
    
    //prepare the selection terms picker
    self.selectionTermsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.selectionTermsPicker.delegate = self;
    self.selectionTermsPicker.backgroundColor = [UIColor whiteColor];
    self.selectionTermsPicker.showsSelectionIndicator = YES;
    
    //prepare selection Terms Picker's  gesture recognizer for its view
    selectedTextField = textField;
    
    
    if([textField isEqual:self.groupTypeTextField]) {
        //reversed
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"groupType"] reverseObjectEnumerator] allObjects];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        //currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.partTypeTextField]) {
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"partType"] reverseObjectEnumerator] allObjects];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        //currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.materialClassTextField]) {
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"materialClass"] reverseObjectEnumerator] allObjects];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        //currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.sizeOneTextField] || [textField isEqual:self.sizeTwoTextField] || [textField isEqual:self.sizeThreeTextField]) {
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"size"] reverseObjectEnumerator] allObjects];
        //currentSelection = self.selectionTermsForPicker[0];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
    } else if([textField isEqual:self.endTypeOneTextField] || [textField isEqual:self.endTypeTwoTextField] || [textField isEqual:self.endTypeThreeTextField]){
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"endType"] reverseObjectEnumerator] allObjects];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        //currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.manufacturerTextField]) {
        self.selectionTermsForPicker = [[self.selectionTermsDictionary[@"manufacturer"] reverseObjectEnumerator] allObjects];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        //currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.generalSearchTextField]) {
        //selected the general search, this is a normal textfield without a picker, so do not set the inputview to this picker
        self.selectionTermsPicker.delegate = nil;
        self.selectionTermsPicker = nil;
        currentSelection = nil;
    } else {
        return NO;
        self.selectionTermsPicker = nil;
        selectedTextField = nil;
        NSLog(@"Warning: Error for a selected textfield in textFieldShouldBeginEditing:");
    }
    
    if(self.selectionTermsPicker) {
        //put the selection for the picker at the bottom
        [self.selectionTermsPicker selectRow:[self.selectionTermsForPicker count] - 1 inComponent:0 animated:NO];
    }
    
    
    
    return YES;
}

//when the text field is no longer editing, reset the picker view and picker view selection terms
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field ended editing");
    //if the text field is a picker text field then current selection won't be nil, otherwise the text field is the general
    //text field so its text is already set
    if(currentSelection) {
        selectedTextField.text = currentSelection;
        self.selectionTermsPicker = nil;
        currentSelection = nil;
        selectedTextField = nil;
    }
    //if there's a gesture recognizer, remove it so other text fields may be selected
    /*
    for(UIGestureRecognizer *rec in [self.view gestureRecognizers])
        [self.view removeGestureRecognizer:rec];
     */

}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    currentSelection = nil;
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize text field delegates to self
    self.generalSearchTextField.delegate = self;
    self.groupTypeTextField.delegate = self;
    self.partTypeTextField.delegate = self;
    self.materialClassTextField.delegate = self;
    self.sizeOneTextField.delegate = self;
    self.sizeTwoTextField.delegate = self;
    self.endTypeOneTextField.delegate = self;
    self.endTypeTwoTextField.delegate = self;
    self.manufacturerTextField.delegate = self;
    self.sizeThreeTextField.delegate = self;
    self.endTypeThreeTextField.delegate = self;
    
    //set general search text field settings
    self.generalSearchTextField.returnKeyType = UIReturnKeyDone;
    self.generalSearchTextField.autocorrectionType = NO;
    self.generalSearchTextField.enablesReturnKeyAutomatically = NO;
    self.generalSearchTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.generalSearchTextField.secureTextEntry = NO;
    
    //set a gesture recognizer for a single tap in a picker view
    /*
    self.pickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.pickerViewRecognizer.cancelsTouchesInView = NO;
    self.pickerViewRecognizer.numberOfTapsRequired = 1;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Initializes the dictionary of selection terms for each textfield
- (void)initializeSelectionTermsDictionary
{
    //Arrays of type terms and size selections
    NSMutableArray *groupTypes = [[NSMutableArray alloc] init];
    [groupTypes addObject:@""];
    [groupTypes addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"group"]];
    NSMutableArray *partTypes = [[NSMutableArray alloc] init];
    [partTypes addObject:@""];
    [partTypes addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"part"]];
    NSMutableArray *materialClasses = [[NSMutableArray alloc] init];
    [materialClasses addObject:@""];
    [materialClasses addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"class"]];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    [sizes addObject:@""];
    [sizes addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"size"]];
    NSMutableArray *endTypes = [[NSMutableArray alloc] init];
    [endTypes addObject:@""];
    [endTypes addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"end"]];
    NSMutableArray *manufacturerTypes = [[NSMutableArray alloc] init];
    [manufacturerTypes addObject:@""];
    [manufacturerTypes addObjectsFromArray:[[TFSConfigurationData configDictionary] getConfigDataForKey:@"mfg"]];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:groupTypes,partTypes,materialClasses,sizes,endTypes,manufacturerTypes, nil];
    
    NSArray *keys = @[@"groupType", @"partType", @"materialClass", @"size", @"endType", @"manufacturer"];
    
    //initialize the dictionary of terms based on the above arrays
   self.selectionTermsDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    //clear memory in the configuration data object
    [[TFSConfigurationData configDictionary] resetConfigData];
    
}

//picker related delegate methods
//# of columns of data is just 1, since this behaves like a pull-down menu
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//# of rows of data is of course the # of elements for the given key within the dictionary
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.selectionTermsForPicker) {
        return [self.selectionTermsForPicker count];
    }
    return 0;
}

//the data to return for the row that's being passed in to this method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.selectionTermsForPicker) {
        return self.selectionTermsForPicker[row];
    }
    
    return nil;
}


//if the given picker view selects a row, chage its associated textfield to that row's contents
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentSelection = [NSString stringWithString:self.selectionTermsForPicker[row]];
}

//the general search text field's return method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.generalSearchTextField]) {
        NSLog(@"User entered: %@", textField.text);
        [[self view] endEditing:YES];
        return YES;
    }
    
    return NO;
}

//Button actions: methods that are called when buttons on screen are pressed

//button action for the search button. When the search button is pressed create the request string and request object, then push the results table view onto the navigation controller view.
- (IBAction)searchButtonPressed:(id)sender
{
    
    
    if([self textFieldsNotEmpty] && enableSearchButtonPress) {
    //first, initialize the request string with the given text fields
    //string is of format [token]:[general text field]:[sizes]:[group]:[part type]:[material class]:[end types]:[manufacturer]
        enableSearchButtonPress = NO;
        NSString *tokenString = @"0000000000";
        NSString *generalSearch = self.generalSearchTextField.text;
        NSString *sizes = [NSString stringWithFormat:@"%@|%@|%@",self.sizeOneTextField.text,self.sizeTwoTextField.text,self.sizeThreeTextField.text];
        sizes = [self removeIllegalCharacters:sizes];
        NSString *group = self.groupTypeTextField.text;
        NSString *partType = self.partTypeTextField.text;
        NSString *materialClass = self.materialClassTextField.text;
        NSString *endTypes = [NSString stringWithFormat:@"%@|%@|%@", self.endTypeOneTextField.text, self.endTypeTwoTextField.text, self.endTypeThreeTextField.text];
        NSString *manufacturer = self.manufacturerTextField.text;
        self.searchRequestString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@",tokenString,generalSearch,sizes,group,partType,materialClass,endTypes,manufacturer];
        //now send the request and get the json document, here I am using the NSNotificationCenter to allow the dataRequest
        //to signal the search page when the data has finished loading. When it has loaded, I then call upon the selector
        //presentResultsViewController to push to the navigation controller the results view
        TFSServerRequest *dataRequest = [[TFSServerRequest alloc] initWithRequestString:self.searchRequestString withRequestType:TFSServerPartDataRequest];
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentResultsViewController) name:@"Part Data Received" object:dataRequest];
        
        if(self.searchDataAlertView)self.searchDataAlertView = nil;
    
        self.searchDataAlertView = [[UIAlertView alloc] initWithTitle:@"Searching..." message:@"Searching for part data..." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        //initialize the frame of the alert view
        
        CGFloat alertViewSizeX = self.view.frame.size.width / 2.0;
        CGFloat alertViewSizeY = self.view.frame.size.height / 2.0;
        self.searchDataAlertView.frame = CGRectMake(self.view.frame.size.width / 4.0, self.view.frame.size.height / 4.0, alertViewSizeX, alertViewSizeY);
        
        [self.searchDataAlertView show];

        [dataRequest sendRequest];
    } else if(![self textFieldsNotEmpty]){
        //if the user didn't enter anything, present an alert view that informs them they need to enter at least one search term to continue
        [self enterSearchTermAlert];
    } else {
        ;
    }
    
}

//method to determine if all the text fields are empty
- (BOOL)textFieldsNotEmpty
{
    return (self.generalSearchTextField.text.length > 0 || self.groupTypeTextField.text.length > 0 || self.partTypeTextField.text.length > 0 || self.materialClassTextField.text.length > 0 || self.sizeOneTextField.text.length > 0 || self.sizeTwoTextField.text.length > 0 || self.sizeThreeTextField.text.length > 0 || self.endTypeOneTextField.text.length > 0 || self.endTypeTwoTextField.text.length > 0 || self.endTypeThreeTextField.text.length > 0 || self.manufacturerTextField.text.length > 0);
}


//method to display an alert view informing the user that they need to enter at least one search term for the search
- (void)enterSearchTermAlert
{
    if(self.searchDataAlertView) self.searchDataAlertView = nil;
    self.searchDataAlertView = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Please enter at least one term" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    //set the alertview's frame to be half the width of the this view and half of the height of this view, and put it in the center of the view
    CGFloat alertViewSizeX = self.view.frame.size.width / 2.0;
    CGFloat alertViewSizeY = self.view.frame.size.height / 2.0;
    self.searchDataAlertView.frame = CGRectMake(self.view.frame.size.width / 4.0, self.view.frame.size.height / 4.0, alertViewSizeX, alertViewSizeY);
    
    [self.searchDataAlertView show];
    
}

//selector for pushing the results view onto the navigation controller
- (void)presentResultsViewController
{
    
    
    //get the search text string from the text fields. if there is not general search text field entered, then the string to show on the top of the results view will be "Custom Search"
    self.searchRequestString = [[NSString alloc] initWithFormat:@"Search Results Displayed For: %@",self.generalSearchTextField.text.length > 0 ? self.generalSearchTextField.text : @"Custom Search"];
    //create a part results view controller, and set its search text property
    self.searchResultsViewController = [[TFSPartResultsViewController alloc] init];
    //set the search results view controller's navigation item label (at the top of the screen) and the string that the view controller sends as an email (template)
    [self.searchResultsViewController setNavigationItemLabel:self.searchRequestString];
    //Initialize the size field string for email request
    NSString *sizeField = [NSString stringWithFormat:@"\tSize 1: %@\n\tSize 2: %@\n\tSize 3:%@\n", self.sizeOneTextField.text ? self.sizeOneTextField.text : @"NA", self.sizeTwoTextField.text ? self.sizeTwoTextField.text : @"NA", self.sizeThreeTextField.text ? self.sizeThreeTextField.text : @"NA"];
    //Initialize the end type field string for email request
    NSString *endTypeField = [NSString stringWithFormat:@"\tEnd Type 1: %@\n\tEnd Type 2: %@\n\tEnd Type 3:%@\n", self.endTypeOneTextField.text ? self.endTypeOneTextField.text : @"NA", self.endTypeTwoTextField.text ? self.endTypeTwoTextField.text : @"NA", self.endTypeThreeTextField.text ? self.endTypeThreeTextField.text : @"NA"];
    self.searchResultsViewController.emailRequestString = [NSString stringWithFormat:@"----BEGIN PART REQUEST----\nDESCRIPTION: %@\nGROUP: %@\nPART TYPE: %@\nMATERIAL: %@\nSIZES: \n%@\nEND TYPES: \n%@\nMANUFACTURER: %@\n---- END PART REQUEST ----\n",self.generalSearchTextField.text ? self.generalSearchTextField.text : @"NA",self.groupTypeTextField.text ? self.groupTypeTextField.text : @"NA", self.partTypeTextField.text ? self.partTypeTextField.text : @"NA", self.materialClassTextField.text ? self.materialClassTextField.text : @"NA", sizeField, endTypeField, self.manufacturerTextField.text ? self.manufacturerTextField.text : @"NA"];
    
    //dismiss the alert view for searching
    [self.searchDataAlertView dismissWithClickedButtonIndex:-1 animated:YES];
    //push search results view controller onto the navigation controller of this view
    UINavigationController *navigationController = [self navigationController];
    if(navigationController)
    {
        [navigationController pushViewController:self.searchResultsViewController animated:YES];
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            TFSPartDetailsViewController *dvc = [[TFSPartDetailsViewController alloc] init];
            dvc.part = [[TFSPart alloc] initWithFields:@{}];
            [self.searchResultsViewController setDetailViewController:dvc];
        }
    }
    
    self.searchRequestString = nil;
    enableSearchButtonPress = YES;
    
}

-(NSString *)removeIllegalCharacters:(NSString *)target
{
    NSString *output = target;
    output = [output stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@" " withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@"&" withString:@""];
    
    return output;
}

//button action for the clear fields button. This button simply resets each text field
- (IBAction)clearFieldsButtonPressed:(id)sender
{
    NSLog(@"Clearing text fields");
    
    //reset each field's text to nil
    self.generalSearchTextField.text = nil;
    self.groupTypeTextField.text = nil;
    self.materialClassTextField.text = nil;
    self.partTypeTextField.text = nil;
    self.sizeOneTextField.text = nil;
    self.sizeTwoTextField.text = nil;
    self.endTypeOneTextField.text = nil;
    self.endTypeTwoTextField.text = nil;
    self.endTypeThreeTextField.text = nil;
    self.manufacturerTextField.text = nil;
    self.sizeThreeTextField.text = nil;
    self.sizeTwoTextField.text = nil;
    self.sizeThreeTextField.text = nil;
    
    //show the changes
    [self.view setNeedsDisplay];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//button action for when the picker view is tapped for a given selection
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"Recognized a tap in a picker.");
    CGPoint pointOfTap = [sender locationInView:sender.view];
    
    CGRect frame = self.selectionTermsPicker.frame;
    CGRect selectorFrame = CGRectInset(frame, 0.0, self.selectionTermsPicker.bounds.size.height * 0.85 / 2.0);
    if(CGRectContainsPoint(selectorFrame, pointOfTap)) {
        [self.view endEditing:YES];
    }
    
}
//dismiss the picker view when the done button is pressed
- (void)doneButtonPressed
{
    NSLog(@"Done button was pressed.");
    [self.view endEditing:YES];
}

//picker view delegate method to size the picker view's item font size with respect to the width of the view
/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *itemLabel = (UILabel *)view;
    if(!itemLabel) {
        //set the item's properties as it has not yet been initialized
        itemLabel = [[UILabel alloc] init];
        itemLabel.minimumScaleFactor = 0.7f;
        itemLabel.numberOfLines = 1;
        itemLabel.lineBreakMode = NSLineBreakByClipping;
        itemLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return itemLabel;
} */
                                                                                     
                                                                                    

@end
