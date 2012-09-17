//
//  SGNCustomCell.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNTableViewCellStyleValue2.h"
#import "SGNCellBackGround.h"

@implementation SGNTableViewCellStyleValue2

@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SGNTableViewCellStyleValue2" owner:self options:nil] objectAtIndex:0];    
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
