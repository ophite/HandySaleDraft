//
//  POSRegisterViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/6/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSRegisterViewController.h"


@interface POSRegisterViewController ()

@end


@implementation POSRegisterViewController


@synthesize textEmail = _textEmail;
@synthesize textPassword = _textPassword;
@synthesize textPassword2 = _textPassword2;


#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // gui
    self.textEmail.delegate = self;
    self.textPassword.delegate = self;
    self.textPassword2.delegate = self;
    
    [self initControlsLayers];

	// Do any additional setup after loading the view.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (BOOL)isRegisterNewUser {
    
    BOOL isRegistered = NO;
    
    if (![helperInstance isValidEmail:self.textEmail.text]) {
        // valid email
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Email not correct"
                                                        message: @"You entered not valid email"
                                                       delegate: self
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil, nil];
        [alert show];
    }
    else if ([self.textPassword.text isEqualToString:@""] || [self.textPassword2.text isEqualToString:@""]) {
        // valid password
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Password not correct"
                                                        message: @"You did not entered passwords"
                                                       delegate: self
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil, nil];
        [alert show];
    }
    else if (![self.textPassword.text isEqualToString:self.textPassword2.text]) {
        // valid password
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Password not correct"
                                                        message: @"Your passwords not equils"
                                                       delegate: self
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil, nil];
        [alert show];
    }
    else if ([dbWrapperInstance openDB]) {
        
        // valid user+email
        NSString * query = [NSString stringWithFormat:@"select  count(*) \
                            from    user \
                            where   email = \"%@\"; ", self.textEmail.text];
        int count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        [dbWrapperInstance closeDB];
        
        if (count > 0) {
            
            NSString* question = [NSString stringWithFormat:@"User with email %@ already exist?", self.textEmail.text];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Email exist"
                                                            message: question
                                                           delegate: self
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
        else {
            
            if ([dbWrapperInstance openDB]) {
                
                NSString *query = [NSString stringWithFormat: @"insert into user(email, password) \
                                   values(\"%@\", \"%@\"); ", self.textEmail.text, self.textPassword.text];
                isRegistered = [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
            }
        }
    }
    
    return isRegistered;
}


- (void)initControlsLayers {
    
    [helperInstance setTextFieldBorderColorBySetting:self.textEmail];
    [helperInstance setTextFieldFontColorBySetting:self.textEmail];
    [helperInstance setTextFieldBorderColorBySetting:self.textPassword];
    [helperInstance setTextFieldFontColorBySetting:self.textPassword];
    [helperInstance setTextFieldBorderColorBySetting:self.textPassword2];
    [helperInstance setTextFieldFontColorBySetting:self.textPassword2];
}


#pragma mark - Action

- (IBAction)onCreate:(id)sender {
    
    if([self isRegisterNewUser]) {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqual: @"Email exist"]) {
        
    } else if ([alertView.title isEqual: @"Email not correct"]) {
        
    }
}


@end
