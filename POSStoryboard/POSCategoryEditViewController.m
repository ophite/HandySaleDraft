//
//  POSCategoryEditViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSCategoryEditViewController.h"


@interface POSCategoryEditViewController ()

@end


@implementation POSCategoryEditViewController

@synthesize category = _category;
@synthesize categoryAttribute1 = _categoryAttribute1;
@synthesize categoryAttribute2 = _categoryAttribute2;
@synthesize oldName = _oldName;

@synthesize labelCategory1 = _labelCategory1;
@synthesize labelCategory2 = _labelCategory2;
@synthesize textName = _textName;
@synthesize buttonSave = _buttonSave;
@synthesize viewForColorExample = _viewForColorExample;

@synthesize viewMain = _viewMain;
@synthesize scrollView = _scrollView;
@synthesize viewScroll = _viewScroll;
@synthesize viewImage = _viewImage;
@synthesize imageView = _imageView;
@synthesize viewButtons = _viewButtons;


// vars
NSString *CATEGORY_EMPTY = @"Select from list";
POSAttribute *_newAttribute1;
POSAttribute *_newAttribute2;
bool _isAttribute1Dirty = NO;
bool _isAttribute2Dirty = NO;
int _isImageDirty = 0;

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
    [objectsHelperInstance.dataSet attributesGet];
    [objectsHelperInstance.dataSet categoriesAttributesGet];
    
    self.oldName = self.category.name;
    self.imageView.image = self.category.image;
    self.textName.text = self.category.name;
    _isImageDirty = 0;
    
    // gui
    [self initControlsLayers];
    [self attributeLoad:0];
    [self attributeLoad:1];
    
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


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"goToAttribute1"]) {
        
        POSSelectAttributeViewController *controller = (POSSelectAttributeViewController *)[segue destinationViewController];
        controller.category = self.category;
        controller.attributeIndex = 0;
        controller.categoryAttribute = self.categoryAttribute1;
    }
    else if ([[segue identifier] isEqualToString:@"goToAttribute2"]) {
        
        POSSelectAttributeViewController *controller = (POSSelectAttributeViewController *)[segue destinationViewController];
        controller.category = self.category;
        controller.attributeIndex = 1;
        controller.categoryAttribute = self.categoryAttribute2;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Code here to work with media
    _isImageDirty++;
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    _isImageDirty--;
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


#pragma mark - Alert

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
                                                                WHERE   name = \"%@\" AND user_id = %d", self.category.name, 1];
                [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
                
                [objectsHelperInstance.dataSet.categories removeObjectAtIndex:objectsHelperInstance.currentCategoryIndex];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


#pragma mark - Methods

- (void)initControlsLayers {
    
    [settingsGUIHelperInstance setTextFieldBorderColorBySetting: self.textName];
    [settingsGUIHelperInstance setButtonBackgroundColorBySetting:self.buttonSave];
    [settingsGUIHelperInstance setButtonFontColorBySetting:self.buttonSave];
    [settingsGUIHelperInstance setTextFieldFontColorBySetting:self.textName];
}


#pragma mark - Attributes

- (void)attributeUpdate:(POSAttribute *)attribute withIndex:(int)index {
    
    switch (index) {
        case 0: {
            
            _isAttribute1Dirty = YES;
            _newAttribute1 = attribute;
            [self.labelCategory1 setText:(_newAttribute1 ?_newAttribute1.name :CATEGORY_EMPTY)];
            break;
        }
        case 1 : {
            
            _isAttribute2Dirty = YES;
            _newAttribute2 = attribute;
            [self.labelCategory2 setText:(_newAttribute2 ?_newAttribute2.name :CATEGORY_EMPTY)];
            break;
        }
            
        default:
            break;
    }
}


- (void)attributeLoad:(int)index {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(categoryID = %d) AND (index = %d)", self.category.ID, index];
    
    switch (index) {
        case 0: {
            _isAttribute1Dirty = NO;
            self.categoryAttribute1 = (POSCategoryAttribute *)[helperInstance getObject: objectsHelperInstance.dataSet.categoriesAttributes
                                                                          withPredicate: predicate];
            [self.labelCategory1 setText:(self.categoryAttribute1 ? self.categoryAttribute1.name : CATEGORY_EMPTY)];
            break;
        }
        case 1 : {
            _isAttribute2Dirty = NO;
            self.categoryAttribute2 = (POSCategoryAttribute *)[helperInstance getObject: objectsHelperInstance.dataSet.categoriesAttributes
                                                                          withPredicate: predicate];
            [self.labelCategory2 setText:(self.categoryAttribute2 ? self.categoryAttribute2.name : CATEGORY_EMPTY)];
            break;
        }
            
        default:
            break;
    }
}


- (void)attributeSave {
    
    if (_isAttribute1Dirty) {
        
        if (_newAttribute1 == nil && self.categoryAttribute1 != nil) {

            [objectsHelperInstance.dataSet categoriesAttributesRemove:self.categoryAttribute1];
        }
        else {
            
            if (_newAttribute1 != nil && _newAttribute1.ID != self.categoryAttribute1.attributeID) {
           
                if (self.categoryAttribute1 != nil)
                    [objectsHelperInstance.dataSet categoriesAttributesUpdate: self.categoryAttribute1
                                                                withAttribute: _newAttribute1];
                else
                    [objectsHelperInstance.dataSet categoriesAttributesCreate: self.category
                                                              withAttributeID: _newAttribute1
                                                                    withIndex: 0];
            }
        }
    }

    if (_isAttribute2Dirty) {
        
        if (_newAttribute2 == nil && self.categoryAttribute2 != nil) {
            
            [objectsHelperInstance.dataSet categoriesAttributesRemove:self.categoryAttribute2];
        }
        else {
                
            if (_newAttribute2 != nil && _newAttribute2.ID != self.categoryAttribute2.attributeID) {
                
                if (self.categoryAttribute2 != nil)
                    [objectsHelperInstance.dataSet categoriesAttributesUpdate: self.categoryAttribute2
                                                                withAttribute: _newAttribute2];
                else
                    [objectsHelperInstance.dataSet categoriesAttributesCreate: self.category
                                                              withAttributeID: _newAttribute2
                                                                    withIndex: 1];
            }
        }
    }
}


#pragma mark -  Actions

- (IBAction)onSave:(id)sender {
    
    self.category.name = self.textName.text;
    self.category.image = self.imageView.image;
    
    // validate
    if (![dbWrapperInstance openDB])
        return;
    
    //TODO: user_id зашита константа пока что
    NSString * query = [NSString stringWithFormat:@"SELECT  count(*) \
                                                    FROM    collection \
                                                    WHERE   name = \"%@\" AND user_id = \"%d\" AND ID != %d; ", self.category.name, 1, self.category.ID];
    
    int count = [dbWrapperInstance execQueryResultInt: query andIndex: 0];
    
    if(count != 0 && ![self.category.name isEqualToString:self.oldName]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The category already exists. Select another name"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    // category (name)
    NSString* random_name = [[NSUUID UUID] UUIDString];
    
    query = [NSString stringWithFormat:@"UPDATE collection \
                                         SET    name = \"%@\" \
                                         WHERE  id = %d; ", self.category.name, self.category.ID];
    
    // image
    if (_isImageDirty > 0) {
        
        query = [query stringByAppendingFormat:@"DELETE \
                                                 FROM   image \
                                                 WHERE  object_id = %d AND object_name = \"collection\" AND is_default = 1; ", self.category.ID];
        
        query = [query stringByAppendingFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) \
                                                 VALUES (\"%@\", \"%@\", %d, \"collection\", 1);", random_name, random_name, self.category.ID];

        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        POSImage * image = [[POSImage alloc] initWithImage: self.category.image
                                                 withAsset: nil
                                                  withPath: random_name
                                             withObject_id: self.category.ID
                                           withObject_name: @"collection"];
        [objectsHelperInstance.dataSet.images addObject:image];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [objectsHelperInstance.dataSet imagesSave:(objectsHelperInstance.dataSet.images.count - 1) withLibrary:library];
    }
    
    // attribute
    [self attributeSave];
    
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
