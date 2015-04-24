//
//  TFSSearchPageViewController.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSSearchPageViewController.h"
#import "TFSPartResultsViewController.h"
#import "TFSPartDataRequest.h"
#import "TFSPartStore.h"
#import "TFSImageStore.h"

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







@end

@implementation TFSSearchPageViewController

//variables for the picker view to determine selection
static NSString *currentSelection;
//reference to a selectedTextField
static UITextField *selectedTextField = nil;




//Designated initializer
- (id)init
{
    self = [super initWithNibName:@"TFSSearchPageViewController" bundle:nil];
    
    if(self) {
        //Further initialization
        NSLog(@"Intializing search page.\n");
        self.view.backgroundColor = [UIColor blackColor];
        
        currentSelection = [[NSString alloc] init];
        
      
        
        
    }
    
    return self;
    
}

//once the view appears, set the title of the page by changing the title shown on the navigation view controller
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"Search Page";
    
}

//before search page appears, reset image and part data stores for memory management
- (void)viewWillAppear:(BOOL)animated
{
    [[TFSPartStore parts] resetParts];
    [[TFSImageStore images] resetImages];
    
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
    
}

//when the user selects a textfield, initialize the picker view with the appropriate terms, and set the user's selection
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //prepare a toolbar for the picker view
    UIToolbar *pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    pickerDoneButtonView.barStyle = UIBarStyleBlackOpaque;
    //prepare the done button for that toolbar which will dismiss the picker upon pressing
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, pickerDoneButtonView.frame.size.width/3.0, 33)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    doneButton.titleLabel.numberOfLines = 1;
    doneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    doneButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    pickerDoneButtonView.items = [[NSArray alloc] initWithObjects:barButtonItem, nil];
    
    
    //prepare the selection terms picker
    self.selectionTermsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3.0)];
    self.selectionTermsPicker.delegate = self;
    self.selectionTermsPicker.backgroundColor = [UIColor whiteColor];
    self.selectionTermsPicker.showsSelectionIndicator = YES;
    [self.selectionTermsPicker addGestureRecognizer:self.pickerViewRecognizer];
    
    //prepare selection Terms Picker's  gesture recognizer for its view
    selectedTextField = textField;
    
    
    if([textField isEqual:self.groupTypeTextField]) {
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"groupType"];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.partTypeTextField]) {
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"partType"];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.materialClassTextField]) {
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"materialClass"];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.sizeOneTextField] || [textField isEqual:self.sizeTwoTextField] || [textField isEqual:self.sizeThreeTextField]) {
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"size"];
        currentSelection = self.selectionTermsForPicker[0];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
    } else if([textField isEqual:self.endTypeOneTextField] || [textField isEqual:self.endTypeTwoTextField] || [textField isEqual:self.endTypeThreeTextField]){
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"endType"];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        currentSelection = self.selectionTermsForPicker[0];
    } else if([textField isEqual:self.manufacturerTextField]) {
        self.selectionTermsForPicker = self.selectionTermsDictionary[@"manufacturer"];
        textField.inputView = self.selectionTermsPicker;
        textField.inputAccessoryView = pickerDoneButtonView;
        currentSelection = self.selectionTermsForPicker[0];
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
    for(UIGestureRecognizer *rec in [self.view gestureRecognizers])
        [self.view removeGestureRecognizer:rec];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //initialize the dictionary of terms
    [self initializeSelectionTermsDictionary];
    
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
    self.generalSearchTextField.enablesReturnKeyAutomatically = YES;
    self.generalSearchTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.generalSearchTextField.secureTextEntry = NO;
    
    //set a gesture recognizer for a single tap in a picker view
    self.pickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.pickerViewRecognizer.cancelsTouchesInView = NO;
    self.pickerViewRecognizer.numberOfTapsRequired = 1;
    
    
    
    
    
    
    
   

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
    NSArray *groupTypes = @[@"", @"Mechanical Purchased Part", @"Supports & Support Hardware Purchased Part", @"Piping Hardware & Gaskets", @"Equipment, Valves, Specials, Engineered Items"];
    NSArray *partTypes = @[@"", @"Connector", @"Elbow, 90", @"Tee, Equal", @"Tube, Seamless", @"Elbow, 90 Long Radius", @"Cap", @"Adapter", @"Adapter, Male", @"Adapter, Female", @"Coupling"];
    NSArray *materialClasses = @[@"", @"PFA", @"Polyethylene, 150 lb", @"Carbon Steel, PTFE Lined 150 lb", @"Polypropylene, 150 lb", @"PVC Sch 40 Clear", @"PVC Sch 80", @"PVDF HP, PN 16", @"SS 304LSch 10", @"SS 316L Sch 10", @"SS 316L 10 Ra Max/EP"];
    NSArray *sizes = @[@"", @"0.25\" (1/4)", @"0.5\" (1/2)", @"0.75\"(3/4)", @"1.25\"(1 1/4)", @"1.5\" (1 1/2)", @"2\"", @"4\"", @"12\"", @"20 mm", @"110 mm"];
    NSArray *endTypes = @[@"", @"MPT", @"Flare", @"Socket Fusion", @"Butt Fusion", @"Spigot", @"Socketweld", @"Flanged, Raised Face", @"Flanged, Flat Face", @"Socket Cement", @"FPT"];
    NSArray *manufacturerTypes = @[@"", @"George Fischer", @"Charlotte", @"Allied EG", @"Asahi", @"Valex", @"Cardinal UHP", @"Swagelok"];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:groupTypes,partTypes,materialClasses,sizes,endTypes,manufacturerTypes, nil];
    
    NSArray *keys = @[@"groupType", @"partType", @"materialClass", @"size", @"endType", @"manufacturer"];
    
    //initialize the dictionary of terms based on the above arrays
    self.selectionTermsDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
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
    
    BOOL dataLoaded = NO;
    //first, initialize the request string with the given text fields
    //string is of format [token]:[general text field]:[sizes]:[group]:[part type]:[material class]:[end types]:[manufacturer]
    NSString *tokenString = @"0000000000";
    NSString *generalSearch = self.generalSearchTextField.text;
    NSString *sizes = [NSString stringWithFormat:@"%@-%@-%@",self.sizeOneTextField.text,self.sizeTwoTextField.text,self.sizeThreeTextField.text];
    sizes = [self removeIllegalCharacters:sizes];
    NSString *group = self.groupTypeTextField.text;
    NSString *partType = self.partTypeTextField.text;
    NSString *materialClass = self.materialClassTextField.text;
    NSString *endTypes = [NSString stringWithFormat:@"%@-%@-%@", self.endTypeOneTextField.text, self.endTypeTwoTextField.text, self.endTypeThreeTextField.text];
    NSString *manufacturer = self.manufacturerTextField.text;
    self.searchRequestString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@",tokenString,generalSearch,sizes,group,partType,materialClass,endTypes,manufacturer];
    
    //now send the request and get the json document, passing a reference to the table of results so async_dispatch can
    //refresh the table's view when data is loaded
    TFSPartDataRequest *dataRequest = [[TFSPartDataRequest alloc] initWithRequestString:self.searchRequestString withSignal:(BOOL *)&dataLoaded];
    [dataRequest sendRequest];
    
    //waiting for dataRequest to finish ***TEMPORARY***
    while(!dataLoaded) ;
    
    //get the search text string from the text fields
    self.searchRequestString = [[NSString alloc] initWithFormat:@"Search Results For:\n%@",self.generalSearchTextField.text];
    //create a part results view controller, and set its search text property
    self.searchResultsViewController = [[TFSPartResultsViewController alloc] init];
    [self.searchResultsViewController setNavigationItemLabel:self.searchRequestString];
    
    //push this view controller onto the navigation controller of this view
    UINavigationController *navigationController = [self navigationController];
    if(navigationController) {
        [navigationController pushViewController:self.searchResultsViewController animated:YES];
    }
    
    self.searchRequestString = nil;
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
