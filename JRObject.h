//
//  JRObject.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 17..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloader.h"



@interface JRObject : NSObject<ImageDownloaderDelegate>
{
    ImageDownloader *imageDownloader;
}


@property   (nonatomic,strong)  NSString *title;
@property   (nonatomic,strong)  NSString *ID;
@property   (nonatomic,assign)  BOOL    imageReady;
@property   (nonatomic,assign)  BOOL    isBrowse;
@property   (nonatomic,strong)  UIImage *image;
@property   (nonatomic,copy)    void(^imageHandler)(void);

-(id)initWithIsBrowse:(BOOL)browse;
-(void)startImageDownload;

@end
