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
@synthesize buttonName = _buttonName;
@synthesize swithIsActive = _swithIsActive;


#pragma mark - ViewController

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
    self.buttonName.layer.cornerRadius = 5;
    self.buttonName.clipsToBounds = YES;
    
    POSSetting *setting = [POSSetting getSetting: objectsHelperInstance.dataSet.settings
                                        withName: helperInstance.SETTING_TEXTFIELD_FONT_COLOR];
    [helperInstance setButtonFontColor:self.buttonName withSetting:setting];

    // Configure the view for the selected state
}


@end
