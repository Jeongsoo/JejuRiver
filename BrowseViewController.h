//
//  BrowseViewController.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 17..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kBrowseNormal = 0,
    kBrowseFileList,
    kBrowseFileDetail
}
JRBrowseMode;

@interface BrowseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,JRControllerDelegate,UIActionSheetDelegate>
{

    NSArray     *jrArray;

    IBOutlet    UITableView *listTable;
}

@property (nonatomic,strong)     NSString    *selectedID;
@property (nonatomic,assign)     JRBrowseMode browseMode;

@end
