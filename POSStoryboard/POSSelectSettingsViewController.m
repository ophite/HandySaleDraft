//
//  POSSelectSettingsViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/31/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSSelectSettingsViewController.h"


@interface POSSelectSettingsViewController ()

@end


@implementation POSSelectSettingsViewController


@synthesize settingName = _settingName;
@synthesize settingValue = _settingValue;
@synthesize picker = _picker;
@synthesize pickerDict = _pickerDict;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {

    [super viewDidLoad];

    // gui
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    NSArray *keys = [self.pickerDict allKeys];
    
    int row = [keys containsObject:self.settingValue]? [keys indexOfObject:self.settingValue]: -1;
    if (row < 0) {

        row = 0;
    }
    
    [self.picker selectRow: row
               inComponent: 0
                  animated: YES];
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    if (![parent isEqual:self.parentViewController]) {
       
        [self.parentViewController viewDidLoad];
    }
}


#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return  1;
}


- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    
    return [self.pickerDict count];
}


- (NSString *)pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component {
    
    NSArray *keys = [self.pickerDict allKeys];
    
    return [self.pickerDict valueForKey:[keys objectAtIndex:row]];
}


#pragma mark - Actions

- (IBAction)onSelect:(id)sender {

    NSInteger row = [self.picker selectedRowInComponent:0];
    NSString *newValue = [[self.pickerDict allKeys] objectAtIndex:row];
    
    POSSetting *settingObject = [POSSetting getSetting: objectsHelperInstance.dataSet.settings
                                              withName: self.settingName];
    if (settingObject) {
        
        if (![settingObject.value isEqualToString:newValue]) {
            
            [objectsHelperInstance.dataSet settingsUpdate: settingObject
                                                withValue: newValue];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
