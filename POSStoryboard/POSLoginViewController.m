//
//  POSLoginViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/6/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSLoginViewController.h"


@interface POSLoginViewController ()

@end


@implementation POSLoginViewController


@synthesize textEmail = _textEmail;
@synthesize textPassword = _textPassword;


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
    
    self.textEmail.delegate = self;
    self.textPassword.delegate = self;

    POSTest* test = [[POSTest alloc] init];
    [test initDBStructure];
    [test initDBData:objectsHelperInstance.dataSet];
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


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"goToLoginSegue"]) {
        
        BOOL isLogged = NO;
        
        if (![self.textEmail.text isEqualToString:@""] &&
            ![self.textPassword.text isEqualToString:@""]) {
            
            isLogged =[self isUserHasCorrectPassword];
        }
        
        if (!isLogged) {
            
            [self.textEmail setText:@""];
            [self.textPassword setText:@""];
        }
       
        return isLogged;
    }
    
    return YES;
}


#pragma mark - Methods

/*
 * Check if user has correct pass
 */
- (BOOL)isUserHasCorrectPassword {
    
    BOOL isLogged = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString* passStr;
        NSString* query = [NSString stringWithFormat: @"SELECT password FROM user WHERE email=\"%@\"", self.textEmail.text];
        
        if ([dbWrapperInstance tryExecQueryResultText:query p_index:0
                                             p_result:&passStr] == YES) {
            
            if([passStr isEqualToString:self.textPassword.text])
                isLogged = YES;
        }
        
        [dbWrapperInstance closeDB];
    }
    
    return isLogged;
}



//-(BOOL) login
//{
//    /*
//     url            = [NSURL URLWithString:@"http://goods.itvik.com/api/login/"];
//     requestString  = [NSString stringWithFormat:@"email=%@&password=%@", name, pass];
//     requestData    = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//     requestLength  = [NSString stringWithFormat:@"%d", [requestData length]];
//     request        = [[NSMutableURLRequest alloc] init];
//
//     [request setURL:url];
//     [request setHTTPMethod:@"POST"];
//     [request setValue:requestLength forHTTPHeaderField:@"Content-Length"];
//     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//     [request setHTTPBody:requestData];
//
//     //connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//     //[connection start];
//
//     responseData        = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//     //responseString    = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//     responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//
//     isLoggedIn          = [[responseDictionary objectForKey:@"success"] boolValue];
//     token               = (NSString *) [responseDictionary objectForKey:@"token"];
//     */
//}


@end
