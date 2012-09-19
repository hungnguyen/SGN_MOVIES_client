//
//  SGNTableViewCell.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNTableViewCell.h"
#import "SGNCellBackGround.h"

@implementation SGNTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[SGNCellBackGround alloc] init];
        //self.selectedBackgroundView.layer.cornerRadius = 0.0f;        
    }
    return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil
{
    self = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] lastObject];
    if(self)
    {
        self.backgroundView = [[SGNCellBackGround alloc] init];
        //self.selectedBackgroundView.layer.cornerRadius = 0.0f;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
