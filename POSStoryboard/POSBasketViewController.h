//
//  POSBasketViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NSData+Base64.h"

#import "POSObjectsHelper.h"
#import "POSBasket.h"
#import "POSOrder.h"
#import "POSItemViewController.h"
#import "POSBasketOpenViewController.h"
#import "POSBasketEditDynamicCell.h"
#import "POSHelper.h"


@interface POSBasketViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {

@private
    id __deletedCell;

}


@property int itemIndex;
@property POSBasket *basket;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarSendEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonPay;
@property (weak, nonatomic) IBOutlet UIButton *buttonList;

@property (weak, nonatomic) IBOutlet UITableView *tableBasket;

@property (weak, nonatomic) IBOutlet UILabel *labelSum;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;


- (IBAction)onSendEmail:(id)sender;
//- (IBAction)onSave:(id)sender;
- (IBAction)onPay:(id)sender;
- (IBAction)onList:(id)sender;
- (IBAction)onDeleteButton:(id)sender;

- (void)saveToDB;


@end
