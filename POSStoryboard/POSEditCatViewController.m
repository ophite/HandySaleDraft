//
//  POSEditCatViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSEditCatViewController.h"


@interface POSEditCatViewController ()

@end


@implementation POSEditCatViewController

@synthesize cat = _cat;
@synthesize textName = _textName;
@synthesize oldName = _oldName;
@synthesize buttonSave = _buttonSave;
@synthesize viewForColorExample = _viewForColorExample;

@synthesize viewMain = _viewMain;
@synthesize scrollView = _scrollView;
@synthesize viewScroll = _viewScroll;
@synthesize viewImage = _viewImage;
@synthesize imageView = _imageView;
@synthesize viewButtons = _viewButtons;


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
    // init data
    self.oldName = self.cat.name;
    self.imageView.image = self.cat.image;
    self.textName.text = self.cat.name;
    
    // gui
    [self initControlsLayers];
    
    // scrolling
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];
    [self.scrollView setContentSize:self.viewScroll.frame.size];
    
    // image touch event
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(onSelectImage:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [self.imageView addGestureRecognizer:tapRecognizer];

    self.viewMain.userInteractionEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.viewScroll.userInteractionEnabled = YES;
    self.viewImage.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    self.viewButtons.userInteractionEnabled = YES;
    
    // button shadow
    [helperInstance setButtonShadow:self.buttonSave withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    
    // other
    self.buttonSave.layer.cornerRadius = 15;
    self.imageView.layer.cornerRadius = 10;
    self.viewImage.layer.cornerRadius = 10;

    self.textName.delegate = self;
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


#pragma mark - Methods

- (void)initControlsLayers {
    
    [helperInstance setTextFieldBorderColorBySetting: self.textName];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonSave];
    [helperInstance setButtonFontColorBySetting:self.buttonSave];
    [helperInstance setTextFieldFontColorBySetting:self.textName];
}


#pragma mark -  Actions

- (IBAction)onSelectCategory2:(id)sender {
}

- (IBAction)onSelectCategory1:(id)sender {
}

- (IBAction)onSave:(id)sender {
    
    self.cat.name = self.textName.text;
    self.cat.image = self.imageView.image;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = [NSString stringWithFormat:@"SELECT  count(*) \
                                                    FROM    collection \
                                                    WHERE   name = \"%@\" AND user_id = \"%d\"", self.cat.name, 1];
    
    int count = [dbWrapperInstance execQueryResultInt: query andIndex: 0];
    
    if(count != 0 && ![self.cat.name isEqualToString:self.oldName]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The category already exists. Select another name"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    NSString* random_name = [[NSUUID UUID] UUIDString];
    
    query = [NSString stringWithFormat:@"UPDATE collection \
                                         SET    name = \"%@\" \
                                         WHERE  id = %d; ", self.cat.name, self.cat.ID];
    query = [query stringByAppendingFormat:@"DELETE \
                                             FROM   image \
                                             WHERE  object_id = %d AND object_name = \"collection\"; ", self.cat.ID];
    query = [query stringByAppendingFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) \
                                             VALUES (\"%@\", \"%@\", %d, \"collection\", 1);", random_name, random_name, self.cat.ID];

    [dbWrapperInstance tryExecQuery:query];
    [dbWrapperInstance closeDB];
    
    POSImage * image = [[POSImage alloc] initWithImage: self.cat.image
                                             withAsset: nil
                                              withPath: random_name
                                         withObject_id: self.cat.ID
                                       withObject_name: @"collection"];
    [objectsHelperInstance.dataSet.images addObject:image];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [objectsHelperInstance.dataSet gallerySave:(objectsHelperInstance.dataSet.images.count - 1) withLibrary:library];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onSelectImage:(id)sender {
    
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
