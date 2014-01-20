//
//  POSEditGoodViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSEditGoodViewController.h"


@interface POSEditGoodViewController ()

@end


@implementation POSEditGoodViewController

const int CELL_DESCRIPTION_INDEX = 7;

@synthesize item = _item;
@synthesize category = _category;
@synthesize oldName = _oldName;

@synthesize textName = _textName;
@synthesize labelCode = _labelCode;
@synthesize textCode = _textCode;
@synthesize labelPrice_buy = _labelPrice_buy;
@synthesize textPrice_buy = _textPrice_buy;
@synthesize labelPrice_sale = _labelPrice_sale;
@synthesize textPrice_sale = _textPrice_sale;
@synthesize labelDescription = _labelDescription;
@synthesize textViewDescription = _textViewDescription;
@synthesize buttonCategory = _buttonCategory;

@synthesize scrollView = _scrollView;
@synthesize table = _table;
@synthesize cellCode = _cellCode;
@synthesize cellImage = _cellImage;
@synthesize contentCellImage = _contentCellImage;

NSMutableArray *_galleryTmp;

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
    self.oldName = self.item.name;
    self.textName.text = self.item.name;
    self.textCode.text = self.item.codeItem;
    self.textPrice_buy.text = self.item.price_buy;
    self.textPrice_sale.text = self.item.price_sale;
    self.textViewDescription.text = self.item.description;
    _galleryTmp = [NSMutableArray arrayWithArray:self.item.gallery];
    _isImageButtonsHidden = YES;
    
    // gui
    [self initControlsLayers];

    self.table.allowsSelection = NO;
    self.textName.delegate = self;
    self.textCode.delegate = self;
    self.textPrice_buy.delegate = self;
    self.textPrice_sale.delegate = self;
    self.textViewDescription.delegate = self;
    self.textViewDescription.allowsEditingTextAttributes = YES;
    // margins
    [helperInstance createLeftMarginForTextField:self.textName];
    [helperInstance createLeftMarginForTextField:self.textCode];
    [helperInstance createLeftMarginForTextField:self.textPrice_buy];
    [helperInstance createLeftMarginForTextField:self.textPrice_sale];
    [helperInstance createLeftMarginForLabel:self.labelCode];
    [helperInstance createLeftMarginForLabel:self.labelPrice_buy];
    [helperInstance createLeftMarginForLabel:self.labelPrice_sale];
    [helperInstance createLeftMarginForLabel:self.labelDescription];
    [helperInstance createLeftMarginForTextView:self.textViewDescription];
    //scroll
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];
    
    // images
    self.table.userInteractionEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.cellImage.userInteractionEnabled = YES;
    self.contentCellImage.userInteractionEnabled = YES;

    // image touch event
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(onShowImageButtons:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:tapRecognizer];
    [self createImageGallery];
    
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.buttonCategory setTitle:self.item.category forState:UIControlStateNormal];
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"goToFakeSetCategory"]) {
        
        return NO;
    }
    
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    
    if ([alertView.title isEqual: @"Delete image"] && buttonIndex == 0) {
        
        
    }
    else {
        
        if ([alertView.title isEqual: @"Delete image"] && buttonIndex == 1) {

            if (_galleryTmp.count > 0) {
                
                // remember buttons mode
                for(UIView *subview in [self.scrollView subviews]) {
                    
                    if(subview.tag >= 100) {
                        
                        UIButton *buttonAdd = (UIButton *)[subview.subviews objectAtIndex:0];
                        _isImageButtonsHidden = buttonAdd.hidden;
                        break;
                    }
                }

                [self deleteImageGallery];
                [self createImageGallery];
                [self onShowImageButtons:NULL];
            }
        }
        else if ([alertView.title isEqual: @"Delete"]) {
            
            NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
            
            if([title isEqualToString:@"No"]) {
                
                
            }
            else if ([dbWrapperInstance openDB]) {
                
                NSString * query = [NSString stringWithFormat:@"DELETE  \
                                    FROM    product \
                                    WHERE   name = \"%@\" AND user_id = %d", self.item.name, 1];
                
                [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
                
                [objectsHelperInstance.dataSet.items removeObjectAtIndex:objectsHelperInstance.currentItemsIndex];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if ([alertView.title isEqual: @"Select image"] && buttonIndex == 0) {
            
            [self deleteScrollAddImageButton];
            void(^blockCompleteLoadImage)() = ^(void) {
                
//                controller
            };
            
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController: controller
                               animated: YES
                             completion: blockCompleteLoadImage];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate

//NSMutableArray *_addedGallery;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    POSGallery *newGallery = [[POSGallery alloc] init];
    newGallery.image = image;
    newGallery.asset = nil;
    newGallery.ID = -1;
    newGallery.imageID = -1;
    newGallery.productID = self.item.ID;
    
    [_galleryTmp addObject:newGallery];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _galleryTmp.count,
                                             self.scrollView.frame.size.height);
    [self addImageToScrollView:image withIndex:_galleryTmp.count - 1];

    // Code here to work with media
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


#pragma mark - Image buttons

- (void)deleteImageGallery {
    
    int page = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    [_galleryTmp removeObjectAtIndex:page];
    
    for(UIView *subview in [self.scrollView subviews]) {
        
        if(subview.tag >= 100)
            [subview removeFromSuperview];
    }
}


- (void)createImageGallery {
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _galleryTmp.count,
                                             self.scrollView.frame.size.height);
    
    for(int i = 0; i<_galleryTmp.count; i++) {
        
        POSGallery *gallery = (POSGallery *)[_galleryTmp objectAtIndex:i];
        [self addImageToScrollView:gallery.image withIndex:i];
    }
}

- (void)addImageToScrollView:(UIImage *)image withIndex:(int)index {
    
    _isImageButtonsHidden = NO;
    UIImageView* localImageView = [[UIImageView alloc] initWithImage:image];
    localImageView.frame = CGRectMake(index*self.scrollView.frame.size.width,
                                      0,
                                      self.scrollView.frame.size.width,
                                      self.scrollView.frame.size.height);
    //        localImageView.backgroundColor = [UIColor whiteColor];
    localImageView.backgroundColor = self.cellCode.backgroundColor;
    localImageView.contentMode = UIViewContentModeScaleAspectFit;
    localImageView.clipsToBounds = YES;
    localImageView.userInteractionEnabled = YES;
    localImageView.tag = index + 100;
    [self createAddBttonToImage:localImageView];
    [self createDeleteBttonToImage:localImageView];
    [self.scrollView addSubview:localImageView];
}

- (void)createAddBttonToImage:(UIImageView *)imageView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:helperInstance.SETTING_ADDATTRIBUTE_ICON];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget: self
               action: @selector(onAddImage:)
     forControlEvents: UIControlEventTouchUpInside];
    button.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    button.hidden = _isImageButtonsHidden;
    [imageView addSubview:button];
}


- (void)createDeleteBttonToImage:(UIImageView *)imageView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:helperInstance.SETTING_DELETEATTRIBUTE_ICON];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(40.0, 0.0, 40.0, 40.0);
    [button addTarget: self
               action: @selector(onDeleteImage:)
     forControlEvents: UIControlEventTouchUpInside];
    button.hidden = _isImageButtonsHidden;
    [imageView addSubview:button];
}


bool _isImageButtonsHidden = YES;

- (void)onShowImageButtons:(id)sender {
    
    _isImageButtonsHidden = _galleryTmp.count == 0? YES:NO;
    
    if (_galleryTmp.count > 0) {
        
        for (int i =0; i<_galleryTmp.count; i++) {

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag = %d", i + 100];
            NSObject *object = [helperInstance getObjectImmutableArray:self.scrollView.subviews withPredicate:predicate];
            UIImageView *imageView = (UIImageView *)object;
            
            UIButton *buttonAdd = (UIButton *)[imageView.subviews objectAtIndex:0];
            buttonAdd.hidden = (!buttonAdd.hidden || _isImageButtonsHidden);
            UIButton *buttonDelete = (UIButton *)[imageView.subviews objectAtIndex:1];
            buttonDelete.hidden = (!buttonDelete.hidden || _isImageButtonsHidden);
        }
    }
    else {
        
        bool isAlreadtAddedButton = NO;
        for (UIView *subview in self.scrollView.subviews) {
            
            if (subview.tag == 99) {
                
                isAlreadtAddedButton = YES;
                break;
            }
        }
        
        if (!isAlreadtAddedButton) {
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 1,
                                                     self.scrollView.frame.size.height);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *image = [UIImage imageNamed:helperInstance.SETTING_ADDATTRIBUTE_ICON];
            [button setImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(40.0, 0.0, 40.0, 40.0);
            [button addTarget: self
                       action: @selector(onAddImage:)
             forControlEvents: UIControlEventTouchUpInside];
            button.hidden = NO;
            button.tag = 99;
            [self.scrollView addSubview:button];
        }
    }
}


- (void)deleteScrollAddImageButton {
    
    for (UIView *subview in self.scrollView.subviews) {
        
        if (subview.tag == 99)
            [subview removeFromSuperview];
    }
}


#pragma mark - Resizing textview/tablecell (description)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = 0;
    
    if (indexPath.row == CELL_DESCRIPTION_INDEX) {
        
        cellHeight = [self.textViewDescription sizeThatFits:CGSizeMake(self.textViewDescription.contentSize.width, FLT_MAX)].height;
    }
    else {
    
        cellHeight = [super tableView:self.table heightForRowAtIndexPath:indexPath];
    }
    
    return cellHeight;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    [self.table beginUpdates];
//    height = textView.contentSize.height;
    [self.table endUpdates];
}


#pragma mark - Actions

- (IBAction)onSave:(id)sender {
    
    if(![dbWrapperInstance openDB])
        return;
    
    NSString * query = [NSString stringWithFormat:@"SELECT count(*) \
                                                    FROM   product \
                                                    WHERE  name = \"%@\" AND collection_id = %d AND user_id = %d; ", self.textName.text, self.item.catID, 1];
    int count = [dbWrapperInstance execQueryResultInt: query andIndex: 0];
    [dbWrapperInstance closeDB];
    
    // validate
    if(count != 0 && ![self.textName.text isEqualToString:self.oldName]) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The good already exists"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [objectsHelperInstance.dataSet itemUpdate:self.item
                                     withName:self.textName.text
                                     withCode:self.textCode.text
                                 withPriceBuy:self.textPrice_buy.text
                                withPriceSale:self.textPrice_sale.text
                              withDescription:self.textViewDescription.text
                                   withUserID:1
                               withCategoryID:self.category.ID];

    // image
    // deleted
    if (self.item.gallery.count > 0) {

        NSMutableString *query = [[NSMutableString alloc] init];
        NSMutableArray *galleryForDelete = [[NSMutableArray alloc]init];
        
        if([dbWrapperInstance openDB]) {
        
            for (int i =0; i<self.item.gallery.count; i++) {
                
                POSGallery *gallery = [self.item.gallery objectAtIndex:i];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID = %d", gallery.ID];
                NSArray *filteredArray = [_galleryTmp filteredArrayUsingPredicate:predicate];
                
                if (filteredArray.count == 0)
                    [galleryForDelete addObject:gallery];
            }
            
            for (int i = 0; i < galleryForDelete.count; i++) {
                
                POSGallery *gallery = (POSGallery *)[galleryForDelete objectAtIndex:i];
                [query appendFormat:@"DELETE    \
                                      FROM      gallery \
                                      WHERE     id = %d; ", gallery.ID];
                [self.item.gallery removeObject:gallery];
            }

            [dbWrapperInstance tryExecQuery:query];
            [dbWrapperInstance closeDB];
        }
    }
    // added
    if (_galleryTmp.count > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID = %d", -1];
        NSArray *addedImages = [_galleryTmp filteredArrayUsingPredicate:predicate];
        
        if (addedImages.count > 0) {
            
            for (POSGallery *newGallery in addedImages) {
                
                NSString* random_name = [[NSUUID UUID] UUIDString];
                POSImage *newImage = [objectsHelperInstance.dataSet imagesCreate: newGallery.image
                                                                        withName: random_name
                                                                        withPath: random_name
                                                                    withObjectID: self.item.ID
                                                                  withObjectName: @"product"
                                                                   withIsDefault: 0];
                
                POSGallery *createdGallery =[objectsHelperInstance.dataSet galeriesCreate: newGallery.image
                                                                              withImageID: newImage.ID
                                                                            withProductID: newGallery.productID
                                                                                withAsset: newGallery.asset];
                [self.item.gallery addObject:createdGallery];
            }
        }
    }
    
    // reload assets
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [objectsHelperInstance.dataSet imagesSave: (objectsHelperInstance.dataSet.images.count - 1)
                                  withLibrary: library];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    POSSetCatViewController *controller = (POSSetCatViewController *)[segue destinationViewController];
    controller.item = self.item;
    controller.category = self.category;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)onDelete:(id)sender {
    
    NSString* question = [NSString stringWithFormat:@"Delete the %@ good?", self.textName.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Delete"
                                                    message: question
                                                   delegate: self
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Yes", nil];
    [alert show];
}


- (IBAction)onAddImage:(id)sender {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Select image"
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


#pragma mark - Table view data source
/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 1;
 }
 
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 1;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Methods

- (void)initControlsLayers {

    // button save shadow
    [helperInstance setButtonShadow:self.buttonSave withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];
    [helperInstance setButtonBackgroundColorBySetting:self.buttonSave];
    [helperInstance setButtonFontColorBySetting:self.buttonSave];
}


@end
