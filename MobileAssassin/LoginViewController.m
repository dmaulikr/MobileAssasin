//
//  LoginViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = TRUE;
    self.passwordText.delegate = self;
    // Do any additional setup after loading the view.
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



- (IBAction)loginPressed:(id)sender {
    NSString *username = [self.usernameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0 || password.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure to enter a username and password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (error) {
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message: [error.userInfo objectForKey:@"error"]delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                [alertView show];
                                            }
                                            else {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }
                                            
                                        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginPressed:self];
    return YES;
}
@end
