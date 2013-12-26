//
//  POSEditAttributeViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSEditAttributeViewController.h"

@interface POSEditAttributeViewController ()

@end


@implementation POSEditAttributeViewController

@synthesize tableViewAttribute = _tableViewAttribute;
@synthesize tableViewAttributeValue = _tableViewAttributeValue;
@synthesize attribute = _attribute;
@synthesize attributeValues = _attributeValues;


#pragma mark - Standart

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.attribute) {
    
        self.attribute = [POSAttribute createNewAttribute:@"new attribute" withIs_active:NO];
        [objectsHelperInstance.dataSet.attributes addObject:self.attribute];
    }
    
    self.tableViewAttribute.dataSource = self;
    self.tableViewAttribute.delegate = self;
//    self.tableViewAttribute.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewAttributeValue.dataSource = self;
    self.tableViewAttributeValue.delegate = self;
    self.tableViewAttributeValue.separatorStyle = UITableViewCellSeparatorStyleNone;
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger count = 1;
    
    if (tableView == self.tableViewAttribute) {
        
        count = 1;
    }
    else {
        
    }
        
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return	 the number of rows in the section.
    NSInteger count = 1;
    
    if (tableView == self.tableViewAttribute) {
        
        count = 1;
    }
    else {
        
        count = self.attributeValues.count;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.tableViewAttribute) {
        
        static NSString *CellStaticIdentifier = @"EditAttributeStaticCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellStaticIdentifier forIndexPath: indexPath];
        ((POSEditAttributeStaticCell *)cell).attribute = self.attribute;
    }
    else {
        
        static NSString *CellDynamicIdentifier = @"EditAttributeDynamicCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellDynamicIdentifier forIndexPath: indexPath];
        POSEditAttributeDynamicCell *dynamicCell = (POSEditAttributeDynamicCell *)cell;
        
        if (indexPath.row > 0)
            dynamicCell.labelAttributeValueTitle.text = @"";
        
        if (self.attributeValues.count >  0) {

            dynamicCell.attrValue = [objectsHelperInstance.dataSet.attributeValues objectAtIndex:indexPath.row];
        }
        else {
            
            dynamicCell.attrValue = [POSAttributeValue createNewAttributeValue:@"new attribute variant" withAttribute_ID:self.attribute.ID];
            [objectsHelperInstance.dataSet.attributeValues addObject:dynamicCell.attrValue];
        }
    }
    
    return cell;
}


@end
