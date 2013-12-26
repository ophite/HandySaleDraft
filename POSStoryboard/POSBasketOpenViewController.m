//
//  POSBasketOpenViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/17/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSBasketOpenViewController.h"


@interface POSBasketOpenViewController ()

@end


@implementation POSBasketOpenViewController


@synthesize basketArray = _basketArray;
@synthesize btnSave = _btnSave;
@synthesize btnCancel = _btnCancel;
@synthesize tableBasket = _tableBasket;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.basketArray = [[NSMutableArray alloc] init];
    [self readBasketsList];

    self.tableBasket.dataSource = self;
    self.tableBasket.delegate = self;

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.basketArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: CellIdentifier];
    
    NSString* name = [[self.basketArray objectAtIndex:[indexPath row]] name];
    NSString* price = [[self.basketArray objectAtIndex:[indexPath row]] price];
    
    [[cell textLabel] setText:name];
    cell.detailTextLabel.text = price;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)readBasketData:(int)doc_ID {
    
    if (![dbWrapperInstance openDB])
        return;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSString * query = [NSString stringWithFormat:@"SELECT  item_id, quantity \
                                                    FROM    document_line \
                                                    WHERE   document_id = %d", doc_ID];
    
    void (^blockGetOrder)(id rows) = ^(id rows) {
        
        POSOrder* order = [[POSOrder alloc] init];
        order.item_ID = [dbWrapperInstance getCellInt:0];
        order.quantity = [[NSString alloc] initWithFormat:@"%d", [dbWrapperInstance getCellInt:1]];
        [((NSMutableArray *)rows) addObject:order];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetOrder
                         andRows: objectsHelperInstance.dataSet.orderArray];
    
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
        
        POSOrder *order = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
        query = [NSString stringWithFormat:@"SELECT     p.name, c.name, p.price_buy, i.asset \
                                             FROM       product p, collection c, image i \
                                             WHERE      p.id = %d AND c.id = p.collection_id AND i.object_id = p.id", order.item_ID];
        
        
        void (^blockExtractOrderValues)() = ^() {
            
            order.name = [dbWrapperInstance getCellText:0];
            order.category  = [dbWrapperInstance getCellText:1];
            order.price     = [dbWrapperInstance getCellText:2];
            order.codeItem  = @"001";
            
            const unsigned char* asset = [dbWrapperInstance getCellChar:3];
            if (asset != nil) {
                
                NSURL* assetUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithUTF8String:(const char *) asset]];
                
                [library assetForURL: assetUrl resultBlock:^(ALAsset *asset) {
                    
                    order.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                }
                        failureBlock: ^(NSError* error) {
                            
                            NSLog(@"%@", error.description);
                        }
                 ];
            }
        };
        
        [dbWrapperInstance extractMultipleValues: query
                              andForeachCallback: blockExtractOrderValues];
    }
    
    [dbWrapperInstance closeDB];
}


- (void)readBasketsList {
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = @"SELECT id, date, paid_price, user_id \
                         FROM   document \
                         WHERE  user_id = 1 \
                         ORDER BY id DESC";
    
    void (^blockGetBasket)(id rows) = ^(id rows) {
        
        int user_ID = [dbWrapperInstance getCellInt:3];
        if(user_ID == 1) {
            
            POSBasket* basketObject = [[POSBasket alloc] init];
            basketObject.ID = [dbWrapperInstance getCellInt:0];
            basketObject.tst = [dbWrapperInstance getCellText:1];
            basketObject.name = [[NSString alloc] initWithFormat: @"No:%d %@", basketObject.ID, basketObject.tst];
            basketObject.price = [dbWrapperInstance getCellText:2];
            
            [((NSMutableArray *)rows) addObject:basketObject];
        }
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetBasket
                         andRows: self.basketArray];
    [dbWrapperInstance closeDB];
}


#pragma mark - Actions
 
- (IBAction)onSave:(id)sender {
    
    NSIndexPath *indexPath = [self.tableBasket indexPathForSelectedRow];
    objectsHelperInstance.currentBasketID = [[self.basketArray objectAtIndex:[indexPath row]] ID];
    [self readBasketData: objectsHelperInstance.currentBasketID ];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
