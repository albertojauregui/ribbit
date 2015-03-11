//
//  AJCameraViewController.m
//  Ribbit
//
//  Created by Alberto Jauregui on 2/3/14.
//  Copyright (c) 2014 Alberto Jauregui. All rights reserved.
//

#import "AJCameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MSCellAccessory.h"

@interface AJCameraViewController ()

@end

@implementation AJCameraViewController

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc] init];
    
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
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
    
    if(self.image == nil && [self.videoFilePath length] == 0){
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;

        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];

        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if([self.recipients containsObject:user.objectId]){
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    }else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];

    if(cell.accessoryView == nil){
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        [self.recipients addObject:user.objectId];
    }else{
        cell.accessoryView = nil;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - Image picker controller delegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        // photo was taken or selected!
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            // save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }else{
        // a video was taken or selected!
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            // save the video
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks - IBActions

- (IBAction)cancel:(id)sender {
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    if(self.image == nil && [self.videoFilePath length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please capture or select a photo or video to share!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }else{
        [self uploadMessage];
        
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma marks - Helper methods

- (void) uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if(self.image != nil){
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }else{
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                }else{
                    // Everything was successful!
                    [self reset];
                }
            }];
        }
    }];
}


- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
