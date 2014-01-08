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
    
    int count = 0;
    NSMutableString * query;
    
    if ([dbWrapperInstance openDB]) {
        // valid user+email
        query = [NSMutableString stringWithFormat:@"select  count(*) \
                                                    from    user \
                                                    where   email = \"%@\"; ", self.textEmail.text];
        count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        [dbWrapperInstance closeDB];
    }
    
    if (count == 0) {
        
        NSString* question = [NSString stringWithFormat:@"User with email %@ not registered?", self.textEmail.text];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Email not registered"
                                                        message: question
                                                       delegate: self
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil, nil];
        [alert show];
    }
    else {
        
        NSString *password;
        query = [NSMutableString stringWithFormat:@"select  password \
                                                    from    user \
                                                    where   email = \"%@\"; ", self.textEmail.text];
        
        if ([dbWrapperInstance openDB]) {
            
            [dbWrapperInstance tryExecQueryResultText: query
                                             andIndex: 0
                                            andResult: &password];
            [dbWrapperInstance closeDB];
        }

        if (password != Nil && password.length > 0 && [MFMailComposeViewController canSendMail]) {
                
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setMailComposeDelegate:self];
            [mailController setToRecipients:@[self.textEmail.text]];
            [mailController setSubject:@"POS password remind"];
            
            NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
            [messageBody appendFormat:@"<b>"];
            [messageBody appendFormat:@"Your password:%@", password];
            [messageBody appendFormat:@"</b>"];
            [messageBody appendFormat:@"</body></html>"];
            [mailController setMessageBody:messageBody isHTML:YES];
            
            [self presentViewController:mailController animated:YES completion:nil];
        }
    }
}


#pragma mark Email

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultSaved:
            break;

        case MFMailComposeResultSent: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Result mail sent"
                                                            message: @"Mail Sent Successfully"
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
            break;
        
        case MFMailComposeResultFailed: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Result mail sent"
                                                            message: @"Error. Mail not sent"
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
            break;
        
        default:
            break;
    }
    
    void(^blockCompleteMail)() = ^() {
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    [self dismissViewControllerAnimated:YES completion:blockCompleteMail];
}


#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqual: @"Email not registered"]) {

    }else if ([alertView.title isEqualToString:@"Result mail sent"]){
        
    }
}

@end
