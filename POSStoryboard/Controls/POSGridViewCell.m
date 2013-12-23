//
//  POSGridViewCell.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSGridViewCell.h"

@implementation POSGridViewCell

@synthesize imageView, captionLabel;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    
    if (self)
    {
        UIImage* backgroundPattern = [UIImage imageNamed:@"bg-app.png"];
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:backgroundPattern]];
        //self.backgroundColor = [UIColor clearColor];
        //self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, helperInstance.ITEM_LIST_WIDTH, helperInstance.ITEM_LIST_HEIGHT)];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, helperInstance.ITEM_LIST_WIDTH - 6, helperInstance.ITEM_LIST_HEIGHT - 6)];
        self.imageView.backgroundColor = [UIColor whiteColor];
        //[self.imageView setBackgroundColor:[UIColor colorWithPatternImage:backgroundPattern]];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, 127, 21)];
        [self.captionLabel setFont:[UIFont systemFontOfSize:14]];
        [self.captionLabel setBackgroundColor:[UIColor clearColor]];
        
        [mainView addSubview:self.imageView];
        [mainView addSubview:self.captionLabel];
        [self.contentView addSubview:mainView];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
