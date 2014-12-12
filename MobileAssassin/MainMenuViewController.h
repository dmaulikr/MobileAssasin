//
//  MainMenuViewController.h
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MainMenuViewController : UIViewController
@property(strong,nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL isPlaying;
@property (weak, nonatomic) IBOutlet UIButton *gamesButton;
@property (weak, nonatomic) IBOutlet UIButton *assassinateButton;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *createGameViewTargetButton;
@property (strong,nonatomic) PFObject *lobby;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;



- (IBAction)logoutPressed:(id)sender;
- (IBAction)createGameViewTargetButtonPressed:(id)sender;
- (IBAction)assassinatePressed:(id)sender;
//- (IBAction)assassinatePlayer:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;


@end
