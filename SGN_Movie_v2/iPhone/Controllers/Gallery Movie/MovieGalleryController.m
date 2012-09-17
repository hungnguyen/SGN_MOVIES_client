//
//  MovieGalleryController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieGalleryController.h"
#import "SGNManagedImage.h"
#import "AppDelegate.h"
#import "MovieGallery.h"
#import "DataService.h"

@interface MovieGalleryController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation MovieGalleryController

@synthesize movieObjectId = _movieObjectId;
@synthesize data = _data;
@synthesize carousel = _carousel;

#pragma mark Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _carousel.type = iCarouselTypeRotary;
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.data = nil;
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Core Data

- (void)reloadData
{
    NSLog(@"RELOAD DATA");
    NSManagedObjectContext *context = [DataService defaultContext];
    self.data = [MovieGallery selectByMovieId:_movieObjectId context:context];
    [_carousel reloadData];
}

#pragma mark iCarouse DataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_data count];
}

#pragma mark iCarouse Delegate

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 
    CGRect frame = _carousel.frame;
    
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString * urlString = [hostUrl stringByAppendingString:[[_data objectAtIndex:index] 
                                                             valueForKey:@"imageUrl"]];
    SGNManagedImage *posterImage = (SGNManagedImage*)view;
    if(posterImage == nil)
    {
        posterImage = [[SGNManagedImage alloc]initWithFrame:frame];
        [posterImage setImageContentMode:UIViewContentModeScaleAspectFit];
        
        //apply configs below
        posterImage.isConfigImage =  true;
        //scale image to show reflection
        posterImage.reflectionScale = 0.25f;
        //opaque of reflection image
        posterImage.reflectionAlpha = 0.25f;
        //gap between image and its reflection
        posterImage.reflectionGap = 10.0f;
        //shadow behind image
        posterImage.shadowOffset = CGSizeMake(0.0f, 2.0f);
        posterImage.shadowBlur = 5.0f;
        posterImage.shadowColor = [UIColor blackColor]; 
    }
    [posterImage setImageFromURL:urlString];
    
    return posterImage;
}
@end
