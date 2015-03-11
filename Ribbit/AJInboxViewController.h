//
//  AJInboxViewController.h
//  Ribbit
//
//  Created by Alberto Jauregui on 2/1/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AJInboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (IBAction)logout:(id)sender;

@end
