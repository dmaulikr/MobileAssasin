//
//  AssasinateViewController.m
//  MobileAssassin
//
//  Created by Harleen Kaur on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "AssasinateViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
@interface AssasinateViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic,strong) PFObject *targetList;
@end

@implementation AssasinateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _toBeAssasinatePlayerButton.hidden = YES;
    _labelTargetInRange.hidden = YES;
    _labelTargetNotInRange.hidden = NO;
    
    //TO-DO : set the button name to target name
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Before the playerflag is checked");
    NSLog(@"%@", _appDelegate.peer.toBeAssasinatedPlayerFlag);
    if([_appDelegate.peer.toBeAssasinatedPlayerFlag isEqualToString:@"YES"]) {
        NSLog(@"player will be killed");
    [_toBeAssasinatePlayerButton setTitle:_appDelegate.peer.toBeAssasinatedPlayer forState:UIControlStateNormal];
        _toBeAssasinatePlayerButton.hidden = NO;
        _labelTargetInRange.hidden = NO;
         _labelTargetNotInRange.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (IBAction)assassinateButtonPressed:(id)sender {
    //Remove isplaying from targetname
    //check if targetname is equal to currentuser username to see if game is finished
    //Make targetname of targetname current targetname;
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"TargetList"];
    [query whereKey:@"assassinName" equalTo: _appDelegate.peer.targetPlayer];
    _targetList = [query getFirstObject];
    _targetList[@"isPlaying"] = [NSNumber numberWithBool:NO];
    NSString *newTarget = _targetList[@"targetName"];
    _targetList[@"targetName"] = @"";
    [_targetList saveInBackground];
    [query whereKey:@"assassinName" equalTo: [[PFUser currentUser] username]];
    _targetList = [query getFirstObject];
    if ([newTarget isEqualToString:[[PFUser currentUser] username]]) { //game has ended
        _targetList[@"targetName"] = @"";
        _targetList[@"isPlaying"] = [NSNumber numberWithBool:NO];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations!!!" message:@"You have succesfully become the assassin master!" delegate:nil cancelButtonTitle:NO otherButtonTitles:@"OK", nil];
        [alertView show];
    } else { // assign new targeet
        _targetList[@"targetName"] = newTarget;
        _appDelegate.peer.targetPlayer = [newTarget stringByTrimmingCharactersInSet:  [NSCharacterSet whitespaceCharacterSet]];

    }
    [_targetList save];
    //send push notification
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
