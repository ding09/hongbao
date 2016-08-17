//
//  DZCFourTableViewController.m
//  hongbao
//
//  Created by li wei on 16/8/5.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "DZCFourTableViewController.h"
#import "DZCHomeTableViewCellTwo.h"
#import "UIImageView+WebCache.h"
@interface DZCFourTableViewController ()
{
    NSArray *dataArray;
}
@end

@implementation DZCFourTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     dataArray=@[@"http://112.74.68.165/upload/201604/25/201604250933530096.jpg",@"http://112.74.68.165/upload/201604/25/201604250933530096.jpg",@"http://112.74.68.165/upload/201604/25/201604250933530096.jpg",@"http://112.74.68.165/upload/201604/25/201604250933530096.jpg"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZCHomeTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"dzchongbaocell" forIndexPath:indexPath];
    [cell.DZCMovieImage sd_setImageWithURL:[NSURL URLWithString:[dataArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"banner1-.jpg"]];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
