//
//  ViewTargetViewController.m
//  MobileAssassin
//
//  Created by Swetha RK on 12/11/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "ViewTargetViewController.h"

@interface ViewTargetViewController ()

@end

@implementation ViewTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@" ViewTargetViewController called");
 
    self.currentUser = [PFUser currentUser];
    
   
            // Search for current user in TargetList class
            PFQuery *query = [PFQuery queryWithClassName:@"TargetList"];
            [query whereKey:@"assassinName" equalTo:self.currentUser.username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                PFObject *queryResult = [query getFirstObject];
                //get targetName for a given assassin name
                NSString * targetName = [queryResult objectForKey:@"targetName"];
                NSLog(@" ViewTargetViewController called, targetName=%@", targetName);
                
                // Search for targetName in User class
                PFQuery *targetQuery = [PFUser query];
                [targetQuery whereKey:@"username" equalTo:targetName];
                PFObject *matchingUser = [targetQuery getFirstObject];
                
                PFFile *imageFile = [matchingUser objectForKey:@"selfiePic"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        NSLog(@" ViewTargetViewController called, loading image");
                        UIImage *image = [UIImage imageWithData:data];
                        self.targetProfileImage.image = image;
                        self.targetName.text = targetName;
                        
                    }
                }];
            }];
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

@end
