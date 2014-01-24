//
//  POSItemEditViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSItem.h"
#import "POSCategory.h"
#import "POSSelectCategoryViewController.h"
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"
#import "POSHelper.h"
#import "POSSettingsGUIHelper.h"


@interface POSItemEditViewController : UITableViewController<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>


@property POSItem *item;
@property POSCategory *category;
@property NSString *oldName;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIButton *buttonCategory;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice_buy;
@property (weak, nonatomic) IBOutlet UITextField *textPrice_buy;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice_sale;
@property (weak, nonatomic) IBOutlet UITextField *textPrice_sale;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellImage;
@property (weak, nonatomic) IBOutlet UIView *contentCellImage;

- (void)loadCategory:(POSCategory *)category;


- (IBAction)onSave:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onCancel:(id)sender;


@end
