//
//  POSAttributeCell.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSAttributeCell.h"


@implementation POSAttributeCell


@synthesize buttonDelete = _buttonDelete;
@synthesize textName = _textName;
@synthesize swithIsActive = _swithIsActive;
@synthesize cellIndex = _cellIndex;


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

    self.textName.delegate = self;
    // Configure the view for the selected state
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


@end
