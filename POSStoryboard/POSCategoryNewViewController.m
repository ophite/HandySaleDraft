//
//  POSCategoryNewViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSCategoryNewViewController.h"


@interface POSCategoryNewViewController ()

@end


@implementation POSCategoryNewViewController


@synthesize textName = _textName;
@synthesize textImageName = _textImageName;


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
    self.textName.delegate = self;
    self.textImageName.delegate = self;
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Methods

- (BOOL)createdNewCategory {
    
    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString * query = [NSString stringWithFormat:@"SELECT  count(*) \
                                                        FROM    collection \
                                                        WHERE   name = \"%@\" AND user_id = \"%d\"", [self.textName text], 1];
        int count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        if(count != 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message: @"The category already exists. Select another name"
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            query = [NSString stringWithFormat:@"INSERT INTO collection (name, user_id) \
                                                 VALUES (\"%@\", %d)", [self.textName text], 1];
            [dbWrapperInstance tryExecQuery:query];
            [dbWrapperInstance closeDB];
            
            POSCategory* catObject = [[POSCategory alloc] init];
            catObject.name = [self.textName text];
            [objectsHelperInstance.dataSet.categories addObject:catObject];
        }
    }
    
    return result;
}


#pragma mark - Actions

- (IBAction)onCreate:(id)sender {
    
    if ([self createdNewCategory])
        [self.navigationController popToRootViewControllerAnimated:YES];
    else {
        
        [self.textName setText:@""];
        [self.textImageName setText:@""];
    }
}


@end
