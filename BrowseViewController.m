//
//  BrowseViewController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 17..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "BrowseViewController.h"


@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
        [self.navigationItem setRightBarButtonItem:cancel];


    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [listTable setBackgroundColor:[UIColor blackColor]];
    [listTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [[JRController controller] setDelegate:self];
    if( _browseMode == kBrowseNormal )
    {
        [[JRController controller] browse:_selectedID];
    }
    else
    {
        
    }
    

}

-(void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)browse:(NSArray *)array
{
    if( array.count > 0 )
    {
        jrArray = [[NSArray alloc] initWithArray:array];
        [listTable reloadData];
    }
    else
    {
        if( _browseMode == kBrowseNormal)
        {
            _browseMode = kBrowseFileList;
            [[JRController controller] fileList:_selectedID];
        }
    }
}

-(void)fileList:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array)
    {
        JRObject *obj = [[JRObject alloc] init];
        [obj setID:[dic objectForKey:@"Key"]];
        [obj setTitle:[dic objectForKey:@"Name"]];
        [tempArray addObject:obj];
    }
    
    jrArray = [[NSArray alloc] initWithArray:tempArray];
    [listTable reloadData];
}

-(void)playByKey:(BOOL)success
{
    if( success)
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( jrArray != nil )
    {
        return jrArray.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString    *cellID = @"JRCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if( cell == nil)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    JRObject *obj = [jrArray objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:[UIColor blackColor]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setText:obj.title];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JRObject *obj = [jrArray objectAtIndex:indexPath.row];
    NSString *idToBrowse = obj.ID;
    
    if( _browseMode == kBrowseNormal)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        BrowseViewController *browseView = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
        [browseView setSelectedID:idToBrowse];
        [browseView setTitle:obj.title];
        [[self navigationController] pushViewController:browseView animated:YES];
        
    }
    else
    {
        _selectedID = obj.ID;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:obj.title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Play" otherButtonTitles:@"Add", nil];
        [sheet showInView:self.view];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )  // play
    {
        [listTable setUserInteractionEnabled:NO];
        [[JRController controller] playByKey:_selectedID Add:NO];
    }
    else if (buttonIndex == 1) // add
    {
        [[JRController controller] playByKey:_selectedID Add:YES];
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
