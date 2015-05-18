//
//  KeyAddViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 5..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "KeyAddViewController.h"

@interface KeyAddViewController ()

@end

@implementation KeyAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Add Server"];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
    
    
    [self.navigationItem setRightBarButtonItem:okButton];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onDone
{
    if( keyField.text.length > 0)
        [[JRController controller] addKey:keyField.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
