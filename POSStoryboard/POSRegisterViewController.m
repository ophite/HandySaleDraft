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


/*
 * ViewController
 */
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
    self.textPassword.delegate = self;
    self.textPassword2.delegate = self;

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


/*
 * Action
 */
- (IBAction)onCreate:(id)sender {
    
    if(![self.textPassword.text isEqualToString:@""] && [self.textPassword.text isEqualToString:self.textPassword2.text] &&
       [self registerNewUser])
        [self.navigationController popViewControllerAnimated:YES];
    else {
        
        [self.textEmail setText:@""];
        [self.textPassword setText:@""];
        [self.textPassword2 setText:@""];
    }
}


/*
 * Create new user
 */
- (BOOL)registerNewUser {
    
    BOOL isRegistered = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString * query = [NSString stringWithFormat:@"INSERT INTO USER (email, password) VALUES (\"%@\", \"%@\")", self.textEmail.text, self.textPassword.text];
        isRegistered = [dbWrapperInstance tryExecQuery:query];
        
        [dbWrapperInstance closeDB];
    }
    
    return isRegistered;
}


@end
