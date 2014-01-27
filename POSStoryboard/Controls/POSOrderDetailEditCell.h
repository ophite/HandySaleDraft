//
//  POSOrderDetailEditCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POSOrderDetailEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelOrder;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSum;

@end
