//
//  POSBasketEditDynamicCell.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/21/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSBasketEditDynamicCell.h"

@implementation POSBasketEditDynamicCell

@synthesize item = _item;
@synthesize order = _order;

@synthesize labelDescription = _labelDescription;
@synthesize labelAttribute1 = _labelAttribute1;
@synthesize labelAttribute1Value = _labelAttribute1Value;
@synthesize labelAttribute2 = _labelAttribute2;
@synthesize labelAttribute2Value = _labelAttribute2Value;
@synthesize labelPrice = _labelPrice;
@synthesize labelPriceValue = _labelPriceValue;
@synthesize labelPriceCurrency = _labelPriceCurrency;
@synthesize labelCount = _labelCount;
@synthesize labelCountLabel = _labelCountLabel;
@synthesize labelFullPrice = _labelFullPrice;
@synthesize labelFullPriceCurrency = _labelFullPriceCurrency;
@synthesize labelRowIndex = _labelRowIndex;


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
    
    self.labelDescription.text = self.item.description;
    // TODO: item with attributes link
//    self.labelAttribute1.text = @"attr1";
//    self.labelAttribute1Value.text = @"attr1 value";
//    self.labelAttribute2.text = @"attr2";
//    self.labelAttribute2Value.text = @"attr2 value";

    self.labelPrice.text = @"Price:";
    self.labelPriceValue.text = [helperInstance convertFloatToStringWithFormat2SignIfNeed:self.item.price_sale];
    self.labelPriceCurrency.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_CURRENCY];

    self.labelCount.text = self.order.quantity;
    self.labelCountLabel.text = @"pcs";
    
    NSString *priceValue = [NSNumber numberWithFloat:(float)(self.order.quantity.intValue * self.order.price.floatValue)].stringValue;
    self.labelFullPrice.text = [NSString stringWithFormat:@"- %@", [helperInstance convertFloatToStringWithFormat2SignIfNeed:priceValue]];
    self.labelFullPriceCurrency.text = self.labelPriceCurrency.text;

    // Configure the view for the selected state
}

@end
