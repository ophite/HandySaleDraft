//
//  POSEditCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSCategory.h"

@interface POSEditCatViewController : UIViewController
{
    POSCategory*            cat;
}

@property POSCategory* cat;

@end
