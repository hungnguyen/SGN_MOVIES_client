//
//  SGNCinemasCell.m
//  custom table view cell
//
//  Created by TPL2806 on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCinemasListCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation SGNCinemasListCell

@synthesize mainView = _mainView;
@synthesize cinemaName = _cinemaName;
@synthesize cinemaAddress = _cinemaAddress;
@synthesize cinemaPhone = _cinemaPhone;
@synthesize cinemaImage = _cinemaImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SGNCinemasListCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        [_mainView setClipsToBounds:YES];
        [[_mainView layer] setMasksToBounds:YES];
        [[_mainView layer] setCornerRadius:10.0f];

        [[_cinemaImage layer] setMasksToBounds:YES];
        [[_cinemaImage layer] setCornerRadius:10.0f];
    }
    return self;
}

- (void)fillWithData:(NSArray*)data
{
    NSString *image_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [data valueForKey:@"ImageUrl"]];
    
    [_cinemaName setText:[data valueForKey:@"Name"]];
    [_cinemaPhone setText:[data valueForKey:@"Phone"]];
    [_cinemaAddress setText:[data valueForKey:@"Address"]];
    
    [_cinemaImage setUrl:[NSURL URLWithString:image_url]];
    [_cinemaImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_cinemaImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
