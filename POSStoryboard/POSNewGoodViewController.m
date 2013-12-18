//
//  POSNewGoodViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSNewGoodViewController.h"

@interface POSNewGoodViewController ()

@end

@implementation POSNewGoodViewController

@synthesize textName = _textName;
@synthesize textImageName = _textImageName;


/*
 * ViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


/*
 * Methods
 */
-(BOOL) createdNewGood
{
    BOOL result = NO;
    
    if ([dbWrapperInstance openDB])
    {
        int cat_ID = [[objectsHelperInstance.dataSet.categories objectAtIndex:objectsHelperInstance.currentCatIndex] ID];
        NSString* catName = [[objectsHelperInstance.dataSet.categories objectAtIndex:objectsHelperInstance.currentCatIndex] name];
        NSString * query = [NSString stringWithFormat:@"SELECT count(*) FROM product WHERE name = \"%@\" AND collection_id = \"%d\" AND user_id = \"%d\"", self.textName.text, cat_ID, 1];
        int count = [dbWrapperInstance execQueryResultInt:query p_index:0];
        
        if(count != 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message: @"The good already exists. Select another name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        query = [NSString stringWithFormat:@"INSERT INTO product (name, user_id, collection_id) VALUES (\"%@\", %d, %d)", self.textName.text, 1, cat_ID];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
            
        POSItem* itemObject = [[POSItem alloc] init];
        itemObject.name = self.textName.text;
        itemObject.catID = cat_ID;
        itemObject.category = catName;
        [objectsHelperInstance.dataSet.allItems addObject:itemObject];

        result = YES;
    }
    
    return result;
}


/*
 * Actions
 */
- (IBAction)onCreate:(id)sender
{
    BOOL nameExists = NO;
    BOOL imageExists = YES;
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.categories count]; i++)
    {
        if([self.textName.text isEqualToString:[[objectsHelperInstance.dataSet.categories objectAtIndex:i] name]])
        {
            nameExists = YES;
            break;
        }
    }
    
    if(!imageExists || nameExists)
    {
        if(!imageExists)
            [self.textImageName setText:@""];
        
        if(nameExists)
            [self.textName setText:@""];
        
        return;
    }
    
    if([self createdNewGood])
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        [self.textName setText:@""];
        [self.textImageName setText:@""];
        
        return;
    }
}


@end
