//
//  POSBasketViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "POSObjectsHelper.h"
#import "NSData+Base64.h"
#import "POSBasket.h"
#import "POSOrder.h"
#import "POSItemViewController.h"
#import "POSBasketOpenViewController.h"

@interface POSBasketViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
{
//    int                 itemIndex;
//    POSBasket*          basket;
}

@property int itemIndex;
@property POSBasket *basket;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (weak, nonatomic) IBOutlet UITableView *tableBasket;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarSendEmail;


- (IBAction)onSendEmail:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onClear:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onOpen:(id)sender;
- (void)saveToDB;


@end
