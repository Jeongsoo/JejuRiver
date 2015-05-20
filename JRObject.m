//
//  JRObject.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 17..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "JRObject.h"

@implementation JRObject

-(id)initWithIsBrowse:(BOOL)browse
{
    self = [super init];
    if(self)
    {
        _imageReady = NO;
        _isBrowse = browse;
        imageDownloader = [[ImageDownloader alloc] init];
    }
    
    return self;
}

-(void)startImageDownload
{
    _imageReady = NO;
    [imageDownloader setDelegate:self];
    [imageDownloader beginDownloadFileID:_ID Browse:_isBrowse];
}

-(void)imageDownloadComplete:(UIImage*)image FileID:(NSString*)idString
{
    if( [idString isEqualToString:_ID])
    {
        _image = image;
        _imageReady = YES;
        
        if( self.imageHandler )
        {
            self.imageHandler();
        }
    }

    
}

@end
