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


@synthesize item = _item;
@synthesize category = _category;
@synthesize oldName = _oldName;

@synthesize textName = _textName;
@synthesize labelCode = _labelCode;
@synthesize textCode = _textCode;
@synthesize labelPrice1 = _labelPrice1;
@synthesize textPrice1 = _textPrice1;
@synthesize labelPrice2 = _labelPrice2;
@synthesize textPrice2 = _textPrice2;
@synthesize labelDescription = _labelDescription;
@synthesize textViewDescription = _textViewDescription;
@synthesize buttonCategory = _buttonCategory;
@synthesize scrollView = _scrollView;
@synthesize table = _table;


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
    self.textPrice1.text = self.item.price1;
    self.textPrice2.text = self.item.price2;
    self.textViewDescription.text = self.item.description;
    
    // gui
    self.table.allowsSelection = NO;
    self.textName.delegate = self;
    self.textCode.delegate = self;
    self.textPrice1.delegate = self;
    self.textPrice2.delegate = self;
    self.textViewDescription.delegate = self;
    self.textViewDescription.allowsEditingTextAttributes = YES;
    // margins
    [helperInstance createLeftMarginForTextField:self.textName];
    [helperInstance createLeftMarginForTextField:self.textCode];
    [helperInstance createLeftMarginForTextField:self.textPrice1];
    [helperInstance createLeftMarginForTextField:self.textPrice2];
    [helperInstance createLeftMarginForLabel:self.labelCode];
    [helperInstance createLeftMarginForLabel:self.labelPrice1];
    [helperInstance createLeftMarginForLabel:self.labelPrice2];
    [helperInstance createLeftMarginForLabel:self.labelDescription];
    [helperInstance createLeftMarginForTextView:self.textViewDescription];
    
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(self.item.gallery.count*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:2.0];

    // images
    for(int i = 0; i<self.item.gallery.count; i++) {
        
        UIImageView* localImageView = [[UIImageView alloc] initWithImage:[self.item.gallery objectAtIndex:i]];
        localImageView.frame = CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        localImageView.backgroundColor = [UIColor whiteColor];
        localImageView.contentMode = UIViewContentModeScaleAspectFit;
        localImageView.clipsToBounds = YES;
        [self.scrollView addSubview:localImageView];
    }
    
//    UITableViewCell *cell = (UITableViewCell*)self.textViewDescription.superview.superview;
//    
//    if (cell.frame.size.height < self.textViewDescription.contentSize.height) {
//        [self.tableView beginUpdates];
//        CGRect frame = self.textViewDescription.frame;
//        frame.size.height = self.textViewDescription.contentSize.height;
//        self.textViewDescription.frame = frame;
//        CGRect cellFrame = cell.frame;
//        cellFrame.size.height = self.textViewDescription.frame.size.height;
//        cell.frame = cellFrame;
//        [self.tableView endUpdates];
//    }


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


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.textCategory.text = self.item.category;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.item.gallery addObject:image];
    self.scrollView.contentSize = CGSizeMake(self.item.gallery.count*helperInstance.ITEM_EDIT_WIDTH, helperInstance.ITEM_EDIT_HEIGHT);

    UIImageView* localImageView = [[UIImageView alloc] initWithImage:image];
    localImageView.frame = CGRectMake((self.item.gallery.count-1)*helperInstance.ITEM_EDIT_WIDTH, 0, helperInstance.ITEM_EDIT_WIDTH, helperInstance.ITEM_EDIT_HEIGHT);
    localImageView.backgroundColor = [UIColor whiteColor];
    localImageView.contentMode = UIViewContentModeScaleAspectFit;
    localImageView.clipsToBounds = YES;
    
    [self.scrollView addSubview:localImageView];
    
    // Code here to work with media
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
                    
                    NSString * query = [NSString stringWithFormat:@"DELETE  \
                                                                    FROM    product \
                                                                    WHERE   name = \"%@\" AND user_id = %d", self.item.name, 1];
                    
                    [dbWrapperInstance tryExecQuery:query];
                    [dbWrapperInstance closeDB];
                    
                    [objectsHelperInstance.dataSet.items removeObjectAtIndex:objectsHelperInstance.currentItemsIndex];
                    [self.navigationController popViewControllerAnimated:YES];
                }
        }
        else if ([alertView.title isEqual: @"Select source"] && buttonIndex == 0) {
            
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController: controller
                               animated: YES
                             completion: nil];
        }
    }
}


#pragma mark - Resizing textview and after tablecell
//int _cellDescriptionHeight;

- (void)textViewDidChange:(UITextView *)textView {
    
    UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
    
    if (cell.frame.size.height < textView.contentSize.height) {
        [self.tableView beginUpdates];
        CGRect frame = textView.frame;
        frame.size.height = textView.contentSize.height;
        textView.frame = frame;
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = textView.frame.size.height;
        cell.frame = cellFrame;
        [self.tableView endUpdates];
    }
//    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellEditItemDescription"];
//
//    if (self.textViewDescription.contentSize.height > cell.frame.size.height ) {
//        
//        _cellDescriptionHeight = self.textViewDescription.contentSize.height ;
//        
//        [self.table beginUpdates];
//        [self.table endUpdates];
//        
//        [self.textViewDescription setFrame:CGRectMake(0, 0, 300.0, self.textViewDescription.contentSize.height)];
//    }
}

//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"%d", indexPath.row);
//    NSLog(@"%d", indexPath.section);
//    
//    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
//    CGFloat height = cell.frame.size.height;
//    
//    if (indexPath.row == 7)
//        height = _cellDescriptionHeight;
//    
//    return height;
//}


#pragma mark - Actions

- (IBAction)onSave:(id)sender {
    
    int n;
    n = 0;
    
    if([dbWrapperInstance openDB]) {
        
//        NSString * query = [NSString stringWithFormat:@"SELECT  id \
//                                                        FROM    collection \
//                                                        WHERE   name = \"%@\" AND user_id = %d", self.textCategory.text, 1];
//        
//        int cat_ID = [dbWrapperInstance execQueryResultInt:query andIndex:0];
//        query = [NSString stringWithFormat:@"SELECT count(*) \
//                                             FROM   product \
//                                             WHERE  name = \"%@\" AND collection_id = %d AND user_id = %d", self.textName.text, cat_ID, 1];
//        n = [dbWrapperInstance execQueryResultInt: query andIndex: 0];
        [dbWrapperInstance closeDB];
    }
    
    
    if(n != 0 && ![self.textName.text isEqualToString:self.oldName]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement"
                                                        message: @"The good already exists"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    self.item.name       = self.textName.text;
    //item.image      = imageView.image;
//    self.item.category   = self.textCategory.text;
    self.item.codeItem   = self.textCode.text;
    self.item.price1     = self.textPrice1.text;
    self.item.price2     = self.textPrice2.text;
    self.item.description= self.textViewDescription.text;
    self.item.userID     = 1;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString* random_name = [[NSUUID UUID] UUIDString];
    
    NSString * query = [NSString stringWithFormat:@"UPDATE  product \
                                                    SET     name            = \"%@\", \
                                                            price_buy       = \"%@\", \
                                                            price_sale      = \"%@\", \
                                                            comment         = \"%@\", \
                                                            user_id         = \"%d\", \
                                                            collection_id   = \"%@\"  \
                                                    WHERE   id = %d;", self.item.name, self.item.price1, self.item.price2, self.item.description, self.item.userID, self.item.category, self.item.ID];
    
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
    [objectsHelperInstance.dataSet gallerySave: (objectsHelperInstance.dataSet.images.count - 1)
                                   withLibrary: library];
    
    [self.navigationController popViewControllerAnimated:YES];
}


//- (IBAction)onCancel:(id)sender {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"goToFakeSetCategory"]) {
        
        return NO;
    }
    
    return YES;
}



- (IBAction)onSetCategory:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main"
                                                             bundle: nil];

    POSSetCatViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"POSSetCatViewController"];
    controller.title = @"Set category";
    controller.item = self.item;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<[objectsHelperInstance.dataSet.categories count]; i++) {
        
        NSString* name = [[objectsHelperInstance.dataSet.categories objectAtIndex:i] name];
        [array addObject:name];
        
        if([self.item.category isEqualToString:name])
            controller.initRow = i;
    }
    
    controller.pickerData = array;
    [self.navigationController pushViewController: controller
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


@end
