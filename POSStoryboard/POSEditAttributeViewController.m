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


@synthesize tableViewAttributeValue = _tableViewAttributeValue;
@synthesize attribute = _attribute;
@synthesize attributeValues = _attributeValues;
@synthesize mainView = _mainView;


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

    self.tableViewAttributeValue.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewAttributeValue.dataSource = self;
    self.tableViewAttributeValue.delegate = self;

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
    
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return	 the number of rows in the section.
    NSInteger count = 1;
    
    if (section == 0) {
        
        count = 1;
    }
    else if (section == 1) {
        
        count = 1;
    }
    else {
        
        count = self.attributeValues.count;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

    if (indexPath.section == 0) {
    
        static NSString *CellStaticIdentifier = @"EditAttributeStaticCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellStaticIdentifier forIndexPath: indexPath];
        ((POSEditAttributeStaticCell *)cell).attribute = self.attribute;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
        lineView.backgroundColor = self.tableViewAttributeValue.separatorColor;
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.section == 1) {
        
        static NSString *EditAttributeSimpleStaticCell = @"EditAttributeSimpleStaticCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: EditAttributeSimpleStaticCell forIndexPath: indexPath];
    }
    else {
        
        static NSString *CellDynamicIdentifier = @"EditAttributeDynamicCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellDynamicIdentifier forIndexPath: indexPath];
        POSEditAttributeDynamicCell *dynamicCell = (POSEditAttributeDynamicCell *)cell;
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    if (indexPath.section == 0) {
        
        rowHeight = 76;
    }
    else if (indexPath.section == 1) {
        
        rowHeight = 30;
    }
    else {
        
        rowHeight = 68;
    }
    
    return rowHeight;
}

@end
