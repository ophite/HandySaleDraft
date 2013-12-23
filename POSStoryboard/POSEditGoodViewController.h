//
//  POSEditGoodViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSItem.h"
#import "POSCategory.h"
#import "POSSetCatViewController.h"
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"


@interface POSEditGoodViewController : UIViewController<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>


@property POSItem *item;
@property POSCategory *category;
@property NSString *oldName;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textCategory;
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UITextField *textPrice1;
@property (weak, nonatomic) IBOutlet UITextField *textPrice2;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;


- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSetCategory:(id)sender;
- (IBAction)onDeleteItem:(id)sender;
- (IBAction)onSetImage:(id)sender;
- (IBAction)onDeleteImage:(id)sender;


@end
