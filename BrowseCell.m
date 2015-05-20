//
//  BrowseCell.m
//  JejuRiver
//
//  Created by Hwang Jeongsoo on 2015. 5. 20..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "BrowseCell.h"

@implementation BrowseCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // init cell
        [self.textLabel setTextColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *selBG = [[UIView alloc] init];
    [selBG setBackgroundColor:[UIColor grayColor]];
    [self setSelectedBackgroundView:selBG];
}

-(void)setJRObject:(JRObject*)argObj
{
    self.obj = argObj;
    [self.textLabel setText:self.obj.title];
    
    if( !self.obj.imageReady)
    {
        __weak typeof(self) weakSelf = self;
        [self.obj setImageHandler:^{
            [weakSelf layoutSubviews];
            [weakSelf setNeedsLayout];
            
        }];
        
        [self.obj startImageDownload];
    }

    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel setFrame:CGRectMake(90, 35, self.frame.size.width, 20)];
    
    [self.imageView setFrame:CGRectMake(0, 0, 80, 80)];
    if( self.obj.imageReady)
    {
        [self.imageView setImage:self.obj.image];
    }
    else
    {
        [self.imageView setImage:nil];
    }
}

@end
