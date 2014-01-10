//
//  POSEditAttributeDynamicCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSAttributeValue.h"
#import "POSHelper.h"


@interface POSEditAttributeDynamicCell : UITableViewCell <UITextFieldDelegate>


@property POSAttributeValue *attrValue;
@property (weak, nonatomic) IBOutlet UITextField *textAttributeValue;
@property (weak, nonatomic) IBOutlet UIView *viewTextAttrValueTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;


+(NSInteger) TextAttributeTAG;


@end
