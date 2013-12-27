//
//  POSEditAttribiuteStaticCell.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSEditAttributeStaticCell.h"

@implementation POSEditAttributeStaticCell


@synthesize textAttributeName = _textAttributeName;
@synthesize viewTextName = _viewTextName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.viewTextName.layer.cornerRadius = 5;
    self.viewTextName.clipsToBounds = YES;

    self.textAttributeName.delegate = self;
    self.textAttributeName.backgroundColor = [UIColor whiteColor];
    self.textAttributeName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.textAttributeName.leftViewMode = UITextFieldViewModeAlways;
    self.textAttributeName.text = self.attribute ? self.attribute.name : @"";

    // Configure the view for the selected state
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


@end
