//
//  AJLoginViewController.h
//  Ribbit
//
//  Created by Alberto Jauregui on 2/1/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)login:(id)sender;

@end
