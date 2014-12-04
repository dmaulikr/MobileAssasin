//
//  MainMenuViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   }

-(void)viewWillAppear:(BOOL)animated {
    self.currentUser = [PFUser currentUser];
    if (self.currentUser) {
        if (![self.currentUser objectForKey:@"isPlaying"]) {
            self.assassinateButton.hidden = YES;
            self.separatorLabel.hidden = YES;
            [self.gamesButton setTitle:@"Search for Lobby" forState:(UIControlStateNormal)];
        }
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

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

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (IBAction)createGamePressed:(id)sender {
}
@end
