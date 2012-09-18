
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

@interface SGNCollectionViewCell ()
@end

@implementation SGNCollectionViewCell

@synthesize imageView = _imageView;
@synthesize versionView = _versionView;
@synthesize contentLabel = _contentLabel;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (SGNManagedImage*)imageView
{
    if(!_imageView)
    {
        //add image view
        _imageView = [[SGNManagedImage alloc] initWithFrame:CGRectZero];
        _imageView.imageContentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView*)versionView
{
    if(!_versionView)
    {
        //add version view
        _versionView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _versionView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_versionView];
    }
    return _versionView;
}

- (UILabel*)contentLabel
{
    if(!_contentLabel)
    {
        //add content label
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont fontWithName:TABLE_CELL_FONTNAME size:12];
        _contentLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void)layoutSubviews 
{
    if(_imageView)
    {
        _imageView.frame = CGRectInset(self.bounds, POSTER_MARGIN, POSTER_MARGIN);
    }
    if(_versionView)
    {
        _versionView.frame = CGRectMake(self.bounds.size.width - 32, 2, 30, 30);
        //    _versionView.frame = CGRectMake(5, self.bounds.size.height - 20 - POSTER_MARGIN,
        //                                    self.bounds.size.width - 2 * POSTER_MARGIN, 20);        
    }
    if(_contentLabel)
    {
        _contentLabel.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
    }

}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [_imageView clear];
}

@end
