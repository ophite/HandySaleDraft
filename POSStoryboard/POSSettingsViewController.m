//
//  POSSettingsViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSSettingsViewController.h"


@interface POSSettingsViewController ()

@end


@implementation POSSettingsViewController


@synthesize textEmail = _textEmail;
@synthesize buttonLanguage = _buttonLanguage;
@synthesize buttonMoney = _buttonMoney;
@synthesize switchVAT = _switchVAT;
@synthesize switchWIFI = _switchWIFI;


#pragma mark - ViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // init data
    self.textEmail.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_EMAIL];
    [self.buttonLanguage setTitle:[POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_LANGUAGE] forState:UIControlStateNormal];
    [self.buttonMoney setTitle:[POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_MONEY] forState:UIControlStateNormal];
    [self.switchWIFI setOn:[[POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_WIFI] boolValue]];
    [self.switchVAT setOn:[[POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_VAT] boolValue]];
    
    // gui
    self.textEmail.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        POSSetting *settingEmail = [POSSetting getSetting:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_EMAIL];
        if (![settingEmail.value isEqualToString:self.textEmail.text]) {
            
            [objectsHelperInstance.dataSet settingsUpdate: settingEmail
                                                withValue: self.textEmail.text];
        }
        
        POSSetting *settingWIFI = [POSSetting getSetting:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_WIFI];
        if ([settingWIFI.value boolValue] != self.switchWIFI.isOn) {
            
            [objectsHelperInstance.dataSet settingsUpdate: settingWIFI
                                                withValue: [helperInstance convertBoolToString:self.switchWIFI.isOn]];
        }
        
        POSSetting *settingVAT = [POSSetting getSetting:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_VAT];
        if ([settingVAT.value  boolValue] != self.switchVAT.isOn) {
            
            [objectsHelperInstance.dataSet settingsUpdate: settingVAT
                                                withValue: [helperInstance convertBoolToString:self.switchVAT.isOn]];
        }
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self.buttonLanguage setTitle: [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_LANGUAGE]
                         forState: UIControlStateNormal];
    [self.buttonMoney setTitle: [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_MONEY]
                      forState: UIControlStateNormal];
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    POSSelectSettingsViewController *controller = (POSSelectSettingsViewController *)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"goToLanguage"]) {
        
        controller.settingName = helperInstance.SETTING_LANGUAGE;
        controller.settingValue = self.buttonLanguage.titleLabel.text;
        controller.pickerDict = [helperInstance SETTING_LANGUAGES_DICT];
        
    }
    else if ([[segue identifier] isEqualToString:@"goToMoney"]) {
        
        controller.settingName = helperInstance.SETTING_MONEY;
        controller.settingValue = self.buttonMoney.titleLabel.text;
        controller.pickerDict = [helperInstance SETTING_MONEY_DICT];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
