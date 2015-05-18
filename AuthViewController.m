//
//  AuthViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 9..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Authentication"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButton)];
    [self.navigationItem setRightBarButtonItems:[[NSArray alloc] initWithObjects:doneButton, nil] animated:NO];
}

-(void)onDoneButton
{
    [self dismissViewControllerAnimated:YES completion:^(void){    [[JRController controller] sendAuthID:textID.text Password:textPW.text];}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
