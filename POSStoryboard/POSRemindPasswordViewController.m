//
//  POSRemindPasswordViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/3/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "POSRemindPasswordViewController.h"


@interface POSRemindPasswordViewController ()

@end


@implementation POSRemindPasswordViewController


@synthesize textEmail = _textEmail;


#pragma mark - Standart

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.textEmail.delegate = self;
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Actions

- (IBAction)onResetPassword:(id)sender {
    
    NSString *password;
    NSString *query = [NSString stringWithFormat:@"select   password \
                                                   from     user \
                                                   where    email = \"%@\"; ", self.textEmail.text];
    
    [dbWrapperInstance openDB];
    [dbWrapperInstance tryExecQueryResultText: query
                                     andIndex: 0
                                    andResult: &password];
    [dbWrapperInstance closeDB];
    
    if (password != Nil && password.length > 0) {
        
        if([MFMailComposeViewController canSendMail]) {
        
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"POS password remind"];

            NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
            [messageBody appendFormat:@"<b>"];
            [messageBody appendFormat:@"Your password:%@", password];
            [messageBody appendFormat:@"</b>"];
            [messageBody appendFormat:@"</body></html>"];
            [mailCont setMessageBody:messageBody isHTML:YES];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }

//    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
