//
//  POSEditCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSCategory.h"
#import "POSDBWrapper.h"
#import "POSObjectsHelper.h"
#import "POSHelper.h"
#import "POSSelectAttributeViewController.h"

@interface POSEditCatViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>


@property POSCategory *category;
@property POSCategoryAttribute *categoryAttribute1;
@property POSCategoryAttribute *categoryAttribute2;
@property NSString *oldName;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory1;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory2;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewScroll;
@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
@property (weak, nonatomic) IBOutlet UIView *viewForColorExample;


- (void)attributeLoad:(int)index;
- (void)attributeUpdate:(POSAttribute *)attribute withIndex:(int)index;


- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;


@end
