//
//  ImageDownloader.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 10..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate <NSObject>

@required
-(void)imageDownloadComplete:(UIImage*)image FileID:(NSString*)idString;

@end

@interface ImageDownloader : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *httpData;
    NSString        *fileID;
    id<ImageDownloaderDelegate> __weak  _delegate;
}

@property   (nonatomic,weak)    id<ImageDownloaderDelegate> delegate;

-(void)beginDownloadFileID:(NSString*)strID Browse:(BOOL)isBrowse;


@end
