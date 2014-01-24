//
//  POSSettingsGUIHelper.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSSettingsGUIHelper.h"

@implementation POSSettingsGUIHelper


#pragma mark - Singleton

+ (POSSettingsGUIHelper *)getInstance {
    
    static POSSettingsGUIHelper *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[POSSettingsGUIHelper alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - POSSetting object

- (void)setButtonFontColor:(UIButton *)button withSetting:(POSSetting *)setting {
    
    UIColor *color = [UIColor colorWithCIColor:[CIColor colorWithString:setting.value]];
    color = [UIColor colorWithCGColor:color.CGColor];
    [button setTintColor:color];
    [button setTitleColor:color forState:UIControlStateNormal];
}


#pragma mark - DataSet methods

- (void)loadTextFieldBorderColorSetting:(UIColor *)color {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_TEXTFIELD_BORDER_COLOR];
    [objectsHelperInstance.dataSet settingsUpdate: setting withValue: [CIColor colorWithCGColor:color.CGColor].stringRepresentation];
}


- (void)setTextFieldBorderColorBySetting:(UITextField *)textField {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_TEXTFIELD_BORDER_COLOR];
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor colorWithCIColor:[CIColor colorWithString:setting.value]].CGColor;
}


- (void)loadTextFieldFontColorSetting:(UIColor *)color {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_TEXTFIELD_FONT_COLOR];
    [objectsHelperInstance.dataSet settingsUpdate: setting withValue: [CIColor colorWithCGColor:color.CGColor].stringRepresentation];
}


- (void)setTextFieldFontColorBySetting:(UITextField *)textField {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_TEXTFIELD_FONT_COLOR];
    UIColor *color = [UIColor colorWithCIColor:[CIColor colorWithString:setting.value]];
    color = [UIColor colorWithCGColor:color.CGColor];
    [textField setTextColor:color];
}


- (void)loadButtonBackgroundColorSetting:(UIColor *)color {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_BUTTON_BACKGROUND_COLOR];
    [objectsHelperInstance.dataSet settingsUpdate: setting withValue: [CIColor colorWithCGColor:color.CGColor].stringRepresentation];
}


- (void)setButtonBackgroundColorBySetting:(UIButton *)button {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_BUTTON_BACKGROUND_COLOR];
    button.layer.backgroundColor = [UIColor colorWithCIColor:[CIColor colorWithString:setting.value]].CGColor;
}


- (void)loadButtonFontColorSetting:(UIColor *)color {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_BUTTON_FONT_COLOR];
    [objectsHelperInstance.dataSet settingsUpdate: setting withValue: [CIColor colorWithCGColor:color.CGColor].stringRepresentation];
    
}


- (void)setButtonFontColorBySetting:(UIButton *)button {
    
    POSSetting *setting = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_BUTTON_FONT_COLOR];
    [self setButtonFontColor:button withSetting:setting];
}


@end