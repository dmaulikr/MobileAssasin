//
//  MainMenuViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OpenGamesTableViewController.h"
#import "LobbyInfo.h"
#import  <Parse/Parse.h>
#import "AppDelegate.h"
#import "AssasinateViewController.h"

@interface MainMenuViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController;

-(NSMutableArray*) _searchResults;

@end

@implementation MainMenuViewController

// static array initialization
-(NSMutableArray*) _searchResults
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //here we have to set Player name instead of device name
    [[_appDelegate peer] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate peer] advertiseSelfInNetwork:YES];
    
   }


// Peer lost, when player go out of range
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Session Manager lost peer: %@", peerID);
    
}

//delegate for assassinatePlayer button
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.peer.browser dismissViewControllerAnimated:YES completion:nil];
}

//delegate for assassinatePlayer button
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.peer.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    self.currentUser = [PFUser currentUser];
    NSLog(self.currentUser.username);
    if (self.currentUser) {
           BOOL isPlaying = [[self.currentUser objectForKey:@"isPlaying"] boolValue];
        NSLog(isPlaying ? @"Yes" : @"No");
        //changing for testing
        //if (!isPlaying) {
        if (isPlaying) {
            NSLog(@"Entering the if isplaying");
            self.assassinateButton.hidden = YES;
            self.separatorLabel.hidden = YES;
            [self.gamesButton setTitle:@"Search for Lobby" forState:(UIControlStateNormal)];
        } else {
            self.assassinateButton.hidden = NO;
            self.separatorLabel.hidden = NO;
            [self.gamesButton setTitle:@"View Current Game" forState:(UIControlStateNormal)];
        }
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Testing MainMenuViewController:viewDidAppear");
    
    unsigned long count = [self._searchResults count];
    if(count != 0 )
    {
        [self._searchResults removeAllObjects];
    }
    
}

//to search for bluetooth devices
- (IBAction)assassinatePlayer:(id)sender {
    [[_appDelegate peer] setupMCBrowser];
    [[[_appDelegate peer] browser] setDelegate:self];
    
    [self presentViewController:[[_appDelegate peer] browser] animated:YES completion:nil];
    
}

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"viewGamesSegue"])
    {
        NSLog(@"Testing viewGamesSegue");
        
        PFQuery *query = [PFQuery queryWithClassName:@"Lobby"];
        [query whereKey:@"isFull" equalTo:[NSNumber numberWithBool:NO]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *lobbyEntryArray, NSError *error) {
            
        unsigned long count = [lobbyEntryArray count];

        for(int i = 0; i < count; i++)
        {
            LobbyInfo *entry = [[LobbyInfo alloc]init];
            entry.lobbyName = lobbyEntryArray[i][@"lobbyName"];
            entry.minNumOfPlayers = [[lobbyEntryArray[i] objectForKey:@"minPlayer"] intValue];
            entry.maxNumOfPlayers = [[lobbyEntryArray[i] objectForKey:@"maxPlayer"] intValue];
            
            [[self _searchResults] addObject:entry];
  
            if ( i == count-1)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    OpenGamesTableViewController *tableCtrlr = [segue destinationViewController];
                    tableCtrlr.gamesArray = [self _searchResults];
                    [tableCtrlr.tableView reloadData];
                });
            }
        }];
        
    }
    
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (IBAction)createGamePressed:(id)sender {
}
@end
