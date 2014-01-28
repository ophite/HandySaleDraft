//
//  POSOrderThirdCell_Detail.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import "POSOrderThirdCell_Detail.h"
 
@implementation POSOrderThirdCell_Detail


@synthesize objectsArray = _objectsArray;
@synthesize titleValue = _titleValue;
@synthesize labelTitle = _labelTitle;
@synthesize tableDetail = _tableDetail;
@synthesize viewFirstGrey = _viewFirstGrey;
@synthesize viewSecondWhite = _viewSecondWhite;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.tableDetail.delegate = self;
        self.tableDetail.dataSource = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // init data
    self.labelTitle.text = self.titleValue;

    // gui
    self.tableDetail.delegate = self;
    self.tableDetail.dataSource = self;
    self.tableDetail.scrollEnabled = NO;
    
    CGFloat heightDiff = 0;
    
    CGRect frame = self.tableDetail.frame;
    frame.size.height = frame.size.height * (self.objectsArray.count > 0 ? self.objectsArray.count : 1);
    heightDiff = frame.size.height - self.tableDetail.frame.size.height;
    self.tableDetail.frame = frame;
    
    frame = self.viewFirstGrey.frame;
    frame.size.height = frame.size.height + heightDiff;
    self.viewFirstGrey.frame = frame;

    frame = self.viewSecondWhite.frame;
    frame.size.height = frame.size.height + heightDiff;
    self.viewSecondWhite.frame = frame;
    
    // Configure the view for the selected state
}


#pragma mark - GridView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.objectsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"POSOrderDetailEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    POSBasket *basket = (POSBasket *)[self.objectsArray objectAtIndex:indexPath.row];
    POSOrderDetailEditCell *dynamicCell = (POSOrderDetailEditCell *)cell;
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 1
    dynamicCell.labelOrder.text = objectsHelperInstance.currentBasketsMode == BASKETS_MODE_CLIENT? [NSString stringWithFormat:@"№%d", basket.ID] : basket.client; //TODO: сделать поле номер заказа
    // 2
    NSDate *date = [helperInstance convertStringToDateTo:basket.tst];
    NSString *dateStr = [helperInstance convertDateToStringShort:date];
    dynamicCell.labelDate.text = objectsHelperInstance.currentBasketsMode == BASKETS_MODE_CLIENT? dateStr : [NSString stringWithFormat:@"№%d", basket.ID];
    // 3
    NSString *currency = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_CURRENCY];
    dynamicCell.labelSum.text = [NSString stringWithFormat:@"%@ %@", basket.price, currency];
    
    return dynamicCell;
}


@end
