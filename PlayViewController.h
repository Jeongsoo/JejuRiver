//
//  PlayViewController.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 10..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@interface PlayViewController : UIViewController<JRControllerDelegate,ImageDownloaderDelegate>
{
    IBOutlet UIBarButtonItem *browseButton;
    IBOutlet UIBarButtonItem *prevButton;
    IBOutlet UIBarButtonItem *playButton;
    IBOutlet UIBarButtonItem *nextButton;
    IBOutlet UIBarButtonItem *listButton;
    IBOutlet UIImageView    *coverView;
    IBOutlet UIProgressView *pregressBar;
    IBOutlet UILabel        *titleLabel;
    IBOutlet UIToolbar      *playToolbar;
    IBOutlet UIToolbar      *pauseToolbar;
    
    NSTimer *timer;
    
    ImageDownloader *imageDownloader;
    
}

@end
