//
//  POSOrderFirstCell_Mode.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/28/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import "POSOrderFirstCell_Mode.h"

@implementation POSOrderFirstCell_Mode

@synthesize segment = _segment;



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
    
    [self.segment setSelectedSegmentIndex: objectsHelperInstance.currentBasketsMode];

    // Configure the view for the selected state
}

@end
