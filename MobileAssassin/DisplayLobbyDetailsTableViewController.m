//
//  DisplayLobbyDetailsTableViewController.m
//  MobileAssassin
//
//  Created by Swetha RK on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "DisplayLobbyDetailsTableViewController.h"
#import <Parse/Parse.h>

@interface DisplayLobbyDetailsTableViewController ()

@end

@implementation DisplayLobbyDetailsTableViewController
@synthesize rightNavButton;
@synthesize leftNavButton;

- (UIBarButtonItem *)rightNavButton {
    if (!rightNavButton) {
        //configure the button here
        rightNavButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"SignUp"
                                         style:UIBarButtonItemStylePlain
                                         target:self action:@selector(signUpPressed:) ];
        
    }
    return rightNavButton;
}

- (UIBarButtonItem *)leftNavButton {
    if (!leftNavButton) {
        //configure the button here
        leftNavButton = [[UIBarButtonItem alloc]
                                initWithTitle:@"Join"
                                style:UIBarButtonItemStylePlain
                                target:self action:@selector(joinPressed:) ];
    }
    return leftNavButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.currentUser = [PFUser currentUser];
    NSLog(@"%@", self.currentUser.username);
    if (!self.currentUser)
        self.navigationItem.rightBarButtonItem = self.rightNavButton;
    
    self.navigationItem.leftBarButtonItem = self.leftNavButton;
    
    self.title = _lobbyName;
   
    NSLog(@"DisplayLobbyDetailsTableViewController viewDidLoad %@", _lobbyName);
    NSLog(@"DisplayLobbyDetailsTableViewController viewDidLoad- %lu", [self currentPlayers].count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SignUp" message:@"Are you sure you wanna signup" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"YES"])
    {
        NSLog(@"YES was selected.");
    }
    
    
}

- (IBAction)joinPressed:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser)
    {
       NSLog(@"DisplayLobbyDetailsTableViewController joinPressed %@", currentUser);
        
        PFQuery *query = [PFQuery queryWithClassName:@"Lobby"];
        [query whereKey:@"lobbyName" equalTo:_lobbyName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
                
                PFUser *player = [PFUser user];
                player.username = currentUser.username;
                player.password = currentUser.password;
                player.email = currentUser.email;
                player[@"isPlaying"] = [NSNumber numberWithBool:YES];
        
                unsigned long count = [objects count];
                NSLog(@"joinPressed-num of matching lobby %lu", count);
            
                for(int i = 0; i < count; i++)
                {
                    PFRelation *lobbyUsers = [objects[i] relationForKey:@"lobbyUsers"];
                    [lobbyUsers addObject:player];
                    [objects[i] saveInBackground];
                }
        }];
        
    }
    else
        NSLog(@"DisplayLobbyDetailsTableViewController joinPressed - No current user");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.currentPlayers count];
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lobbyDetailsID"];
 
      NSString *entry = (self.currentPlayers)[indexPath.row];
      cell.textLabel.text = entry;
      UIView *myView = [[UIView alloc] init];
      //myView.backgroundColor = [UIColor redColor];
      cell.backgroundView = myView;
 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
