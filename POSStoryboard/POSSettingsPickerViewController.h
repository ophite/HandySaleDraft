//
//  POSSettingsPickerViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/31/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSHelper.h"
#import "POSSetting.h"
#import "POSObjectsHelper.h"

@interface POSSettingsPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic, retain) NSString *settingValue;
@property (nonatomic, retain) NSString *settingName;
@property (strong, nonatomic) NSDictionary *pickerDict;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;


- (IBAction)onSelect:(id)sender;


@end
