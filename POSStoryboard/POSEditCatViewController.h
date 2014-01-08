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


@interface POSEditCatViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>


@property POSCategory *cat;
@property NSString *oldName;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

- (IBAction)onSelectCategory1:(id)sender;
- (IBAction)onSelectCategory2:(id)sender;

- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSelectImage:(id)sender;
- (IBAction)onDelete:(id)sender;


@end
