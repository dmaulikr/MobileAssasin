//
//  OpenGamesTableViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "OpenGamesTableViewController.h"
#import "LobbyViewController.h"
@interface OpenGamesTableViewController ()

@end

@implementation OpenGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Testing viewGamesSegue");
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setBackgroundView:bview];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Lobby"];
    [query whereKey:@"isFull" equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *lobbies, NSError *error) {
        NSLog(@"viewGamesSegue - lobby Array Count =%d", [lobbies count]);
        self.lobbies = lobbies;
        NSLog(@"%@" , [self.lobbies objectAtIndex:0][@"lobbyName"]);
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.lobbies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    NSLog(@"%s", "cellForRowAtIndexPath");
    NSLog(@"%d" , indexPath.row);
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Lobby" forIndexPath:indexPath];
    
    PFObject *lobby = [self.lobbies objectAtIndex:indexPath.row];
    NSLog(@"%@" , lobby[@"lobbyName"]);
    cell.textLabel.text = lobby[@"lobbyName"];
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]])  {
        if ([segue.destinationViewController isKindOfClass:[LobbyViewController class]]) {
            LobbyViewController *destController = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            destController.lobby = [self.lobbies objectAtIndex:indexPath.row];
        }
    }
    
}

@end
