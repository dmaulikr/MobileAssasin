//
//  AssasinateViewController.h
//  MobileAssassin
//
//  Created by Harleen Kaur on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssasinateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *toBeAssasinatePlayerButton;
@property (weak, nonatomic) IBOutlet UILabel *labelTargetInRange;
@property (weak, nonatomic) IBOutlet UILabel *labelTargetNotInRange;

- (IBAction)assassinateButtonPressed:(id)sender;

@end
