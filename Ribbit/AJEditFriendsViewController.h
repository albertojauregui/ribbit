//
//  AJEditFriendsViewController.h
//  Ribbit
//
//  Created by Alberto Jauregui on 2/2/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AJEditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

- (BOOL) isFriend:(PFUser *) user;

@end
