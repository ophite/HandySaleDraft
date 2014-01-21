//
//  POSSelectCategoryViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/18/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSSelectCategoryViewController.h"


@interface POSSelectCategoryViewController ()

@end


@implementation POSSelectCategoryViewController


@synthesize item = _item;
@synthesize category = _category;
@synthesize picker = _picker;


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
    
    int row = self.category ? [objectsHelperInstance.dataSet.categories indexOfObject:self.category] : 0;
    [self.picker selectRow: row
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
    
    return [objectsHelperInstance.dataSet.categories count];
}


- (NSString *)pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component {
    
    POSCategory *category = [objectsHelperInstance.dataSet.categories objectAtIndex:row];
    
    return category.name;
}


#pragma mark - Actions

- (IBAction)onSelect:(id)sender {
    
    NSInteger row = [self.picker selectedRowInComponent:0];
    POSCategory *newCategory = [objectsHelperInstance.dataSet.categories objectAtIndex:row];
    
    if (newCategory != nil && self.category.ID != newCategory.ID) {

        POSItemEditViewController *controller = (POSItemEditViewController *)[helperInstance getParentViewController:self.navigationController];
        [controller loadCategory:newCategory];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


@end
