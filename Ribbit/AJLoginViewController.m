//
//  AJLoginViewController.m
//  Ribbit
//
//  Created by Alberto Jauregui on 2/1/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import "AJLoginViewController.h"
#import <Parse/Parse.h>

@interface AJLoginViewController ()

@end

@implementation AJLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([UIScreen mainScreen].bounds.size.height == 568){
        self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"showSignup"] ){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
