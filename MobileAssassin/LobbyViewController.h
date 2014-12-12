//
//  LobbyViewController.h
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 12/6/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@class MBProgressHUD;

@interface LobbyViewController: UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
IBOutlet UITableView *tableView;
    MBProgressHUD *HUD;
}

@property (strong,nonatomic) NSMutableArray *players;
@property (strong,nonatomic) PFObject *lobby;
@property (strong,nonatomic) PFRelation *playersRelation;
@property  (nonatomic) BOOL confirmedJoin;
@property (weak, nonatomic) IBOutlet UILabel *lobbyInfo;



- (IBAction)joinPressed:(id)sender;

@end
