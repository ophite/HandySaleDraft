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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textEmail.delegate = self;
    self.textPassword.delegate = self;
    self.textPassword2.delegate = self;

	// Do any additional setup after loading the view.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCreate:(id)sender
{
    if(![self.textPassword.text isEqualToString:@""] && [self.textPassword.text isEqualToString:self.textPassword2.text] &&
       [[POSDBHelper getInstance] registerNewUser:self.textEmail.text p_password:self.textPassword.text])
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        [self.textEmail setText:@""];
        [self.textPassword setText:@""];
        [self.textPassword2 setText:@""];
    }
}


/*
 * Create new user
 */
-(BOOL) registerNewUser
{
    BOOL isRegistered = NO;
    POSDBWrapper * dbWrapper = [POSDBWrapper getInstance];
    
    if ([dbWrapper openDB])
    {
        NSString * query = [NSString stringWithFormat:@"INSERT INTO USER (email, password) VALUES (\"%@\", \"%@\")", self.textEmail.text, self.textPassword.text];
        isRegistered = [dbWrapper tryExecQuery:query];
        
        [dbWrapper closeDB];
    }
    
    return isRegistered;
}


@end
