//
//  POSAttributesViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSAttributesViewController.h"


@interface POSAttributesViewController ()

@end


@implementation POSAttributesViewController


@synthesize tableView = _tableView;


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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [objectsHelperInstance.dataSet getAttributes];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return	 the number of rows in the section.
    return objectsHelperInstance.dataSet.attributes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttributeCustomCell";
    POSAttributeCell *cell = (POSAttributeCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier
                                                                                 forIndexPath: indexPath];
    
    POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];
    cell.textName.text = attribute.name;
    cell.swithIsActive.on = attribute.is_active;
    cell.cellIndex = indexPath;
    
    [cell.buttonDelete addTarget: self
                          action: @selector(onDeleteButton:)
                forControlEvents: UIControlEventTouchUpInside];
    
    return cell;
}


- (void)onDeleteButton:(id)sender{

    __deletedCell = [[[sender superview] superview] superview];
    NSString* question = [NSString stringWithFormat:@"Delete the %@ attribute?", ((POSAttributeCell *)__deletedCell).textName.text];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Delete"
                                                    message: question
                                                   delegate: self
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Yes", nil];
    [alert show];
}


#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqual: @"Delete"]) {
        
        NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"Yes"]) {
            // delete attribute
            POSAttributeCell *cell = (POSAttributeCell *)__deletedCell;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [objectsHelperInstance.dataSet.attributes removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    
    __deletedCell = nil;
}


@end
