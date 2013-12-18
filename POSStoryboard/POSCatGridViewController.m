//
//  POSCatGridViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSCatGridViewController.h"

@interface POSCatGridViewController ()

@end

@implementation POSCatGridViewController

@synthesize gridView        = _gridView;
@synthesize btnAdd          = _btnAdd;
@synthesize btnBasket       = _btnBasket;
@synthesize btnChangeMode   = _btnChangeMode;
@synthesize btnScan         = _btnScan;


/*
 * ViewController
 */
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
    
    [objectsHelperInstance.dataSet getCategories];
    [objectsHelperInstance.dataSet getAllItems];
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL result = YES;
    
    if ([identifier isEqualToString:@"goToGoodsFake"])
    {
        result = NO;
    }
    
    return result;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


/*
 * GridView methods
 */
- (NSUInteger)numberOfItemsInGridView: (AQGridView *) aGridView
{
    return [objectsHelperInstance.dataSet.categories count];
}


- (AQGridViewCell*)gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString* PlainCellIdentifier = @"PlainCellIdentifier";
    
    POSGridViewCell* cell = (POSGridViewCell*)[aGridView dequeueReusableCellWithIdentifier:@"PlainCellIdentifier"];
    if (cell == nil)
    {
        cell = [[POSGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 160, 160) reuseIdentifier: PlainCellIdentifier];
    }
    
    NSString* name = [[objectsHelperInstance.dataSet.categories objectAtIndex:index] name];
    UIImage* image = [[objectsHelperInstance.dataSet.categories objectAtIndex:index] image];
    
    [cell.imageView setImage:image];
    [cell.captionLabel setText: name];
    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.gridView reloadData];
}


-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    if(!objectsHelperInstance.catsMode) //View goods
    {
        POSGoodsGridViewController * viewGoods = [POSGoodsGridViewController new];
        viewGoods.cat = [objectsHelperInstance.dataSet.categories objectAtIndex:index];
        viewGoods.title = viewGoods.cat.name;
        [self.navigationController pushViewController:viewGoods animated:YES];
    }
    else //Edit
    {
        POSEditCatViewController * viewEditCat = [[POSEditCatViewController alloc] initWithNibName:@"POSEditCatViewController" bundle:nil];
        viewEditCat.cat = [objectsHelperInstance.dataSet.categories objectAtIndex:index];
        [self.navigationController pushViewController:viewEditCat animated:YES];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (CGSize)portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(160.0, 160) );
}


/*
 * Other
 */
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridView;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol* symbol = nil;
    NSString* result = nil;
    
    for(symbol in results)
    {
        result = symbol.data;
        break;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if([dbWrapperInstance openDB])
        return;
    
    NSString* query = [NSString stringWithFormat:@"select id from Product WHERE code = \"%@\"; ", result];
    int product_id = [dbWrapperInstance execQueryResultInt:query p_index:0];
    [dbWrapperInstance closeDB];
    
    POSItem* resultItem = nil;

    for (POSItem* item_ in objectsHelperInstance.dataSet.items)
    {
        if (item_.ID == product_id)
        {
            resultItem = item_;
            break;
        }
    }
    
    if (resultItem == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Not found" message:@"Item not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        POSItemViewController* viewItem = [POSItemViewController new];
        viewItem.item = resultItem;
        [self.navigationController pushViewController:viewItem animated:YES];
    }
}


//TODO что это
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"No"])
    {
        
    }
    else
    {
        [objectsHelperInstance.dataSet.categories removeObjectAtIndex:objectsHelperInstance.currentCatIndex];
        [self.gridView reloadData];
        
        if ([dbWrapperInstance openDB])
            return;

        NSString * query = [NSString stringWithFormat:@"DELETE FROM collection WHERE name = \"%@\" AND user_id = %d", catName, 1];
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
    }
}


/*
 * Actions
 */
- (IBAction)onScan:(id)sender
{
    ZBarReaderViewController* reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: 0
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    
    [reader.scanner setSymbology: ZBAR_EAN13
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    
    [reader.scanner setSymbology: ZBAR_EAN8
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    
    // Enable UPC-A
    [reader.scanner setSymbology: ZBAR_UPCA
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    
    reader.readerView.zoom = 1.0;
    reader.showsZBarControls = NO;
    
    [self presentViewController: reader animated: YES completion:nil];
}


- (IBAction)onChangeMode:(id)sender
{
    objectsHelperInstance.catsMode = !objectsHelperInstance.catsMode;
    [self.btnChangeMode setTitle: (objectsHelperInstance.catsMode ? @"View mode" : @"Edit mode") forState: UIControlStateNormal];
}


@end
