//
//  POSSetCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/18/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSItem.h"

@interface POSSetCatViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property int initRow;
@property int exitRow;
@property POSItem *item;
@property (strong, nonatomic) NSMutableArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)onOk:(id)sender;

@end
