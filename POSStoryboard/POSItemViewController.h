//
//  POSItemViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSItem.h"

@interface POSItemViewController : UIViewController
{
    POSItem*            item;
    NSString*           currentQuantity;

}

@property POSItem* item;
@property NSString* currentQuantity;


@end
