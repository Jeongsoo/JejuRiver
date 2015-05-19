//
//  PlayViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 10..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "PlayViewController.h"
#import "BrowseViewController.h"



@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[JRController controller] setDelegate:self];
    [[JRController controller] requestInfo];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [timer invalidate];
    timer = nil;
}

-(void)onTimer
{
    [[JRController controller] setDelegate:self];
    [[JRController controller] requestInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)info:(NSDictionary *)dic
{
    if( [dic objectForKey:@"FileKey"] == nil )
        return;
    
    imageDownloader = [[ImageDownloader alloc] init];
    [imageDownloader setDelegate:self];
    [imageDownloader beginDownloadFileID:[dic objectForKey:@"FileKey"]];
    
    [titleLabel setText:[dic objectForKey:@"Name"]];
    
    JRPlaybackState state = [[dic valueForKey:@"State"] intValue];
    [playToolbar setHidden:(state == kPlaybackStatePlay)];
    [pauseToolbar setHidden:!(state == kPlaybackStatePlay)];
    
    
}

-(void)imageDownloadComplete:(UIImage *)image FileID:(NSString *)idString
{
    [coverView setImage:image];
}


#pragma mark IBACTIONS

-(IBAction)onPlayButton:(id)sender
{
    [[JRController controller] playToggle];
}

-(IBAction)onPrevButton:(id)sender
{
    
}

-(IBAction)onNextButton:(id)sender
{
    
}

-(IBAction)onPlayListButton:(id)sender
{
    
}

-(IBAction)onLibraryButton:(id)sender
{
    NSString *idToBrowse = @"";
    BrowseViewController *browseView = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
    [browseView setSelectedID:idToBrowse];
    [browseView setTitle:@"Browse"];
    [browseView setBrowseMode:kBrowseNormal];
    JRNaviViewController *navi = [[JRNaviViewController alloc] initWithRootViewController:browseView];
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navi animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
