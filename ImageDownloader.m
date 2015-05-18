//
//  ImageDownloader.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 10..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

@synthesize delegate = _delegate;

-(void)beginDownloadFileID:(NSString*)strID
{
    fileID = [NSString stringWithString:strID];
    NSString *urlString = [[JRController controller] imageURL:fileID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    httpData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [httpData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:httpData];
    if( [_delegate respondsToSelector:@selector(imageDownloadComplete:FileID:)])
        [_delegate imageDownloadComplete:image FileID:fileID];
}



@end
