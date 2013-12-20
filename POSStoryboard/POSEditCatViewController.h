//
//  POSEditCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSCategory.h"

@interface POSEditCatViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    POSCategory *cat;
    NSString *oldName;
}

@property POSCategory *cat;
@property NSString *oldName;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSelectImage:(id)sender;
- (IBAction)onDelete:(id)sender;

@end
