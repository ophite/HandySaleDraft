//
//  POSBasketOpenViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/17/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSBasketOpenViewController.h"
#import "POSDBWrapper.h"
#import "POSOrder.h"
#import "POSBasket.h"

@interface POSBasketOpenViewController ()

@end

@implementation POSBasketOpenViewController

@synthesize basketArray = _basketArray;
@synthesize btnSave     = _btnSave;
@synthesize btnCancel   = _btnCancel;
@synthesize tableBasket = _tableBasket;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableBasket.dataSource = self;
    self.tableBasket.delegate = self;

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
    return [self.basketArray count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString* name = [[self.basketArray objectAtIndex:[indexPath row]] name];
    NSString* price = [[self.basketArray objectAtIndex:[indexPath row]] price];
    
    [[cell textLabel] setText:name];
    cell.detailTextLabel.text = price;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) readBasketData: (int) doc_ID
{
    POSDBWrapper * dbWrapper = [POSDBWrapper getInstance];
    if (![dbWrapper openDB])
        return;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSString * query = [NSString stringWithFormat:@"SELECT  item_id, quantity \
                                                    FROM    document_line \
                                                    WHERE document_id = %d", doc_ID];
    
    void (^blockGetOrder)(id rows) = ^(id rows)
    {
        POSOrder* order = [[POSOrder alloc] init];
        order.item_ID = [dbWrapper getCellInt:0];
        order.quantity = [[NSString alloc] initWithFormat:@"%d", [dbWrapper getCellInt:1]];
        [((NSMutableArray *)rows) addObject:order];
    };
    
    [dbWrapper fetchRows:query foreachCallback:blockGetOrder p_rows:objectsHelperInstance.dataSet.orderArray];
    
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++)
    {
        POSOrder* order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
        query = [NSString stringWithFormat:@"SELECT     p.name, c.name, p.price_buy, i.asset \
                                             FROM       product p, collection c, image i \
                                             WHERE      p.id = %d AND c.id = p.collection_id AND i.object_id = p.id", order.item_ID];
        
        
        void (^blockExtractOrderValues)() = ^()
        {
            order.name = [dbWrapper getCellText:0];
            order.category  = [dbWrapper getCellText:1];
            order.price     = [dbWrapper getCellText:2];
            order.codeItem  = @"001";
            
            const unsigned char* asset = [dbWrapper getCellChar:3];
            if (asset != nil)
            {
                NSURL* assetUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithUTF8String:(const char *) asset]];
                
                [library assetForURL: assetUrl resultBlock:^(ALAsset *asset)
                 {
                     order.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                 }
                 failureBlock: ^(NSError* error)
                 {
                     NSLog(@"%@", error.description);
                 }
                 ];
            }
            
        };
        
        [dbWrapper extractMultipleValues:query foreachCallback:blockExtractOrderValues];
    }
    
    [dbWrapper closeDB];
}


-(void)readBasketsList
{
    POSDBWrapper * dbWrapper = [POSDBWrapper getInstance];
    if (![dbWrapper openDB])
        return;
    
    NSString * query = @"SELECT id, date, paid_price, user_id FROM document WHERE user_id = 1 ORDER BY id DESC";
    
    void (^blockGetBasket)(id rows) = ^(id rows)
    {
        int user_ID = [dbWrapper getCellInt:3];
        if(user_ID == 1)
        {
            POSBasket* basketObject = [[POSBasket alloc] init];
            basketObject.ID = [dbWrapper getCellInt:0];
            basketObject.tst = [dbWrapper getCellText:1];
            basketObject.name = [[NSString alloc] initWithFormat: @"No:%d %@", basketObject.ID, basketObject.tst];
            basketObject.price = [dbWrapper getCellText:2];
            
            [((NSMutableArray *)rows) addObject:basketObject];
        }
    };
    
    [dbWrapper fetchRows:query foreachCallback:blockGetBasket p_rows:self.basketArray];
    [dbWrapper closeDB];
}


/*
 * Actions
 */
- (IBAction)onSave:(id)sender
{
    NSIndexPath *indexPath = [self.tableBasket indexPathForSelectedRow];
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID ];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
