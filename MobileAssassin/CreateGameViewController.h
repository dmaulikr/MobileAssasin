//
//  CreateGameViewController.h
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CreateGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *lobbyNameText;
@property (weak, nonatomic) IBOutlet UITextField *minPlayerText;
@property (weak, nonatomic) IBOutlet UITextField *maxPlayerText;

- (IBAction)createPressed:(id)sender;
@end
