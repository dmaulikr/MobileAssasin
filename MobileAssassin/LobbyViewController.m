//
//  LobbyViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 12/6/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "LobbyViewController.h"
#import "MBProgressHUD.h"

@implementation LobbyViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor lightGrayColor];
    [tableView setBackgroundView:bview];
    
    
    self.playersRelation = [self.lobby relationForKey:@"lobbyUsers"];
    PFQuery *query = [self.playersRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *players, NSError *error) {
        if (error) {
            //something went wrong
        }else {
            self.players = [NSMutableArray arrayWithArray:players];
            [tableView reloadData];
        }
    }];
    NSLog(@"%@",  self.lobby[@"lobbyName"]);
    self.navigationItem.title = self.lobby[@"lobbyName"];
    
    _lobbyInfo.numberOfLines = 0;
    _lobbyInfo.text = [NSString stringWithFormat: @"Lobby Name : %@ \nCreated By : %@ \nLobby Full : %@ \nMaximum Player : %@ \nMinimum Player : %@", self.lobby[@"lobbyName"], self.lobby[@"createdBy"], self.lobby[@"isFull"], self.lobby[@"maxPlayer"], self.lobby[@"minPlayer"]];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.players count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.players objectAtIndex:indexPath.row] username];
    return cell;
}

- (IBAction)joinPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you Sure?" message:@"Are you sure to join this lobby?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
  
  
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Pressed 0");
    } else {
        self.confirmedJoin = FALSE;
        HUD = [[MBProgressHUD alloc] initWithWindow:self.view.window];
        [self.view.window addSubview:HUD];
        HUD.labelText = @"Doing funky stuff...";
        HUD.detailsLabelText = @"Just relax";
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
        [self.playersRelation addObject:[PFUser currentUser]];
        [self.players addObject:[PFUser currentUser]];
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"TargetList"];
        [query whereKey:@"assassinName" equalTo:[[PFUser currentUser] username]];
        PFObject *targetList = [query getFirstObject];
         targetList[@"isPlaying"] = [NSNumber numberWithBool:YES];
        [targetList saveInBackground];
        NSNumber *currentPlayer = self.lobby[@"currentPlayer"];
        int currentPlayerInt = [currentPlayer integerValue] + 1;
        NSLog(@"current players: %d" , currentPlayerInt);
        int maxplayersInt = [self.lobby[@"maxPlayer"] integerValue];
        NSLog(@"current players: %d" , maxplayersInt);
        if (maxplayersInt == currentPlayerInt ) { //adding one since we will add one if not max players
            NSLog(@"will assign lobby is full to yes");
            self.lobby[@"isFull"] = [NSNumber numberWithBool:YES];
        }
        self.lobby[@"currentPlayer"] = [NSNumber numberWithInt:currentPlayerInt];
        [self.lobby save];
                if ([self.lobby[@"isFull"] boolValue]) {
                    NSLog(@"Lobby is full, will assign targets");
                    [self assignTargets:self.players];
                }
        [self.navigationController popToRootViewControllerAnimated:YES];
     
    }
}

- (void)doSomeFunkyStuff {
    float progress = 0.0;
    
    while (progress < 1.0) {
        progress += .25;
        HUD.progress = progress;
        [NSThread sleepForTimeInterval:.5];
    }
}
    
-(void)assignTargets:(NSMutableArray *) playerlist{
    // create temporary autoreleased mutable array
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[playerlist count]];
    
    for (id anObject in playerlist)
    {
        NSUInteger randomPos = arc4random()%([tmpArray count]+1);
        [tmpArray insertObject:anObject atIndex:randomPos];
    }
    for (int i =0; i < [tmpArray count]; i++){
        
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"TargetList"];
        [query whereKey:@"assassinName" equalTo: [tmpArray objectAtIndex:i][@"username"]];
        PFObject *targetList = [query getFirstObject];
        if (i == [tmpArray count] - 1){ //last one
            targetList[@"targetName"]  = [tmpArray objectAtIndex:0][@"username"]; // make a relatiuonship in a future
        }else { //not last one
          
            targetList[@"targetName"]  = [tmpArray objectAtIndex:i+1][@"username"]; // make a relatiuonship in a future
        }
        NSLog(@"targetlist saved");
        
        targetList[@"isPlaying"] = [NSNumber numberWithBool:YES];
        [targetList saveInBackground];
    }

    
    }

@end
