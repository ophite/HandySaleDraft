//
//  POSGoodsGridViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSGoodsGridViewController.h"

@interface POSGoodsGridViewController ()

@end

@implementation POSGoodsGridViewController


@synthesize btnAdd = _btnAdd;
@synthesize btnChangeMode = _btnChangeMode;
@synthesize gridView = _gridView;

@synthesize cat = _cat;
@synthesize catName = _catName;
@synthesize item = _item;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.catName = self.cat.name;
    
    [objectsHelperInstance.dataSet.items removeAllObjects];
    [objectsHelperInstance.dataSet getItems: self.catName];
    
//    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 373)];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;

    [self.btnChangeMode setTitle: (objectsHelperInstance.goodsMode? @"View mode" : @"Edit mode")
                        forState: UIControlStateNormal];

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onChangeMode:(id)sender {
    
    objectsHelperInstance.goodsMode = !objectsHelperInstance.goodsMode;
    [self.btnChangeMode setTitle: (objectsHelperInstance.goodsMode? @"View mode" : @"Edit mode")
                        forState: UIControlStateNormal];
}



#pragma mark - GridView
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView {
    
    return [objectsHelperInstance.dataSet.items count];
}


- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index {
    
    static NSString* PlainCellIdentifier = @"PlainCellIdentifier";
    POSGridViewCell* cell = (POSGridViewCell*)[aGridView dequeueReusableCellWithIdentifier:@"PlainCellIdentifier"];
    
    if (cell == nil) {
        
        cell = [[POSGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 160, 160)
                                      reuseIdentifier: PlainCellIdentifier];
    }
    
    self.item = [objectsHelperInstance.dataSet.items objectAtIndex:index];
    [cell.imageView setImage:self.item.image];
    [cell.captionLabel setText:self.item.name];
    
    return cell;
}


- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView {
    
    return ( CGSizeMake(160.0, 160.0) );
}


- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    if(!objectsHelperInstance.goodsMode) {
        //View
        POSItemViewController* viewItem = [POSItemViewController new];
        viewItem.item = [objectsHelperInstance.dataSet.items objectAtIndex:index];
        viewItem.title = viewItem.item.name;
        [self.navigationController pushViewController:viewItem animated:YES];
    }
    else {
        //Edit
        POSEditGoodViewController* viewEditGood = [[POSEditGoodViewController alloc] initWithNibName: @"POSEditGoodViewController"
                                                                                              bundle: nil];
        viewEditGood.item = [objectsHelperInstance.dataSet.items objectAtIndex:index];
        viewEditGood.title = viewEditGood.item.name;
        objectsHelperInstance.currentItemsIndex = index;
        [self.navigationController pushViewController:viewEditGood animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.gridView reloadData];
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    //int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    //UIImageView* currentImageView = [imageViews objectAtIndex:page];
    //return currentImageView;
    return self.gridView;
}


@end
