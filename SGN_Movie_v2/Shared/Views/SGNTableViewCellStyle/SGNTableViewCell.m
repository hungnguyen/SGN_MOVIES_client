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

@synthesize contentColor = _contentColor;
@synthesize titleColor = _titleColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[SGNCellBackGround alloc] init];
        //self.selectedBackgroundView.layer.cornerRadius = 0.0f;
        self.titleColor = [UIColor colorWithRed:TABLE_CELL_TITLECOLOR_RED 
                                            green:TABLE_CELL_TITLECOLOR_GREEN 
                                             blue:TABLE_CELL_TITLECOLOR_BLUE 
                                            alpha:1];
        
        self.contentColor = [UIColor colorWithRed:TABLE_CELL_CONTENTCOLOR_RED 
                                          green:TABLE_CELL_CONTENTCOLOR_GREEN 
                                           blue:TABLE_CELL_CONTENTCOLOR_BLUE 
                                          alpha:1];
        
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
        self.titleColor = [UIColor colorWithRed:TABLE_CELL_TITLECOLOR_RED 
                                          green:TABLE_CELL_TITLECOLOR_GREEN 
                                           blue:TABLE_CELL_TITLECOLOR_BLUE 
                                          alpha:1];
        
        self.contentColor = [UIColor colorWithRed:TABLE_CELL_CONTENTCOLOR_RED 
                                            green:TABLE_CELL_CONTENTCOLOR_GREEN 
                                             blue:TABLE_CELL_CONTENTCOLOR_BLUE 
                                            alpha:1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
