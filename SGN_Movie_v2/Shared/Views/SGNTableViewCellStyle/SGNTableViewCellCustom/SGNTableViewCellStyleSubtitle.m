//
//  SGNTableViewCellStyleSubtitle.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNTableViewCellStyleSubtitle.h"

@implementation SGNTableViewCellStyleSubtitle

@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SGNTableViewCellStyleSubtitle" owner:self options:nil] lastObject];
    if (self) 
    {
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
