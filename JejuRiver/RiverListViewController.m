//
//  RiverListViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 5..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "RiverListViewController.h"
#import "KeyAddViewController.h"
#import "PlayViewController.h"
#import "JRServer.h"


@implementation RiverListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Server List"];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    [self checkServers];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)checkServers
{
    [[JRController controller] setDelegate:self];
    [[JRController controller] scanServer];
    [serverTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onAddButton
{
    UINavigationController *addNavi = [[UINavigationController alloc] initWithRootViewController:[[KeyAddViewController alloc] initWithNibName:@"KeyAddViewController" bundle:nil]];
    
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:addNavi animated:YES completion:nil];
}


-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JRServer *server = [[[JRController controller] serverArray] objectAtIndex:indexPath.row];
    if( server.status )
        return indexPath;
    else
        return nil;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JRServer *server = [[[JRController controller] serverArray] objectAtIndex:indexPath.row];
    if( server.status )
    {
        [[JRController controller] selectServer:indexPath.row];
        PlayViewController *playView = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        [self.navigationController pushViewController:playView animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JRController *controller = [JRController controller];
    return [[controller serverArray] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JRCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    
    
    JRServer *server = [[[JRController controller] serverArray] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:server.accessKey];
    [[cell textLabel] setTextColor:(server.status?[UIColor blackColor]:[UIColor grayColor])];
    [[cell detailTextLabel] setText:(server.status?server.friendlyName:@"--")];

    
    return cell;
}


-(void)lookUpResult
{
    [serverTableView reloadData];
}

-(void)authOK
{

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
