//
//  SetupViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 11..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "SetupViewController.h"
#import "PlayViewController.h"

#define USERINFO_KEY @"USER_INFO_KEY"
#define USER_ID_KEY @"USER_ID_KEY"
#define USER_PW_KEY @"USER_PW_KEY"
#define ACCESS_KEY @"ACCESS_KEY"


@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setTitle:@"Connect to Server"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:USERINFO_KEY];
    if( dic != nil)
    {
        [textKey setText:[dic objectForKey:ACCESS_KEY]];
        [textID setText:[dic objectForKey:USER_ID_KEY]];
        [textPW setText:[dic objectForKey:USER_PW_KEY]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onConnectButton:(id)sender
{
    [(UIButton*)sender setTitle:@"Connecting" forState:UIControlStateDisabled];
    [(UIButton*)sender setEnabled:NO];
    
    NSString *accessKey = [textKey.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userId = [textID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userPw = [textPW.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [textKey setText:accessKey];
    [textID setText:userId];
    [textPW setText:userPw];
    
    [[JRController controller] setDelegate:self];
    [[JRController controller] setupServerAccessKey:accessKey ID:userId Password:userPw];
}

-(void)authResult:(BOOL)success
{
    [connectButton setEnabled:YES];
    
    if( success )
    {
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:textKey.text,ACCESS_KEY,textID.text,USER_ID_KEY,textPW.text,USER_PW_KEY, nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dic forKey:USERINFO_KEY];
        [defaults synchronize];
        
        PlayViewController *playView = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        [self.navigationController pushViewController:playView animated:YES];
        

        
    }
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
