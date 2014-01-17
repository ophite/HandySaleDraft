//
//  POSImage.m
//  POS
//
//  Created by kolec on 20.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import "POSImage.h"

@implementation POSImage

@synthesize image, assetUrl, path, object_id, object_name;
@synthesize ID = _ID;

-(id) initWithImage: (UIImage*)_image
          withAsset: (NSURL*)_assetUrl
           withPath: (NSString*)_path
      withObject_id: (int)_object_id
    withObject_name: (NSString*)_object_name {
    
    self = [super init];
    
    if(self) {
        
        image = _image;
        assetUrl = _assetUrl;
        path = _path;
        object_id = _object_id;
        object_name = _object_name;
    }
    
    return self;
}

@end
