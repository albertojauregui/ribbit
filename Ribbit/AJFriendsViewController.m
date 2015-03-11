//
//  AJFriendsViewController.m
//  Ribbit
//
//  Created by Alberto Jauregui on 2/2/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import "AJFriendsViewController.h"
#import "AJEditFriendsViewController.h"
#import "GravatarUrlBuilder.h"

@interface AJFriendsViewController ()

@end

@implementation AJFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"%@ %@", error, [error userInfo]);
        }else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showEditFriends"]){
        AJEditFriendsViewController *viewController = (AJEditFriendsViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *email = [user objectForKey:@"email"];
        NSURL *gravatarUrl = [GravatarUrlBuilder getGravatarUrl:email];
        NSData *imageData = [NSData dataWithContentsOfURL:gravatarUrl];
        
        if(imageData != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = [UIImage imageWithData:imageData];
                [cell setNeedsLayout];
            });
        }
    });
    
    cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    
    return cell;
}

@end
