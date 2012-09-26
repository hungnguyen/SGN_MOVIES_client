
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
        //add image view
        _imageView = [[SGNManagedImage alloc] initWithFrame:CGRectZero];
        _imageView.imageContentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
        
        //add version view
        _versionView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _versionView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_versionView];

        //add content label
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont fontWithName:FONTNAME size:12];
        _contentLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_contentLabel];
    }
    return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil
{
    //load default NibName if does not have
    if(nibNameOrNil == nil || [nibNameOrNil isEqualToString:@""])
        nibNameOrNil = @"SGNCustomPopup";
    self = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    
    if(self)
    {
        //Init
        _imageView.imageContentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [_imageView clear];
}

@end
