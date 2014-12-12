//
//  MainMenuViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OpenGamesTableViewController.h"
#import  <Parse/Parse.h>
#import "AppDelegate.h"
#import "AssasinateViewController.h"


@interface MainMenuViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic) BOOL *bluetoothNotEnabled;
@property (strong,nonatomic) PFObject *queryResult;
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;


-(NSMutableArray*) _searchResults;

@end

@implementation MainMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _bluetoothNotEnabled = YES;
    
   
   }

-(void)viewWillAppear:(BOOL)animated {
    self.currentUser = [PFUser currentUser];
    NSLog(@"%@",self.currentUser.username);
    [self.refreshButton setTitle:self.currentUser.username forState:UIControlStateNormal];
    if (self.currentUser) {
        //place currentusername in the the new icon next to he nivagtioncontroller title
        //check the targetlist 
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"TargetList"];
        [query whereKey:@"assassinName" equalTo:[[PFUser currentUser] username]];
        PFObject *targetList = [query getFirstObject];
        self.isPlaying = [[targetList objectForKey:@"isPlaying"] boolValue];
        NSLog(_isPlaying ? @"Yes" : @"No");
        if (!_isPlaying) { // user is not in a lobby
            NSLog(@"Entering the if not isplaying");
            self.assassinateButton.hidden = YES;
            self.separatorLabel.hidden = YES;
             self.createGameViewTargetButton.hidden = NO;
            self.labelText.hidden = YES;
            [self.gamesButton setTitle:@"Search for Lobby" forState:(UIControlStateNormal)];
             [self.createGameViewTargetButton setTitle:@"Create Game" forState:(UIControlStateNormal)];
        
            }
        else { //he is in a lobby, have to check he has a target
            if ([targetList[@"targetName"] isEqualToString:@""]) { //game hasn't started
                NSLog(@"Game hasnt Started");
                self.createGameViewTargetButton.hidden = YES;
                self.assassinateButton.hidden = YES;
                self.separatorLabel.hidden = YES;
                self.labelText.hidden = NO;
                    }
            else { //game hasn't started
                self.createGameViewTargetButton.hidden = NO;
                self.labelText.hidden = YES;
                [self.createGameViewTargetButton setTitle:@"View Target" forState:(UIControlStateNormal)];
                self.assassinateButton.hidden = NO;
                self.separatorLabel.hidden = NO;
                //add bluetooth method here
                _appDelegate.peer.targetPlayer = [targetList[@"targetName"] stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceCharacterSet]];
                if (self.bluetoothNotEnabled){
                    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    //TO-DO : set target name in place of device name
                    [[_appDelegate peer] setupPeerAndSessionWithDisplayName:[[PFUser currentUser] username]];
                   
                     [[_appDelegate peer] advertiseSelfInNetwork:YES];
                    self.bluetoothNotEnabled = NO;
                    NSLog(@"BT set Up");
                    
                }
                [self.gamesButton setTitle:@"View Current Game" forState:(UIControlStateNormal)];
                   }
                }
    }
    else
    { //not logged in
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"viewGamesSegue"])
    {
                   
        
    }

}
*/
- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (IBAction)createGameViewTargetButtonPressed:(id)sender {
    if (self.isPlaying) {
        [self performSegueWithIdentifier:@"showTarget" sender:self];
    } else {
        [self performSegueWithIdentifier:@"showCreateGame" sender:self];
    }
}


//adding for bluetooth peer connectivity
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


//to search for bluetooth devices
- (IBAction)assassinatePressed:(id)sender {
    [[_appDelegate peer] setupMCBrowser];
    [[[_appDelegate peer] browser] setDelegate:self];
    
    [self presentViewController:[[_appDelegate peer] browser] animated:YES completion:nil];
    
}




- (IBAction)refreshButtonPressed:(id)sender {
    [self viewWillAppear:YES];
}
@end
