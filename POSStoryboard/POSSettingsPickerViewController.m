//
//  POSSettingsPickerViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/31/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSSettingsPickerViewController.h"


@interface POSSettingsPickerViewController ()

@end


@implementation POSSettingsPickerViewController


@synthesize currentItem = _currentItem;
@synthesize picker = _picker;
@synthesize pickerDict = _pickerDict;
@synthesize rowIndex = _rowIndex;
@synthesize selectedItem = _selectedItem;


#pragma mark - Standart

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

    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    NSArray *keys = [self.pickerDict allKeys];
    
    int index = [keys containsObject:self.currentItem]? [keys indexOfObject:self.currentItem]: -1;
    
    if (index > 0) {

        self.rowIndex = index;
    }
    else {
    
        self.rowIndex = 0;
    }
    
    [self.picker selectRow: self.rowIndex
               inComponent: 0
                  animated: YES];
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.selectedItem = [self.pickerDict valueForKey:[keys objectAtIndex:row]];
    
    return self.selectedItem;
//    return [self.pickerDict objectAtIndex:row];
}


#pragma mark - Actions

- (IBAction)onSelect:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
