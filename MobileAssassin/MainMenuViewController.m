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

@interface MainMenuViewController ()

-(NSMutableArray*) _searchResults;
-(NSMutableArray*) _lobbyPlayers;

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

-(NSMutableArray*) _lobbyPlayers
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
    // Do any additional setup after loading the view.
   }

-(void)viewWillAppear:(BOOL)animated {
    self.currentUser = [PFUser currentUser];
    NSLog(@"%@", self.currentUser.username);
    if (self.currentUser) {
           BOOL isPlaying = [[self.currentUser objectForKey:@"isPlaying"] boolValue];
        NSLog(isPlaying ? @"Yes" : @"No");
        if (!isPlaying) {
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
    
    unsigned long count = [self._searchResults count];
    if(count != 0 )
    {
        [self._searchResults removeAllObjects];
    }
    
    unsigned long count1 = [self._lobbyPlayers count];
    if(count1 != 0 )
    {
        [self._lobbyPlayers removeAllObjects];
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
    
    unsigned long count1= [self._lobbyPlayers count];
    if(count1 != 0 )
    {
        [self._lobbyPlayers removeAllObjects];
    }
    
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
        NSLog(@"viewGamesSegue - lobby Array Count =%lu", count);

        for(int i = 0; i < count; i++)
        {
            //Get the players list for the given lobby
            PFRelation *relation = [lobbyEntryArray[i] relationForKey:@"lobbyUsers"];
            [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
               if (error) {
                    // There was an error
                }
               else {
                      LobbyInfo *entry = [[LobbyInfo alloc]init];
                      entry.lobbyName = lobbyEntryArray[i][@"lobbyName"];
                      unsigned long userCount = [objects count];
                      NSLog(@"viewGamesSegue - userCount =%lu", userCount);
                   
                      for (int j = 0; j < userCount ; j++)
                      {
                        NSString *username = [[NSString alloc] init];
                        username = [objects[j] objectForKey:@"username" ];
                        [self._lobbyPlayers  addObject:username ];
                      } //end of for
                   
                   entry.currentplayers = self._lobbyPlayers;
                   NSLog(@"viewGamesSegue - userCount after loop =%lu", [entry.currentplayers count]);
                                                                         
                    entry.minNumOfPlayers = [[lobbyEntryArray[i] objectForKey:@"minPlayer"] intValue];
                    entry.maxNumOfPlayers = [[lobbyEntryArray[i] objectForKey:@"maxPlayer"] intValue];
                   //entry.isPrivate = [[lobbyEntryArray[i] objectForKey:@"isPrivate"] boolValue];
                   //entry.currentplayers = lobbyEntryArray[i][@"lobbyUsers"];
                   entry.isFull = NO;
                
                   NSLog(@"**********************");
                   NSLog(@"viewGamesSegue - userCount =%lu", userCount);
                   NSLog(@"entry.lobbyName %@", entry.lobbyName);
                   NSLog(@"entry.minPlayer %d", entry.minNumOfPlayers);
                   NSLog(@"entry.maxPlayer %d", entry.maxNumOfPlayers);
                   NSLog(@"entry.isFull %d", entry.isFull);
                   NSLog(@"entry.lobbyName %@", entry.lobbyName);
                   NSLog(@"entry.userCount %lu", [entry.currentplayers count]);
                   
                   [self._searchResults addObject:entry];
                   NSLog(@"self.searchResult count%lu", [self._searchResults count]);
                   NSLog(@"**********************");

                   if ( i == count-1)
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           NSLog(@"Invoking Open games list tableCntlr");
                           OpenGamesTableViewController *tableCtrlr = [segue destinationViewController];
                           tableCtrlr.lobbyArray = self._searchResults;
                           [tableCtrlr.tableView reloadData];
                       });
                   
               } // end of else
             
            }]; // end of relation query
        } //end of for
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
