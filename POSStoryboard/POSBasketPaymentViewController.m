//
//  POSBasketPaymentViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/23/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSBasketPaymentViewController.h"


@interface POSBasketPaymentViewController ()

@end


@implementation POSBasketPaymentViewController


@synthesize paydAmount = _paydAmount;
@synthesize unpaydAmount = _unpaydAmount;

@synthesize buttonPay = _buttonPay;
@synthesize textFieldIUnpaidAmount = _textFieldIUnpaidAmount;
@synthesize labelCurrency = _labelCurrency;
@synthesize labelPaid = _labelPaid;
@synthesize labelPaidAmount = _labelPaidAmount;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    // init data
    self.textFieldIUnpaidAmount.text = [NSString stringWithFormat:@"%.2f", self.unpaydAmount];
    self.labelCurrency.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_CURRENCY];
    self.labelPaidAmount.text = [NSString stringWithFormat:@"%.2f", self.paydAmount];
    
    // gui
    [self initControlsLayers];
    
    if (self.paydAmount > 0) {
        
        self.labelPaid.hidden = NO;
        self.labelCurrency.hidden = NO;
        self.labelPaidAmount.hidden = NO;
    }
    else {
        
        self.labelPaid.hidden = YES;
        self.labelCurrency.hidden = YES;
        self.labelPaidAmount.hidden = YES;
    }
        
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if ([alertView.title isEqual: @"Announcement"] && buttonIndex == 0) {
        
    }
}


#pragma mark - Methods

- (void)initControlsLayers {
    
    [helperInstance setButtonShadow:self.buttonPay withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonPay];
    [helperInstance setButtonFontColorBySetting:self.buttonPay];
}


#pragma mark - Actions

- (IBAction)onPay:(id)sender {
    
    if (self.textFieldIUnpaidAmount.text.floatValue > self.unpaydAmount) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                            message: @"You entered amount more then you need!"
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
    }
    else {
        
        if (self.textFieldIUnpaidAmount.text.floatValue > 0) {
            
            float paidPrice = self.paydAmount + self.textFieldIUnpaidAmount.text.floatValue;
            [objectsHelperInstance.dataSet basketsUpdate:objectsHelperInstance.currentBasketID withPaidPrice:paidPrice];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
