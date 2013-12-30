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


const int SECTION_ATTRIBUTE_NAME = 0;
const int SECTION_ATTRIBUTE_LABEL = 1;
const int SECTION_ATTRIBUTE_VALUE = 2;

const int SECTION_ATTRIBUTE_NAME_HEIGHT = 76;
const int SECTION_ATTRIBUTE_LABEL_HEIGHT = 30;
const int SECTION_ATTRIBUTE_VALUE_HEIGHT = 68;


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
    
    self.tableViewAttributeValue.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewAttributeValue.dataSource = self;
    self.tableViewAttributeValue.delegate = self;
    
    if (!self.attributeValues) {
        
        self.attributeValues = [[NSMutableArray alloc] init];
    }

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        // attribute name
        UITableViewCell *cell = [self.tableViewAttributeValue cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SECTION_ATTRIBUTE_NAME]];
        POSEditAttributeStaticCell *staticCell = (POSEditAttributeStaticCell *)cell;
        
        if (![self.attribute.name isEqualToString:staticCell.textAttributeName.text]) {
            
            [self.attribute updateAttribute: staticCell.textAttributeName.text
                              withIs_active: self.attribute.is_active];
        }

        //attribute value
        NSMutableArray *arrDirty = [[NSMutableArray alloc] init];

        if ([self.attributeValues count] > 0) {

            for (int i = 0; i < [self.attributeValues count]; i++) {
                
                POSAttributeValue *attrValue = (POSAttributeValue *)[self.attributeValues objectAtIndex:i];
                cell = [self.tableViewAttributeValue cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:SECTION_ATTRIBUTE_VALUE]];
                UITextField *textAttrValue = (UITextField *)[cell.contentView viewWithTag:[POSEditAttributeDynamicCell TextAttributeTAG]];

                if (![attrValue.name isEqualToString:textAttrValue.text]) {

                    attrValue.name = textAttrValue.text;
                    [arrDirty addObject:attrValue];
                }
            }
        }
        
        if ([arrDirty count] > 0) {
            
            [POSAttributeValue updateAttributeValues:arrDirty];
        }
    }
    [super viewWillDisappear:animated];
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return	 the number of rows in the section.
    NSInteger count = 1;
    
    if (section == SECTION_ATTRIBUTE_NAME) {
        
        count = 1;
    }
    else if (section == SECTION_ATTRIBUTE_LABEL) {
        
        count = 1;
    }
    else {
        
        count = self.attributeValues.count;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

    if (indexPath.section == SECTION_ATTRIBUTE_NAME) {
        // name attribute
        static NSString *CellStaticIdentifier = @"EditAttributeStaticCell";
        cell = [tableView dequeueReusableCellWithIdentifier: CellStaticIdentifier forIndexPath: indexPath];
        POSEditAttributeStaticCell *staticCell = (POSEditAttributeStaticCell *)cell;
        staticCell.attribute = self.attribute;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
        lineView.backgroundColor = self.tableViewAttributeValue.separatorColor;
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.section == SECTION_ATTRIBUTE_LABEL) {
        // label
        static NSString *EditAttributeSimpleStaticCell = @"EditAttributeSimpleStaticCell";
        cell = [tableView dequeueReusableCellWithIdentifier: EditAttributeSimpleStaticCell forIndexPath: indexPath];
    }
    else {
        // attribute value
        static NSString *CellDynamicIdentifier = @"EditAttributeDynamicCell";
        cell = [tableView dequeueReusableCellWithIdentifier: CellDynamicIdentifier forIndexPath: indexPath];
        POSEditAttributeDynamicCell *dynamicCell = (POSEditAttributeDynamicCell *)cell;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute_ID = %d", self.attribute.ID];
        NSArray *arr = [objectsHelperInstance.dataSet.attributeValues filteredArrayUsingPredicate:predicate];
        
        if (arr.count >  0) {
            
            dynamicCell.attrValue = [arr objectAtIndex:indexPath.row];
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
    
    if (indexPath.section == SECTION_ATTRIBUTE_NAME) {
        
        rowHeight = SECTION_ATTRIBUTE_NAME_HEIGHT;
    }
    else if (indexPath.section == SECTION_ATTRIBUTE_LABEL) {
        
        rowHeight = SECTION_ATTRIBUTE_LABEL_HEIGHT;
    }
    else {
        
        rowHeight = SECTION_ATTRIBUTE_VALUE_HEIGHT;
    }
    
    return rowHeight;
}


#pragma mark - Actions

- (IBAction)onAddNewAttrValue:(id)sender {

    POSAttributeValue *newAttrValue = [POSAttributeValue createNewAttributeValue: @"new variant"
                                                                withAttribute_ID: self.attribute.ID];
    [self.attributeValues addObject:newAttrValue];
    [objectsHelperInstance.dataSet.attributeValues addObject:newAttrValue];

    NSArray *arr = [[NSArray alloc] initWithObjects: [NSIndexPath indexPathForItem:(self.attributeValues.count - 1) inSection: SECTION_ATTRIBUTE_VALUE], nil];
    [self.tableViewAttributeValue insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}


@end
