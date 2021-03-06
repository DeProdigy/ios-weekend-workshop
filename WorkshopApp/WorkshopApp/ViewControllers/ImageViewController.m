//
//  ImageViewController.m
//  WorkshopApp-noxib
//
//  Created by Alfred Hanssen on 11/11/13.
//  Copyright (c) 2013 Alfred Hanssen. All rights reserved.
//

#import "ImageViewController.h"
#import "MediaObject.h"

@interface ImageViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Harsh, but for the sake of simplicity we're quitting if mediaObject == nil at this point
    NSAssert(self.mediaObject != nil, @"self.mediaObject cannot be nil");
    
    self.title = self.mediaObject.username;
    
    // Ensure that our UI elements begin just after the navigationBar rather than beneath it
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupImageView];
}

#pragma mark - Setup

- (void)setupImageView
{
    [self.activityIndicatorView startAnimating];
    
    // Use an NSURLSessionDownloadTask to asynchronously fetch the image
    
    __weak ImageViewController * weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *getImageTask = [session downloadTaskWithURL:self.mediaObject.imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicatorView stopAnimating];
            weakSelf.imageView.image = downloadedImage;
        });
        
    }];
    [getImageTask resume];
}

@end
