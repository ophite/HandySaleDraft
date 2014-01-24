//
//  POSSettingsGUIHelper.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "POSObjectsHelper.h"
#import "POSSetting.h"
#import "POSHelper.h"

#define settingsGUIHelperInstance [POSSettingsGUIHelper getInstance]


@interface POSSettingsGUIHelper : NSObject

+ (POSSettingsGUIHelper *)getInstance;

// objects
- (void)setButtonFontColor:(UIButton *)button withSetting:(POSSetting *)setting;

// dataSet methods
- (void)setTextFieldBorderColorBySetting:(UITextField *)textField;
- (void)loadTextFieldBorderColorSetting:(UIColor *)color;

- (void)setTextFieldFontColorBySetting:(UITextField *)textField;
- (void)loadTextFieldFontColorSetting:(UIColor *)color;

- (void)setButtonBackgroundColorBySetting:(UIButton *)button;
- (void)loadButtonBackgroundColorSetting:(UIColor *)color;

- (void)setButtonFontColorBySetting:(UIButton *)button;
- (void)loadButtonFontColorSetting:(UIColor *)color;


@end
