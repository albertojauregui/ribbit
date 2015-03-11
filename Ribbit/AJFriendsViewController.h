//
//  AJFriendsViewController.h
//  Ribbit
//
//  Created by Alberto Jauregui on 2/2/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AJFriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
