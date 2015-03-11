//
//  AJCameraViewController.h
//  Ribbit
//
//  Created by Alberto Jauregui on 2/3/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AJCameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

- (void) uploadMessage;
- (UIImage *)resizeImage:(UIImage *) image toWidth:(float)width andHeight:(float)height;

@end
