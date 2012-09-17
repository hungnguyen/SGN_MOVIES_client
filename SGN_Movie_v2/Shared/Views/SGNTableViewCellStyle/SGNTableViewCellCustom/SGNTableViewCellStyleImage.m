//
//  SGNCustomImageCell.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNTableViewCellStyleImage.h"

@implementation SGNTableViewCellStyleImage

@synthesize movieImage = _movieImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SGNTableViewCellStyleImage" owner:self options:nil] objectAtIndex:0];    
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
