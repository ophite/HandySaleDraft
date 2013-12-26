//
//  POSAttributeCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface POSAttributeCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIButton *buttonDelete;
@property (nonatomic, weak) IBOutlet UIButton *buttonName;
@property (nonatomic, weak) IBOutlet UISwitch *swithIsActive;


@end
