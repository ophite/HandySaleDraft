//
//  POSEditGoodViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSEditGoodViewController.h"
#import "POSSetCatViewController.h"
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"

@interface POSEditGoodViewController ()

@end

@implementation POSEditGoodViewController


@synthesize item = _item;
@synthesize category = _category;
@synthesize oldName = _oUITextViewldName;
@synthesize textName = _textName;
@synthesize textCategory = _textCategory;
@synthesize textCode = _textCode;
@synthesize textPrice1 = _textPrice1;
@synthesize textPrice2 = _textPrice2;
@synthesize textViewDescription = _textViewDescription;
@synthesize viewContent = _viewContent;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;


#pragma mark - ViewController
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.oldName = self.item.name;
    self.textName.text = self.item.name;
    self.textCategory.text = item.category;
    self.textCode.text = self.item.codeItem;
    self.textPrice1.text = self.item.price1;
    self.textPrice2.text = self.item.price2;
    self.textViewDescription.text = self.item.description;
    
    for(int i = 0; i<self.item.gallery.count; i++) {
        
        UIImageView* localImageView = [[UIImageView alloc] initWithImage:[self.item.gallery objectAtIndex:i]];
        localImageView.frame = CGRectMake(i*180, 0, 177, 180);
        localImageView.backgroundColor = [UIColor whiteColor];
        [self.viewContent addSubview:localImageView];
    }
    
    self.textName.delegate = self;
    self.textCategory.delegate = self;
    self.textCode.delegate = self;
    self.textPrice1.delegate = self;
    self.textPrice2.delegate = self;
    self.textViewDescription.delegate = self;
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.textCategory.text = self.item.category;
}


//TODO
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Code here to work with media
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    
    if ([alertView.title isEqual: @"Delete image"] && buttonIndex == 0) {
        
        
    }
    else {
        
        if ([alertView.title isEqual: @"Delete image"] && buttonIndex == 1) {
            
            int page = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
            [self.item.gallery removeObjectAtIndex:page];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([alertView.title isEqual: @"Delete"]) {
            
                NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
                
                if([title isEqualToString:@"No"]) {
                    
                    
                }
                else if ([dbWrapperInstance openDB]) {
                    
                    NSString * query = [NSString stringWithFormat:@"DELETE \
                                                                    FROM    product \
                                                                    WHERE       name = \"%@\" AND user_id = %d", self.item.name, 1];
                    
                    [dbWrapperInstance tryExecQuery:query];
                    [dbWrapperInstance closeDB];
                    
                    [objectsHelperInstance.dataSet.items removeObjectAtIndex:objectsHelperInstance.currentItemsIndex];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
    }
}


#pragma mark - Actions

- (IBAction)onSave:(id)sender {
    
    int n;
    n = 0;
    
    if([dbWrapperInstance openDB]) {
        
        NSString * query = [NSString stringWithFormat:@"SELECT  id \
                                                        FROM    collection \
                                                        WHERE   name = \"%@\" AND user_id = %d", self.textCategory.text, 1];
        
        int cat_ID = [dbWrapperInstance execQueryResultInt:query p_index:0];
        query = [NSString stringWithFormat:@"SELECT count(*) \
                                             FROM   product \
                                             WHERE  name = \"%@\" AND collection_id = %d AND user_id = %d", self.textName.text, cat_ID, 1];
        n = [dbWrapperInstance execQueryResultInt: query
                                          p_index: 0];
        [dbWrapperInstance closeDB];
    }
    
    
    if(n != 0 && ![self.textName.text isEqualToString:oldName]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The good already exists"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    self.item.name       = self.textName.text;
    //item.image      = imageView.image;
    self.item.category   = self.textCategory.text;
    self.item.codeItem   = self.textCode.text;
    self.item.price1     = self.textPrice1.text;
    self.item.price2     = self.textPrice2.text;
    self.item.description= self.textViewDescription.text;
    self.item.userID     = 1;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString* random_name = [[NSUUID UUID] UUIDString];
    
    NSString * query = [NSString stringWithFormat:@"UPDATE product SET \
                                                     name            = \"%@\", \
                                                     price_buy       = \"%@\", \
                                                     price_sale      = \"%@\", \
                                                     comment         = \"%@\", \
                                                     user_id         = \"%d\", \
                                                     collection_id   = \"%@\"  \
                                                     WHERE id = %d;", self.item.name, self.item.price1, self.item.price2, self.item.description, self.item.userID, self.item.category, self.item.ID];
    
    query = [query stringByAppendingFormat:@"DELETE \
                                             FROM   image \
                                             WHERE  object_id = %d AND object_name = \"product\"; ", self.item.ID];
    query = [query stringByAppendingFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) \
                                             VALUES (\"%@\", \"%@\", %d, \"product\", 1);", random_name, random_name, self.item.ID];
    
    [dbWrapperInstance tryExecQuery:query];
    [dbWrapperInstance closeDB];
    
    POSImage * image = [[POSImage alloc] initWithImage: self.item.image
                                             withAsset: nil
                                              withPath: random_name
                                         withObject_id: self.item.ID
                                       withObject_name: @"product"];
    [objectsHelperInstance.dataSet.images addObject:image];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [objectsHelperInstance.dataSet saveGallery: (objectsHelperInstance.dataSet.images.count - 1)
                                   withLibrary: library];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onSetCategory:(id)sender {
    
    POSSetCatViewController* viewSetCat = [POSSetCatViewController new];
    viewSetCat.title = @"Set category";
    viewSetCat.item = item;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.categories count]; i++) {
        
        NSString* name = [[objectsHelperInstance.dataSet.categories objectAtIndex:i] name];
        [array addObject:name];
        
        if([self.item.category isEqualToString:name])
            viewSetCat.initRow = i;
    }
    
    viewSetCat.pickerData = array;
    [self.navigationController pushViewController: viewSetCat
                                         animated: YES];
}


- (IBAction)onDeleteItem:(id)sender {
    
    NSString* question = [NSString stringWithFormat:@"Delete the %@ good?", self.textName.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Delete"
                                                    message: question
                                                   delegate: self
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Yes", nil];
    [alert show];
}


- (IBAction)onSetImage:(id)sender {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Select source"
                                                        message: @"Please select image source"
                                                       delegate: self
                                              cancelButtonTitle: @"Library"
                                              otherButtonTitles: @"Camera", nil];
	[alertView show];
}


- (IBAction)onDeleteImage:(id)sender {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Delete image"
                                                        message: @"Delete the image?"
                                                       delegate: self
                                              cancelButtonTitle: @"No"
                                              otherButtonTitles: @"Yes", nil];
	[alertView show];
}


@end
