//
//  SetupViewController.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 11..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController<JRControllerDelegate>
{
    IBOutlet    UITextField *textKey;
    IBOutlet    UITextField *textID;
    IBOutlet    UITextField *textPW;
    IBOutlet    UIButton    *connectButton;
}

@end
