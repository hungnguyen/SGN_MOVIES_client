//
//  CinemaGalleryController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CinemaGalleryController.h"
#import "CinemaGallery.h"
#import "AppDelegate.h"
#import "SGNDataService.h"
#import "SGNManagedImage.h"

#import "SGNBannerView.h"

@interface CinemaGalleryController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation CinemaGalleryController

@synthesize cinemaObjectId = _cinemaObjectId;
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
    
    //Google AdMob
    SGNBannerView *bannerView = [[SGNBannerView alloc] initWithNibName:@"SGNBannerView"];
    [self.view addSubview:bannerView];
    [bannerView start];
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
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    self.data = [CinemaGallery selectByCinemaId:_cinemaObjectId context:context];
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
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString * urlString = [hostUrl stringByAppendingString:[[_data objectAtIndex:index] 
                                                             valueForKey:@"imageUrl"]];
    SGNManagedImage *posterImage = (SGNManagedImage*)view;
    if(posterImage == nil)
    {
        posterImage = [[SGNManagedImage alloc]initWithFrame:_carousel.frame];
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