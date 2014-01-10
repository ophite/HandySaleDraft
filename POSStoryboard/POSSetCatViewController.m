//
//  POSSetCatViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/18/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSSetCatViewController.h"


@interface POSSetCatViewController ()

@end


@implementation POSSetCatViewController


@synthesize item = _item;
@synthesize initRow = _initRow;
@synthesize exitRow = _exitRow;
@synthesize picker = _picker;
@synthesize pickerData = _pickerData;


#pragma mark - ViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil {
    
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
    
    [self.picker selectRow: self.initRow
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
    
    return [self.pickerData count];
}


- (NSString *)pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component {
    
    return [self.pickerData objectAtIndex:row];
}


#pragma mark - Actions
 
- (IBAction)onOk:(id)sender {
    
    self.exitRow = [self.picker selectedRowInComponent:0];
    self.item.category = [[objectsHelperInstance.dataSet.categories objectAtIndex:self.exitRow] name];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
