//
//  POSGridViewCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "AQGridViewCell.h"

@interface POSGridViewCell : AQGridViewCell

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UILabel* captionLabel;


@end
