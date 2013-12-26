//
//  POSEditAttributeDynamicCell.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSEditAttributeDynamicCell.h"


@implementation POSEditAttributeDynamicCell


@synthesize textAttributeValue = _textAttributeValue;
@synthesize labelAttributeValueTitle = _labelAttributeValueTitle;
@synthesize viewTextAttrValueTitle = _viewTextAttrValueTitle;
@synthesize attrValue = _attrValue;


#pragma mark - Standart

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.textAttributeValue.delegate = self;
    self.viewTextAttrValueTitle.layer.cornerRadius = 5;
    self.viewTextAttrValueTitle.clipsToBounds = YES;
    
    self.textAttributeValue.backgroundColor = [UIColor whiteColor];
    self.textAttributeValue.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.textAttributeValue.leftViewMode = UITextFieldViewModeAlways;
    self.textAttributeValue.delegate = self;
    self.textAttributeValue.text = self.attrValue ? self.attrValue.name : @"";

    // Configure the view for the selected state
}

@end
