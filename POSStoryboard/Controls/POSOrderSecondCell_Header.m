//
//  POSOrderSecondCell_Header.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/28/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSOrderSecondCell_Header.h"


@implementation POSOrderSecondCell_Header


@synthesize labelDate = _labelDate;
@synthesize labelOrderNumber = _labelOrderNumber;
@synthesize labelSum = _labelSum;


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
    
    self.labelOrderNumber.text = objectsHelperInstance.currentBasketsMode == BASKETS_MODE_CLIENT ? @"Order" : @"Client";
    self.labelDate.text = objectsHelperInstance.currentBasketsMode == BASKETS_MODE_CLIENT ? @"Date" : @"Order";

    // Configure the view for the selected state
}

@end
