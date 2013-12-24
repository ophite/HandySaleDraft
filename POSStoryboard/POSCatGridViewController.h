//
//  POSCatGridViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AQGridView.h"
#import "ZBarSDK.h"

#import "POSGridViewCell.h"
#import "POSCategory.h"
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"
#import "POSGoodsGridViewController.h"
#import "POSEditCatViewController.h"
#import "POSHelper.h"

/*
 *UIScrollViewDelegate может надо для viewForZoomingInScrollView
 */
@interface POSCatGridViewController : UIViewController<UIAlertViewDelegate, AQGridViewDelegate, AQGridViewDataSource, ZBarReaderDelegate, UIScrollViewDelegate>

@property NSString *catName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet AQGridView *gridView;

@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeMode;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBasket;

- (IBAction)onScan:(id)sender;
- (IBAction)onChangeMode:(id)sender;


@end
