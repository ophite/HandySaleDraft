//
//  POSAttributeEditStaticCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSAttribute.h"
#import "POSHelper.h"

@interface POSAttributeEditStaticCell : UITableViewCell <UITextFieldDelegate>


@property POSAttribute *attribute;


@property (weak, nonatomic) IBOutlet UILabel *labelAttributeNameTitle;
@property (weak, nonatomic) IBOutlet UITextField *textAttributeName;
@property (weak, nonatomic) IBOutlet UIView *viewTextName;


@end
