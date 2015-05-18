//
//  RiverListViewController.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 5..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,JRControllerDelegate>
{
    IBOutlet    UITableView *serverTableView;
}

@end
