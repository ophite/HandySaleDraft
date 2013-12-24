//
//  POSAttributeCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POSAttributeCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *buttonDelete;
@property (nonatomic, weak) IBOutlet UITextField *textName;
@property (nonatomic, weak) IBOutlet UISwitch *swithIsActive;

- (IBAction)onDelete:(id)sender;
- (IBAction)onChangeActive:(id)sender;

@end
