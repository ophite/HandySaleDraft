//
//  POSItemViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSItemViewController.h"
#import "POSObjectsHelper.h"

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

    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];

    for(int i = 0; i<self.item.gallery.count; i++) {
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[self.item.gallery objectAtIndex:i]];
        imageView.frame = CGRectMake(i*300, 0, 295, 285);
        imageView.backgroundColor = [UIColor whiteColor];
        [self.viewContent addSubview:imageView];
    }
    
    [self.labelCode setText:item.codeItem];
    [self.labelAvailable setText:item.quantityAvailable];
    [self.labelDescription setText:item.description];
    [self.labelPrice setText:item.price1];

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
    [self.textQuantity setText:currentQuantity];
}


#pragma mark - Actions

- (IBAction)onOrder:(id)sender {
    
    self.currentQuantity = [self.textQuantity text];
    self.previousQuantity = self.item.quantityOrdered;
    self.item.quantityOrdered = self.currentQuantity;
    
    if([currentQuantity intValue] == [previousQuantity integerValue]) {
        
        [self.textQuantity resignFirstResponder];
        return;
    }
    
    if([previousQuantity intValue] == 0 && [currentQuantity intValue] > 0) {
        
        order = [[POSOrder alloc] init];
        
        order.category  = item.category;
        order.name      = item.name;
        order.quantity  = item.quantityOrdered;
        order.price     = item.price1;
        order.codeItem  = item.codeItem;
        order.image     = item.image;
        order.item_ID   = item.ID;
        
        [objectsHelperInstance.dataSet.orderArray addObject:order];
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    
    if([objectsHelperInstance.dataSet.orderArray count] > 0) {
        
        NSString* orderName;

        for(int i = 0; i<[objectsHelperInstance.dataSet.orderArray count]; i++) {
            
            orderName = [[objectsHelperInstance.dataSet.orderArray objectAtIndex:i] name];
            
            if([orderName isEqualToString:item.name]) {
                
                if([currentQuantity intValue] > 0) {
                    
                    POSOrder* o;
                    o = [objectsHelperInstance.dataSet.orderArray objectAtIndex:i];
                    o.quantity = currentQuantity;
                }
                else
                    [objectsHelperInstance.dataSet.orderArray removeObjectAtIndex:i];
                
                break;
            }
            
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
