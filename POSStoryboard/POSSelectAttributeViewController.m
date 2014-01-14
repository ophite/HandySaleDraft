//
//  POSSelectAttributeViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/8/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSSelectAttributeViewController.h"


@interface POSSelectAttributeViewController ()

@end


@implementation POSSelectAttributeViewController


@synthesize picker = _picker;
@synthesize category = _category;
@synthesize attributeIndex = _attributeIndex;
@synthesize oldAttribute = _oldAttribute;
@synthesize categoryAttribute = _categoryAttribute;


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
    
    // init data
    [objectsHelperInstance.dataSet attributesGet];
    
    // gui
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    if (self.categoryAttribute) {
        
        self.oldAttribute = (POSAttribute *)[helperInstance getObject: objectsHelperInstance.dataSet.attributes
                                                               withID: self.categoryAttribute.attributeID];
        int row = [objectsHelperInstance.dataSet.attributes indexOfObject:self.oldAttribute];
        
        [self.picker selectRow: row
                   inComponent: 0
                      animated: YES];
    }
    
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
    
    return [objectsHelperInstance.dataSet.attributes count];
}


- (NSString *)pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component {
    
    POSAttribute *attribute = (POSAttribute *)[objectsHelperInstance.dataSet.attributes objectAtIndex:row];
    
    return attribute.name;
}


#pragma mark - Actions

- (IBAction)onSelect:(id)sender {

    NSInteger row = [self.picker selectedRowInComponent:0];
    POSAttribute *newAttribute = (POSAttribute *)[objectsHelperInstance.dataSet.attributes objectAtIndex:row];
    
    if (self.oldAttribute) {
        
        if (self.oldAttribute.ID != newAttribute.ID) {
            
            [objectsHelperInstance.dataSet categoriesAttributesUpdate: self.categoryAttribute
                                                        withAttribute: newAttribute];
        }
    }
    else {
        
        [objectsHelperInstance.dataSet categoriesAttributesCreate: self.category
                                                  withAttributeID: newAttribute
                                                        withIndex: self.attributeIndex];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
