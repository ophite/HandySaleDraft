//
//  POSItemsViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSItemsViewController.h"


@interface POSItemsViewController ()

@end


@implementation POSItemsViewController


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
    
    // init data
    self.catName = self.cat.name;
    [objectsHelperInstance.dataSet.items removeAllObjects];
    [objectsHelperInstance.dataSet itemsGetByCategory:self.catName];
    objectsHelperInstance.itemsMode = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_ITEM_MODE].boolValue;

    
    // gui
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];
    
    [self.btnChangeMode setTitle: (objectsHelperInstance.itemsMode? @"View mode" : @"Edit mode")
                        forState: UIControlStateNormal];

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated {
    
    POSSetting *settingItemMode = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_ITEM_MODE];
    
    if (![settingItemMode.value isEqualToString:[helperInstance convertBoolToString:objectsHelperInstance.itemsMode]]) {
        
        [objectsHelperInstance.dataSet settingsUpdate: settingItemMode
                                            withValue: [helperInstance convertBoolToString:objectsHelperInstance.itemsMode]];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.gridView reloadData];
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
        
        cell = [[POSGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, helperInstance.ITEM_LIST_WIDTH, helperInstance.ITEM_LIST_HEIGHT)
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
    
    if(!objectsHelperInstance.itemsMode) {
        //View
        POSItemViewController *controller = [helperInstance getUIViewController: @"POSItemViewController"];
        controller.item = [objectsHelperInstance.dataSet.items objectAtIndex:index];
        controller.title = controller.item.name;
        [self.navigationController pushViewController: controller
                                             animated: YES];

    }
    else {
        //Edit
        POSItemEditViewController *controller = [helperInstance getUIViewController: @"POSItemEditViewController"];
        controller.item = [objectsHelperInstance.dataSet.items objectAtIndex:index];
        controller.title = controller.item.name;
        controller.category = self.cat;
        objectsHelperInstance.currentItemsIndex = index;
        [self.navigationController pushViewController: controller
                                             animated: YES];
    }
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    //int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    //UIImageView* currentImageView = [imageViews objectAtIndex:page];
    //return currentImageView;
    return self.gridView;
}


#pragma mark - Actions

- (IBAction)onChangeMode:(id)sender {
    
    objectsHelperInstance.itemsMode = !objectsHelperInstance.itemsMode;
    [self.btnChangeMode setTitle: (objectsHelperInstance.itemsMode? @"View mode" : @"Edit mode")
                        forState: UIControlStateNormal];
}


@end
