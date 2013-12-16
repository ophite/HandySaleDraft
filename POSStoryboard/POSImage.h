//
//  POSImage.h
//  POS
//
//  Created by kolec on 20.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSImage : NSObject
{
    UIImage*         image;
    NSURL*           assetUrl;
    NSString*        path;
    int              object_id;
    NSString*        object_name;
}

@property UIImage*          image;
@property NSURL*            assetUrl;
@property NSString*         path;
@property int               object_id;
@property NSString*         object_name;

-(id) initWithImage:(UIImage*)_image withAsset:(NSURL*)_assetUrl withPath:(NSString*)_path withObject_id:(int) _object_id withObject_name:(NSString*)_object_name;

@end
