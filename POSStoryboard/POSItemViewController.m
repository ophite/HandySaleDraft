//
//  POSItemViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSItemViewController.h"


@interface POSItemViewController ()

@end


@implementation POSItemViewController


@synthesize item = _item;
@synthesize order = _order;
@synthesize currentQuantity = _currentQuantity;
@synthesize previousQuantity = _previousQuantity;

@synthesize textQuantity = _textQuantity;
@synthesize labelAvailable = _labelAvailable;
@synthesize labelCode = _labelCode;
@synthesize labelDescription = _labelDescription;
@synthesize labelPrice = _labelPrice;
@synthesize scrollView = _scrollView;
@synthesize viewContent = _viewContent;


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

    // gui
    self.textQuantity.delegate = self;

    self.scrollView.delegate = self;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(self.item.gallery.count*300, 285);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];
    
    for(int i = 0; i < self.item.gallery.count; i++) {
        
        POSGallery *gallery = (POSGallery *)[self.item.gallery objectAtIndex:i];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:gallery.image];
        imageView.frame = CGRectMake(i*helperInstance.ITEM_VIEW_WIDTH, 0, helperInstance.ITEM_VIEW_WIDTH, helperInstance.ITEM_VIEW_HEIGHT);
        imageView.backgroundColor = [UIColor whiteColor];
        [self.viewContent addSubview:imageView];
    }
    
    [self.labelCode setText:self.item.codeItem];
    [self.labelAvailable setText:self.item.quantityAvailable];
    [self.labelDescription setText:self.item.description];
    [self.labelPrice setText:self.item.price_buy];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    //int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    //UIImageView* currentImageView = [imageViews objectAtIndex:page];
    //return currentImageView;
    return self.viewContent;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if( [self.textQuantity isFirstResponder])
        [self.textQuantity resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.textQuantity setText:self.currentQuantity];
}


#pragma mark - Actions

- (IBAction)onOrder:(id)sender {
    
    self.currentQuantity = [self.textQuantity text];
    self.previousQuantity = self.item.quantityOrdered;
    self.item.quantityOrdered = self.currentQuantity;
    
    if([self.currentQuantity intValue] == [self.previousQuantity integerValue]) {
        
        [self.textQuantity resignFirstResponder];
        return;
    }
    
    objectsHelperInstance.currentBasketID = 0;
    
    if([self.previousQuantity intValue] == 0 && [self.currentQuantity intValue] > 0) {
        
        self.order = [[POSOrder alloc] init];
        self.order.category  = self.item.category;
        self.order.name      = self.item.name;
        self.order.quantity  = self.item.quantityOrdered;
        self.order.price     = self.item.price_buy;
        self.order.codeItem  = self.item.codeItem;
        self.order.image     = self.item.image;
        self.order.itemID   = self.item.ID;
        // TODO: в будущем сделать ввод клиента
        self.order.client = self.item.category;
        
        [objectsHelperInstance.dataSet.orders addObject:self.order];
        
    } else if([objectsHelperInstance.dataSet.orders count] > 0) {
        
        NSString *orderName;

        for(int i = 0; i<[objectsHelperInstance.dataSet.orders count]; i++) {
            
            orderName = [[objectsHelperInstance.dataSet.orders objectAtIndex:i] name];
            
            if([orderName isEqualToString:self.item.name]) {
                
                if([self.currentQuantity intValue] > 0) {
                    
                    POSOrder* order = [objectsHelperInstance.dataSet.orders objectAtIndex:i];
                    order.quantity = self.currentQuantity;
                }
                else
                    [objectsHelperInstance.dataSet.orders removeObjectAtIndex:i];
                
                break;
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
