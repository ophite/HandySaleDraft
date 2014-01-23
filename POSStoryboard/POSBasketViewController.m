//
//  POSBasketViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSBasketViewController.h"


@interface POSBasketViewController ()

@end


@implementation POSBasketViewController


@synthesize btnBarSendEmail = _btnBarSendEmail;
@synthesize buttonList = _buttonList;
@synthesize buttonPay = _buttonPay;

@synthesize tableBasket = _tableBasket;

@synthesize labelSum = _labelSum;
@synthesize labelCurrency = _labelCurrency;

@synthesize basket = _basket;
@synthesize itemIndex = _itemIndex;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // data
    
    // gui
    self.tableBasket.delegate = self;
    self.tableBasket.dataSource = self;
    self.tableBasket.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initControlsLayers];
    
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableBasket reloadData];
}


#pragma mark - GridView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [objectsHelperInstance.dataSet.orderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"POSBasketEditDynamicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    POSBasketEditDynamicCell *dynamicCell = (POSBasketEditDynamicCell *)cell;
    dynamicCell.order = (POSOrder *)[objectsHelperInstance.dataSet.orderArray objectAtIndex:[indexPath row]];
    dynamicCell.item = (POSItem *)[helperInstance getObject:objectsHelperInstance.dataSet.allItems withID:dynamicCell.order.item_ID];
    dynamicCell.labelRowIndex.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return dynamicCell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POSOrder *order = (POSOrder *)[objectsHelperInstance.dataSet.orderArray objectAtIndex:indexPath.row];
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.allItems count]; i++) {
        
        POSItem *item = (POSItem *)[objectsHelperInstance.dataSet.allItems objectAtIndex:i];
        
        if  ([item.name isEqualToString:order.name] && [item.category isEqualToString:order.category]) {
            
            self.itemIndex = i;
            break;
        }
    }
    
    POSItemViewController *controller = [helperInstance getUIViewController:@"POSItemViewController"];
    controller.item = [objectsHelperInstance.dataSet.allItems objectAtIndex:self.itemIndex];
    controller.title = controller.item.name;
    controller.item.quantityOrdered = order.quantity;
    controller.currentQuantity = order.quantity;
    
    [self.navigationController pushViewController: controller animated: YES];
}


#pragma mark - Email

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [controller dismissViewControllerAnimated: YES completion: nil];
}



#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqual: @"Delete"]) {
        
        NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"Yes"]) {
            // delete attribute
            POSBasketEditDynamicCell *cell = (POSBasketEditDynamicCell *)__deletedCell;
            NSIndexPath *indexPath = [self.tableBasket indexPathForCell:cell];
            POSOrder *order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:indexPath.row];
            
            [objectsHelperInstance.dataSet.orderArray removeObject:order];
//            [objectsHelperInstance.dataSet attributeValuesRemove:attributeValue];
            [self.tableBasket deleteRowsAtIndexPaths: @[indexPath]
                                    withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    
    __deletedCell = nil;
}

#pragma mark - Methods

- (void)saveToDB {
    
    if (![dbWrapperInstance openDB])
        return;
    
    float totalPrice = 0.;
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
        
        POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
        totalPrice += [order.price floatValue];
    }
    
    if(objectsHelperInstance.currentBasketID) {
        
        NSString * query = [NSString stringWithFormat:@"UPDATE  document \
                                                        SET     date = datetime('now'), paid_price = %f \
                                                        WHERE   id = %d; ",totalPrice, objectsHelperInstance.currentBasketID];
        [dbWrapperInstance tryExecQuery:query];
        
        query = [NSString stringWithFormat:@"DELETE \
                                             FROM   document_line \
                                             WHERE  document_id = %d; ", objectsHelperInstance.currentBasketID];
        [dbWrapperInstance tryExecQuery:query];
        
        for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
            
            POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
            float price = [order.price floatValue];
            int quantity = [order.quantity intValue];
            
            query = [NSString stringWithFormat:@"INSERT INTO document_line (price, quantity, item_id, document_id) \
                                                 VALUES (%f, %d, %d, %d); ", price, quantity, order.item_ID, objectsHelperInstance.currentBasketID];
            [dbWrapperInstance tryExecQuery:query];
        }
    }
    else {
        
        NSString * query = [NSString stringWithFormat:@"INSERT INTO document (date, paid_price, document_type_id, user_id) \
                                                        VALUES (datetime('now'), %f, %d, %d); ", totalPrice, 1, 1];
        [dbWrapperInstance tryExecQuery:query];
        
        query = @"SELECT    id \
                  FROM      document \
                  ORDER BY  id DESC limit 1; ";
        int doc_ID = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        
        for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
            
            POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
            float price = [order.price floatValue];
            int quantity = [order.quantity intValue];
            
            query = [NSString stringWithFormat:@"INSERT INTO document_line (price, quantity, item_id, document_id) \
                                                 VALUES (%f, %d, %d, %d); ", price, quantity, order.item_ID, doc_ID];
            [dbWrapperInstance tryExecQuery:query];
        }
    }
    
    [dbWrapperInstance closeDB];
}


- (void)initControlsLayers {
    
    [helperInstance setButtonShadow:self.buttonPay withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonPay];
    [helperInstance setButtonFontColorBySetting:self.buttonPay];
    
    [helperInstance setButtonShadow:self.buttonList withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonList];
}


#pragma mark - Actions

- (void)onDeleteButton:(id)sender {
    
    __deletedCell = [[[sender superview] superview] superview];
    
    NSString* question = @"Delete cell?";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Delete"
                                                    message: question
                                                   delegate: self
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Yes", nil];
    [alert show];
}


- (IBAction)onSendEmail:(id)sender {
    
    [self saveToDB];
    
    if(![MFMailComposeViewController canSendMail])
        return;

    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    
    [mailCont setSubject:@"POS Order"];
    
    NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    [messageBody appendFormat:@"<table>"];
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
        
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([[objectsHelperInstance.dataSet.orderArray objectAtIndex:i] image])];
        NSString *base64String = [imageData  base64EncodedString];
        
        [messageBody appendFormat:@"<tr>"];
        [messageBody appendFormat:@"<td style=\"width:50px;display:block\">"];
        [messageBody appendFormat:@"<img height=\"48\" width=\"48\" src='data:image/png;base64,%@'>" , base64String];
        [messageBody appendFormat:@"</td>"];
        [messageBody appendFormat:@"<td>"];
        [messageBody appendFormat:@"%@", [[objectsHelperInstance.dataSet.orderArray objectAtIndex:i] name]];
        [messageBody appendFormat:@"</td>"];
        [messageBody appendFormat:@"<td>"];
        [messageBody appendFormat:@"%@", [[objectsHelperInstance.dataSet.orderArray objectAtIndex:i] quantity]];
        [messageBody appendFormat:@"</td>"];
        [messageBody appendFormat:@"</tr>"];
    }
    
    [messageBody appendFormat:@"</table>"];
    [messageBody appendFormat:@"</body></html>"];
    [mailCont setMessageBody:messageBody isHTML:YES];
    
    [self presentViewController:mailCont animated:YES completion:nil];
}


- (IBAction)onSave:(id)sender {
    
    [self saveToDB];
    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
    objectsHelperInstance.currentBasketID = 0;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onPay:(id)sender {
    
//    [self saveToDB];
//    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
//    objectsHelperInstance.currentBasketID = 0;
//    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onList:(id)sender {
    
//    POSBasketOpenViewController* viewBasketList = [POSBasketOpenViewController new];
//    viewBasketList.title = @"Basket DB";
//    viewBasketList.basketArray = [[NSMutableArray alloc] init];
//    [viewBasketList readBasketsList];
//    [self.navigationController pushViewController:viewBasketList animated:YES];
}


@end
