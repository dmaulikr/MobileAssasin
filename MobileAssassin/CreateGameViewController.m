//
//  CreateGameViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "CreateGameViewController.h"

@interface CreateGameViewController ()

@end

@implementation CreateGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lobbyNameText becomeFirstResponder];
    // Do any additional setup after loading the view.
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

- (IBAction)createPressed:(id)sender {
    NSString *lobbyName = [self.lobbyNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int minPlayer = [[self.minPlayerText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    int maxPlayer =[[self.maxPlayerText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    
    
    if (lobbyName.length != 0 || minPlayer > 1 || maxPlayer >= minPlayer) {
        PFQuery *query = [PFQuery queryWithClassName:@"Lobby"];
        [query whereKey:@"lobbyName" equalTo:lobbyName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Lobby name already exists!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
        PFObject *lobby = [PFObject objectWithClassName:@"Lobby"];
        lobby[@"lobbyName"] = lobbyName;
        lobby[@"minPlayer"] = @(minPlayer);
        lobby[@"maxPlayer"] = @(maxPlayer);
        lobby[@"createdBy"] = [[PFUser currentUser]username];
        lobby[@"isPrivate"] = [NSNumber numberWithBool:NO];
        lobby[@"isFull"] = [NSNumber numberWithBool:NO];
        PFRelation *lobbyUsers = [lobby relationForKey:@"lobbyUsers"];
        [lobbyUsers addObject:[PFUser currentUser]];
        [lobby saveInBackground];
        [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}
@end
