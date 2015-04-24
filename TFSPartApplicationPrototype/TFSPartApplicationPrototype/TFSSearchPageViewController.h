//
//  TFSSearchPageViewController.h
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/31/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import <UIKit/UIKit.h>

@interface TFSSearchPageViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource,UIGestureRecognizerDelegate>


//Interface Properties
@property (weak, nonatomic) IBOutlet UITextField *generalSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *materialClassTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTypeOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTypeTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *clearFieldsButton;
@property (weak, nonatomic) IBOutlet UITextField *manufacturerTextField;
@property (weak, nonatomic) IBOutlet UITextField *sizeThreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTypeThreeTextField;
@property (weak, nonatomic) IBOutlet UILabel *generalSearchLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *partTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;

//The formatted string for search requests
@property (strong, nonatomic) NSString *searchRequestString;

//The selectable text field values for the pull down menus. These are arrays which populate the selectionTermsDictionary.
@property (nonatomic, copy) NSArray *groupTypes;
@property (nonatomic, copy) NSArray *partTypes;
@property (nonatomic, copy) NSArray *materialClasses;
@property (nonatomic, copy) NSArray *sizes;
@property (nonatomic, copy) NSArray *manufacturers;
@property (nonatomic, copy) NSArray *endTypes;





@end
