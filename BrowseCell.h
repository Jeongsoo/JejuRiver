//
//  BrowseCell.h
//  JejuRiver
//
//  Created by Hwang Jeongsoo on 2015. 5. 20..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseCell : UITableViewCell

@property   (nonatomic,strong)  JRObject    *obj;

-(void)setJRObject:(JRObject*)argObj;

@end
