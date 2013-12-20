//
//  POSEditCatViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSEditCatViewController.h"
#import "POSDBWrapper.h"
#import "POSObjectsHelper.h"

@interface POSEditCatViewController ()

@end

@implementation POSEditCatViewController

@synthesize cat = _cat;
@synthesize textName = _textName;
@synthesize imageView = _imageView;
@synthesize oldName = _oldName;


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
    self.oldName = self.cat.name;
    self.imageView.image = self.cat.image;
    [self.textName setReturnKeyType:UIReturnKeyDone];
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Code here to work with media
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    
    if ([alertView.title isEqual: @"Select source"] && buttonIndex == 0) {
        
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController: controller
                           animated: YES
                         completion: nil];
    }
    else {
        
        if ([alertView.title isEqual: @"Select source"] && buttonIndex == 1) {
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController: controller
                               animated: YES
                             completion: nil];
        }
        else if ([alertView.title isEqual: @"Delete"]) {
            
            NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
            
            if([title isEqualToString:@"No"]) {
                
            }
            else if ([dbWrapperInstance openDB]) {
                
                NSString * query = [NSString stringWithFormat:@"DELETE  \
                                                                FROM    collection \
                                                                WHERE   name = \"%@\" AND user_id = %d", self.cat.name, 1];
                [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
                
                [objectsHelperInstance.dataSet.categories removeObjectAtIndex:objectsHelperInstance.currentCatIndex];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


#pragma mark -  Actions

- (IBAction)onSave:(id)sender {
    
    self.cat.name = self.textName.text;
    self.cat.image = self.imageView.image;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = [NSString stringWithFormat:@"SELECT  count(*) \
                                                    FROM    collection \
                                                    WHERE   name = \"%@\" AND user_id = \"%d\"", self.cat.name, 1];
    
    int count = [dbWrapperInstance execQueryResultInt:query p_index:0];
    
    if(count != 0 && ![self.cat.name isEqualToString:oldName]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The category already exists. Select another name"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    NSString* random_name = [[NSUUID UUID] UUIDString];
    
    query = [NSString stringWithFormat:@"UPDATE collection SET name = \"%@\" WHERE id = %d; ", self.cat.name, self.cat.ID];
    query = [query stringByAppendingFormat:@"DELETE FROM image WHERE object_id = %d AND object_name = \"collection\"; ", self.cat.ID];
    query = [query stringByAppendingFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) \
                                             VALUES (\"%@\", \"%@\", %d, \"collection\", 1);", random_name, random_name, self.cat.ID];

    [dbWrapperInstance tryExecQuery:query];
    [dbWrapperInstance closeDB];
    
    POSImage * image = [[POSImage alloc] initWithImage: cat.image
                                             withAsset: nil
                                              withPath: random_name
                                         withObject_id: self.cat.ID
                                       withObject_name: @"collection"];
    [objectsHelperInstance.dataSet.images addObject:image];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [objectsHelperInstance.dataSet saveGallery:(objectsHelperInstance.dataSet.images.count - 1) withLibrary:library];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onSelectImage:(id)sender {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Select source"
                                                        message: @"Please select image source"
                                                       delegate: self
                                              cancelButtonTitle: @"Library"
                                              otherButtonTitles: @"Camera", nil];
	[alertView show];
}


- (IBAction)onDelete:(id)sender {
    
    NSString* question = [NSString stringWithFormat:@"Delete the %@ category?", self.textName.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Delete"
                                                    message: question
                                                   delegate: self
                                          cancelButtonTitle: @"Yes"
                                          otherButtonTitles: @"No", nil];
    [alert show];
}


@end
