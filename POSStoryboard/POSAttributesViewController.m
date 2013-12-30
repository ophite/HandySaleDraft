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
    
    [objectsHelperInstance.dataSet attributesGet];
    [objectsHelperInstance.dataSet attributeValuesGet];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"goToAddNewVariant"]) {
        //the sender is what you pass into the previous method
        POSEditAttributeViewController *dest = (POSEditAttributeViewController *)[segue destinationViewController];
        dest.attribute = [objectsHelperInstance.dataSet attributesCreate: @"new attribute"
                                                           withIs_active: NO];
    }
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return	 the number of rows in the section.
    return objectsHelperInstance.dataSet.attributes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AttributeCustomCell";

    POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];
    POSAttributeCell *cell = (POSAttributeCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    [cell.buttonName setTitle:attribute.name forState:UIControlStateNormal];
    [cell.buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cell.swithIsActive.on = attribute.is_active;
    cell.tag = attribute.ID;
    
    [cell.buttonDelete addTarget: self
                          action: @selector(onDeleteButton:)
                forControlEvents: UIControlEventTouchUpInside];
    
    [cell.buttonName addTarget: self
                        action: @selector(onGoToEditAttribute:)
              forControlEvents: UIControlEventTouchUpInside];
    
    return cell;
}


- (void)onGoToEditAttribute:(id)sender {
    
    __deletedCell = [[[sender superview] superview] superview];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID = %d", (int)((POSAttributeCell *)__deletedCell).tag];
    NSArray *arr = [objectsHelperInstance.dataSet.attributes filteredArrayUsingPredicate:predicate];

    POSEditAttributeViewController *controller = [helperInstance GetUIViewController:@"POSEditAttributeViewController"];
    controller.attribute = [arr objectAtIndex:0];
    
    predicate = [NSPredicate predicateWithFormat:@"attribute_ID = %d", controller.attribute.ID];
    controller.attributeValues = [[NSMutableArray alloc] initWithArray:[objectsHelperInstance.dataSet.attributeValues filteredArrayUsingPredicate:predicate]];
    
    [self.navigationController pushViewController: controller
                                         animated: YES];
}


- (void)onDeleteButton:(id)sender {

    __deletedCell = [[[sender superview] superview] superview];
    NSString* question = [NSString stringWithFormat:@"Delete the %@ attribute?", ((POSAttributeCell *)__deletedCell).buttonName.titleLabel.text];
    
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
            POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];
            [objectsHelperInstance.dataSet attributesDelete:attribute];
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    
    __deletedCell = nil;
}


@end
