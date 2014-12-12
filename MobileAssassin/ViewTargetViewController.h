//
//  ViewTargetViewController.h
//  MobileAssassin
//
//  Created by Swetha RK on 12/11/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewTargetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *targetProfileImage;
@property(strong,nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *targetName;

@end
