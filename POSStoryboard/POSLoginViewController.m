//
//  POSLoginViewController.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/6/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSLoginViewController.h"


@interface POSLoginViewController (POSFindFirstResponder)

@end


@implementation POSLoginViewController
    

@synthesize textEmail = _textEmail;
@synthesize textPassword = _textPassword;
@synthesize buttonRememberMe = _buttonRememberMe;
@synthesize buttonLogin = _buttonLogin;
@synthesize viewForColorExample = _viewForColorExample;
@synthesize progress = _progress;
@synthesize viewWithControls = _viewWithControls;

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
    
    // init data
    POSTest* test = [[POSTest alloc] init];
    [test initDBStructure];
    [test initDBData:objectsHelperInstance.dataSet];
    [objectsHelperInstance.dataSet settingsGet];

    // gui
    [self loadControlsLayers];
    [self initControlsLayers];
    [helperInstance setButtonShadow:self.buttonLogin withCornerRadius:helperInstance.BUTTON_CORNER_RADIUS];

    self.textEmail.delegate = self;
    self.textPassword.delegate = self;
    
    keyboard = [[POSKBKeyboardHandler alloc] init];
    keyboard.delegate = self;
    
    // login password - remember
    __rememberChecked = [[POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME] boolValue];
    [self setRememberMeImage];

    [self resourcesLoad];
	// Do any additional setup after loading the view.
}


//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//}


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
        else {

            [self saveLoginPassIfRememberMe];
        }
       
        return isLogged;
    }
    
    return YES;
}


#pragma mark - POSKBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta {
    
    // Resize / reposition your views here. All actions performed here
    // will appear animated.
    // delta is the difference between the previous size of the keyboard
    // and the new one.
    // For instance when the keyboard is shown,
    // delta may has width=768, height=264,
    // when the keyboard is hidden: width=-768, height=-264.
    // Use keyboard.frame.size to get the real keyboard size.
    
    UIView *firstResponder = [self.view posFindFirstResponder];
    CGPoint point = [self.view convertPoint:CGPointZero fromView:firstResponder];
    
    // 568 - height of main window
    // 264 - height of keyboard
    // 25 delta
    if (point.y > (568 - 264 + 25)) {
        
        CGRect frame = self.view.frame;
        frame.origin.y -= delta.height;
        self.view.frame = frame;
    }
}


#pragma mark - Methods

/*
 * Check if user has correct pass
 */
- (BOOL)isUserHasCorrectPassword {
    
    BOOL isLogged = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString* passStr;
        NSString* query = [NSString stringWithFormat: @"SELECT  password \
                                                        FROM    user \
                                                        WHERE   email=\"%@\"; ", self.textEmail.text];
        
        if ([dbWrapperInstance tryExecQueryResultText:query
                                             andIndex:0
                                            andResult:&passStr] == YES) {
            
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

- (void)setRememberMeImage {
    
    [self.buttonRememberMe setImage: [UIImage imageNamed:(__rememberChecked ? helperInstance.SETTING_REMEMBERME_CHECKED_ICON:helperInstance.SETTING_REMEMBERME_UNCHECKED_ICON)]
                           forState: UIControlStateNormal];
}


- (void)saveLoginPassIfRememberMe {
    
    POSSetting *settingRememberMe = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME];

    if ([settingRememberMe.value boolValue] != __rememberChecked) {
        
        [objectsHelperInstance.dataSet settingsUpdate:settingRememberMe withValue:[helperInstance convertBoolToString:__rememberChecked]];
        
        POSSetting *settingRememberMe_Login = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME_LOGIN];
        POSSetting *settingRememberMe_Pass = (POSSetting *)[helperInstance getObject:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME_PASS];
        
        if (__rememberChecked) {
            
            if (![settingRememberMe_Login.value isEqualToString:self.textEmail.text]) {
                
                [objectsHelperInstance.dataSet settingsUpdate:settingRememberMe_Login withValue:self.textEmail.text];
            }
            
            if (![settingRememberMe_Pass.value isEqualToString:self.textPassword.text]) {
                
                self.textPassword.enabled = NO;
                self.textPassword.secureTextEntry = NO;
                self.textPassword.enabled = YES;
                [self.textPassword becomeFirstResponder];
                
                [objectsHelperInstance.dataSet settingsUpdate:settingRememberMe_Pass withValue:self.textPassword.text];
                
                self.textPassword.enabled = NO;
                self.textPassword.secureTextEntry = YES;
                self.textPassword.enabled = YES;
                [self.textPassword becomeFirstResponder];
            }
        }
        else  {
            // clear values
            [objectsHelperInstance.dataSet settingsUpdate:settingRememberMe_Login withValue:@""];
            [objectsHelperInstance.dataSet settingsUpdate:settingRememberMe_Pass withValue:@""];
        }
    }
}


- (void)initControlsLayers {
    
    [settingsGUIHelperInstance setTextFieldBorderColorBySetting:self.textEmail];
    [settingsGUIHelperInstance setTextFieldBorderColorBySetting:self.textPassword];
    [settingsGUIHelperInstance setTextFieldFontColorBySetting:self.textPassword];
}

- (void)loadControlsLayers {
    
    // lines and text field border from first ViewController
    [settingsGUIHelperInstance loadTextFieldBorderColorSetting:self.viewForColorExample.backgroundColor];
    // big yellow buttons
    [settingsGUIHelperInstance loadButtonBackgroundColorSetting:self.buttonLogin.backgroundColor];
    // big yellow buttons font color
    [settingsGUIHelperInstance loadButtonFontColorSetting:self.buttonLogin.tintColor];
    // textField text color
    [settingsGUIHelperInstance loadTextFieldFontColorSetting:self.textEmail.textColor];
}


#pragma mark - Methods

- (void)resourcesLoad {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if (__rememberChecked) {
        
        [objectsHelperInstance.dataSet imagesSaveWithAsyncCounter:0 withLibrary:library];
        self.viewWithControls.hidden = YES;
        self.progress.hidden = NO;
        self.progress.progress = 0.0;
        [self performSelectorOnMainThread: @selector(progressActivate)
                               withObject: nil
                            waitUntilDone: NO];
    }
    else {
        
        [objectsHelperInstance.dataSet imagesSave:0 withLibrary:library];
        self.viewWithControls.hidden = NO;
        self.progress.hidden = YES;
    }
}


- (void)progressActivate {
    
    if (objectsHelperInstance.dataSet.ASYNC_IMAGES_COUNT < objectsHelperInstance.dataSet.images.count) {
        
        NSNumber *maxValue = [NSNumber numberWithInt:objectsHelperInstance.dataSet.images.count];
        NSNumber *numberStep = [NSNumber numberWithInt:objectsHelperInstance.dataSet.ASYNC_IMAGES_COUNT];
        
        self.progress.progress = numberStep.floatValue /maxValue.floatValue;
        [NSTimer scheduledTimerWithTimeInterval: 0.01
                                         target: self
                                       selector: @selector(progressActivate)
                                       userInfo: nil
                                        repeats: NO];
    }
    else{
        
        self.viewWithControls.hidden = NO;
        self.progress.hidden = YES;
        self.textEmail.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME_LOGIN];
        self.textPassword.text = [POSSetting getSettingValue:objectsHelperInstance.dataSet.settings withName:helperInstance.SETTING_REMEMBERME_PASS];
        [self.buttonLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - Actions

- (IBAction)onRememberMe:(id)sender {

    __rememberChecked = !__rememberChecked;
    [self setRememberMeImage];
    [self.view endEditing:YES];
}


@end
