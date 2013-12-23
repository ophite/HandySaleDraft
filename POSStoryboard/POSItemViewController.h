//
//  POSItemViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSItem.h"
#import "POSOrder.h"
#import "POSObjectsHelper.h"


@interface POSItemViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>


@property POSItem *item;
@property POSOrder *order;

@property NSString *currentQuantity;
@property NSString *previousQuantity;

@property (weak, nonatomic) IBOutlet UITextField *textQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelAvailable;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)onOrder:(id)sender;


@end
