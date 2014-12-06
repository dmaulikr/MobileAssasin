//
//  DisplayLobbyDetailsTableViewController.h
//  MobileAssassin
//
//  Created by Swetha RK on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DisplayLobbyDetailsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, retain) NSString *lobbyName;
@property (nonatomic, strong) NSMutableArray *currentPlayers;
@property(strong,nonatomic) PFUser *currentUser;
@property (nonatomic, retain) UIBarButtonItem *rightNavButton;
@property (nonatomic, retain) UIBarButtonItem *leftNavButton;

- (IBAction)signUpPressed:(id)sender;
- (IBAction)joinPressed:(id)sender;

@end
