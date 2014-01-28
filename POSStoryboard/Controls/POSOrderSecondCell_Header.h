//
//  POSOrderSecondCell_Header.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/28/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSObjectsHelper.h"
#import "POSSetting.h"
#import "POSHelper.h"

@interface POSOrderSecondCell_Header : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *labelOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSum;


@end