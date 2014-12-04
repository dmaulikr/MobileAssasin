//
//  MainMenuViewController.h
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MainMenuViewController : UIViewController
@property(strong,nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UIButton *gamesButton;
@property (weak, nonatomic) IBOutlet UIButton *assassinateButton;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;


- (IBAction)logoutPressed:(id)sender;
@end
