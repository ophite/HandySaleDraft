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
    self.labelCurrency.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_CURRENCY];

    float sum = 0.00;
    for (POSOrder *order in objectsHelperInstance.dataSet.orderArray) {
        
        sum = sum + order.price.floatValue;
    }
    
    self.labelSum.text = [helperInstance convertFloatToStringWithFormat2SignIfNeed:[NSString stringWithFormat:@"%.2f", sum]];
    
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


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"goToPaymentForm"]) {

        [self addBasket];
        float totalPrice = self.labelSum.text.floatValue;
        float paidAmount = ((POSBasket *)[helperInstance getObject: objectsHelperInstance.dataSet.baskets
                                                            withID: objectsHelperInstance.currentBasketID]).price.floatValue;
        
        POSBasketPaymentViewController *controller = (POSBasketPaymentViewController *)[segue destinationViewController];
        controller.paydAmount = paidAmount > 0 ? paidAmount : 0;
        controller.unpaydAmount = totalPrice - paidAmount;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
    int index = 0;
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.allItems count]; i++) {
        
        POSItem *item = (POSItem *)[objectsHelperInstance.dataSet.allItems objectAtIndex:i];
        
        if  ([item.name isEqualToString:order.name] && [item.category isEqualToString:order.category]) {
            
            index = i;
            break;
        }
    }
    
    POSItemViewController *controller = [helperInstance getUIViewController:@"POSItemViewController"];
    controller.item = [objectsHelperInstance.dataSet.allItems objectAtIndex:index];
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
            [self.tableBasket deleteRowsAtIndexPaths: @[indexPath]
                                    withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    
    __deletedCell = nil;
}

#pragma mark - Methods

- (void)addBasket {
    
    if(objectsHelperInstance.currentBasketID == 0) {
        
        POSBasket *newBasket = [objectsHelperInstance.dataSet basketsCreate:0.00 withDocumentTypeID:1 withUserID:1];
        objectsHelperInstance.currentBasketID = newBasket.ID;
    }
}


- (void)initControlsLayers {
    
    [helperInstance setButtonShadow:self.buttonPay withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonPay];
    [helperInstance setButtonFontColorBySetting:self.buttonPay];
    
    [helperInstance setButtonShadow:self.buttonList withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
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
    
    [self addBasket];
    
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

//
//- (IBAction)onPay:(id)sender {
//    
////    [self saveToDB];
////    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
////    objectsHelperInstance.currentBasketID = 0;
////    [self.navigationController popViewControllerAnimated:YES];
//}


- (IBAction)onList:(id)sender {
    
    POSBasketOpenViewController *controller = [helperInstance getUIViewController:@"POSBasketOpenViewController"];
    controller.title = @"Basket DB";
    [self.navigationController pushViewController:controller animated:YES];
}


@end
