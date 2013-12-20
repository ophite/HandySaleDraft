//
//  POSNewCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POSNewCatViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textImageName;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;


- (IBAction)onCreate:(id)sender;
- (BOOL)createdNewCategory;


@end
