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

@synthesize btnBarSendEmail     = _btnBarSendEmail;
@synthesize btnCancel           = _btnCancel;
@synthesize btnClear            = _btnClear;
@synthesize btnOpen             = _btnOpen;
@synthesize btnSave             = _btnSave;
@synthesize tableBasket         = _tableBasket;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objectsHelperInstance.dataSet.orderArray count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString* good = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:[indexPath row]] name];
    NSString* quan = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:[indexPath row]] quantity];
    NSString* title = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:[indexPath row]] category];
    
    title = [title stringByAppendingString:@"  "];
    title = [title stringByAppendingString:good];
    [[cell textLabel] setText:title];
    cell.detailTextLabel.text = quan;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage* image = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:[indexPath row]] image];
    cell.imageView.image = image;
    
    return cell;
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString* name;
    NSString* cat;
    
    int index = indexPath.row;
    int n = [objectsHelperInstance.dataSet.allItems count];
    
    name = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:index] name];
    cat = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:index] category];
    
    for(int i = 0; i<n; i++)
    {
        if  ([[[objectsHelperInstance.dataSet.allItems objectAtIndex:i] name] isEqualToString:name]&&
             [[[objectsHelperInstance.dataSet.allItems objectAtIndex:i] category] isEqualToString:cat])
            
        {
            itemIndex = i;
            break;
        }
    }
    
    POSItemViewController* viewItem = [POSItemViewController new];
    viewItem.item = [objectsHelperInstance.dataSet.allItems objectAtIndex:itemIndex];
    viewItem.title = viewItem.item.name;
    NSString* quan;
    quan = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:indexPath.row] quantity];
    NSLog(@"Quan = %@", quan);
    viewItem.item.quantityOrdered = quan;
    viewItem.currentQuantity = quan;
    [self.navigationController pushViewController:viewItem animated:YES];
}


-(void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* name;
    NSString* cat;
    
    int index = indexPath.row;
    int n = [objectsHelperInstance.dataSet.allItems count];
    
    name = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:index] name];
    cat = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:index] category];
    
    for(int i = 0; i<n; i++)
    {
        if  ([[[objectsHelperInstance.dataSet.allItems objectAtIndex:i] name] isEqualToString:name]&&
             [[[objectsHelperInstance.dataSet.allItems objectAtIndex:i] category] isEqualToString:cat])
        {
            itemIndex = i;
            break;
        }
    }
    
    POSItemViewController* viewItem = [POSItemViewController new];
    viewItem.item = [objectsHelperInstance.dataSet.allItems objectAtIndex:itemIndex];
    viewItem.title = viewItem.item.name;
    
    NSString*     quan = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:indexPath.row] quantity];
//    quan = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:indexPath.row] quantity];
    viewItem.item.quantityOrdered = quan;
    viewItem.currentQuantity = quan;
    [self.navigationController pushViewController:viewItem animated:YES];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableBasket reloadData];
}


- (void) saveToDB
{
    POSDBWrapper * dbWrapper = [POSDBWrapper getInstance];
    if (![dbWrapper openDB])
        return;
    
    float totalPrice = 0.;
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++)
    {
        POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
        totalPrice += [order.price floatValue];
    }
    
    if(objectsHelperInstance.currentBasketID)
    {
        NSString * query = [NSString stringWithFormat:@"UPDATE  document \
                            SET     date = datetime('now'), paid_price = %f \
                            WHERE   id = %d",totalPrice, objectsHelperInstance.currentBasketID];
        [dbWrapper tryExecQuery:query];
        
        query = [NSString stringWithFormat:@"DELETE \
                 FROM   document_line \
                 WHERE  document_id = %d", objectsHelperInstance.currentBasketID];
        [dbWrapper tryExecQuery:query];
        
        for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++)
        {
            POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
            float price = [order.price floatValue];
            int quantity = [order.quantity intValue];
            
            query = [NSString stringWithFormat:@"INSERT INTO document_line (price, quantity, item_id, document_id) \
                     VALUES (%f, %d, %d, %d)", price, quantity, order.item_ID, objectsHelperInstance.currentBasketID];
            [dbWrapper tryExecQuery:query];
        }
    }
    else
    {
        NSString * query = [NSString stringWithFormat:@"INSERT INTO document (date, paid_price, document_type_id, user_id) \
                            VALUES (datetime('now'), %f, %d, %d)", totalPrice, 1, 1];
        [dbWrapper tryExecQuery:query];
        
        query = @"SELECT    id \
        FROM      document \
        ORDER BY id DESC limit 1";
        int doc_ID = [dbWrapper execQueryResultInt:query p_index:0];
        
        for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++)
        {
            POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
            float price = [order.price floatValue];
            int quantity = [order.quantity intValue];
            
            query = [NSString stringWithFormat:@"INSERT INTO document_line (price, quantity, item_id, document_id) \
                     VALUES (%f, %d, %d, %d)", price, quantity, order.item_ID, doc_ID];
            [dbWrapper tryExecQuery:query];
        }
    }
    
    [dbWrapper closeDB];
}


- (IBAction)onSendEmail:(id)sender
{
    [self saveToDB];
    
    if(![MFMailComposeViewController canSendMail])
        return;

    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    
    [mailCont setSubject:@"POS Order"];
    
    NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    [messageBody appendFormat:@"<table>"];
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++)
    {
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([[objectsHelperInstance.dataSet.orderArray objectAtIndex:i] image])];
        NSString *base64String = [imageData base64EncodedString];
        
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


- (IBAction)onCancel:(id)sender
{
    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onClear:(id)sender
{
    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onSave:(id)sender
{
    [self saveToDB];
    [objectsHelperInstance.dataSet.orderArray removeAllObjects];
    objectsHelperInstance.currentBasketID = 0;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onOpen:(id)sender
{
    POSBasketOpenViewController* viewBasketList = [POSBasketOpenViewController new];
    viewBasketList.title = @"Basket DB";
    viewBasketList.basketArray = [[NSMutableArray alloc] init];
    [viewBasketList readBasketsList];
    [self.navigationController pushViewController:viewBasketList animated:YES];
}


@end
