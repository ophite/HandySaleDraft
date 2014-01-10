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
@synthesize buttonAddNewAttribute = _buttonAddNewAttribute;

#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // init data
    [objectsHelperInstance.dataSet attributesGet];
    [objectsHelperInstance.dataSet attributeValuesGet];
    
    // gui
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self initControlsLayers];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: @"onAddNewAttribute"]) {

        POSEditAttributeViewController *dest = (POSEditAttributeViewController *)[segue destinationViewController];
        dest.attribute = [objectsHelperInstance.dataSet attributesCreate: @"new attribute"
                                                           withIs_active: NO];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:(objectsHelperInstance.dataSet.attributes.count - 1) inSection:0];
        NSArray *arr = [[NSArray alloc] initWithObjects: newIndexPath, nil];
        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];

        __currentCell = [self.tableView cellForRowAtIndexPath:newIndexPath];
    }
    //the sender is what you pass into the previous method
}


- (void)viewWillAppear:(BOOL)animated {
    
    if (!__currentCell)
        return;
        
    NSIndexPath *indexPath = [self.tableView indexPathForCell:__currentCell];
    POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];
    POSAttributeCell *cell = (POSAttributeCell *)__currentCell;
    [cell.buttonName setTitle:attribute.name forState:UIControlStateNormal];
    __currentCell = Nil;
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
    
    __currentCell = [[[sender superview] superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:__currentCell];
    POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];

    POSEditAttributeViewController *controller = [helperInstance getUIViewController:@"POSEditAttributeViewController"];
    controller.attribute = attribute;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute_ID = %d", controller.attribute.ID];
    controller.attributeValues = [[NSMutableArray alloc] initWithArray:[objectsHelperInstance.dataSet.attributeValues filteredArrayUsingPredicate:predicate]];
    
    [self.navigationController pushViewController: controller
                                         animated: YES];
}


- (void)onDeleteButton:(id)sender {

    __currentCell = [[[sender superview] superview] superview];
    NSString* question = [NSString stringWithFormat:@"Delete the %@ attribute?", ((POSAttributeCell *)__currentCell).buttonName.titleLabel.text];
    
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
            POSAttributeCell *cell = (POSAttributeCell *)__currentCell;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            POSAttribute *attribute = [objectsHelperInstance.dataSet.attributes objectAtIndex:indexPath.row];
            [objectsHelperInstance.dataSet attributesDelete:attribute];
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    
    __currentCell = nil;
}

#pragma mark - Methods

- (void)initControlsLayers {
    
    // button save shadow
    [helperInstance setButtonShadow:self.buttonAddNewAttribute withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonAddNewAttribute];
    [helperInstance setButtonFontColorBySetting:self.buttonAddNewAttribute];
}



@end
