//
//  SignupViewController.m
//  MobileAssassin
//
//  Created by Enrique Jose Padilla on 11/29/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "SignupViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)signupPressed:(id)sender {
    
    NSString *username = [self.usernameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0 || password.length == 0 || email.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure to enter a username, password and email adress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else {
        
        if (self.image != nil) {
            
            // Resize image
            UIImage *newImage = [self resizeImage:self.image toWidth:568.0f andHeight:480.0f];
            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05f);
            
            PFFile *file = [PFFile fileWithName:@"ProfilePic.jpg" data:imageData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured!" message:@"Please try sending message again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    PFUser *newUser = [PFUser user];
                    newUser.username = username;
                    newUser.password = password;
                    newUser.email = email;
                
                    [newUser setObject:file forKey:@"selfiePic"];	
                    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message: [error.userInfo objectForKey:@"error"]delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            [alertView show];
                        }
                        else {
                            PFObject *targetList = [[PFObject alloc] initWithClassName:@"TargetList"];
                            targetList[@"assassinName"] = newUser.username;
                            targetList[@"isPlaying"] = [NSNumber numberWithBool:NO];
                            targetList[@"targetName"] = @"";
                            [targetList saveInBackground];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Selfie taken!" message:@"Please try taking a selfie" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (IBAction)selfieButtonPressed:(id)sender {
    
    if(!self.image)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        else {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}



#pragma mark - Image picker Controller Delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*) kUTTypeImage]) {
        //photo taken/selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
            NSLog(@"testing.. entered camera image");
            
            /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Selfie Image" message:@"Selfie taken successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alertView show];*/
            
        }
        else if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            NSLog(@"testing.. entered photolibrary");
        }
        
        self.selfieStatus.hidden = NO;
        self.selfieStatus.text = @"Profile pic choosen";
        
    }
    else { // if mediatype is video
        
        NSLog(@"testing.. entered video");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not permitted" message:@"Take only a picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
