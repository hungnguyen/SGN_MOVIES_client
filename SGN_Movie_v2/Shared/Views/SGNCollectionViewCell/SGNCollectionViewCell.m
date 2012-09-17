//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "SGNCollectionViewCell.h"
#import "SGNManagedImage.h"
#import "Movie.h"
#import "AppDelegate.h"



@interface SGNCollectionViewCell ()
@property (nonatomic, retain) SGNManagedImage *imageView;
@property (nonatomic, retain) UIImageView *versionView;
@end

@implementation SGNCollectionViewCell

@synthesize imageView = _imageView;
@synthesize versionView = _versionView;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //add image view
        self.imageView = [[SGNManagedImage alloc] initWithFrame:CGRectZero];
        _imageView.imageContentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
        
        //add version view
        self.versionView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _versionView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_versionView];
    }
    return self;
}

- (void)layoutSubviews 
{
    _imageView.frame = CGRectInset(self.bounds, POSTER_MARGIN, POSTER_MARGIN);
    
    _versionView.frame = CGRectMake(self.bounds.size.width - 32, 2, 30, 30);
//    _versionView.frame = CGRectMake(5, self.bounds.size.height - 20 - POSTER_MARGIN,
//                                    self.bounds.size.width - 2 * POSTER_MARGIN, 20);
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [_imageView clear];
}

- (void)fillViewWithObject:(id)object 
{
    [self prepareForReuse];
    Movie *movie = (Movie*)object;
    
    //add image
    NSString *hostUrl = [AppDelegate currentDelegate].rightMenuController.provider.hostUrl;
    NSString *image_url = [hostUrl stringByAppendingString:movie.imageUrl];
    [_imageView setImageFromURL:image_url];

    //add version
    if([movie.version contains:@"3d"])
        _versionView.image = [UIImage imageNamed:@"3d.png"];
    else if([movie.version contains:@"2d"])
        _versionView.image = [UIImage imageNamed:@"2d.png"];
    else 
        _versionView.image = [UIImage imageNamed:@""];
}

@end
