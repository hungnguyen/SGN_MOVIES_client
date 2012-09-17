//
//  SGNDefaultCellStyle.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGNManagedImage.h"
#import "SGNTableViewCell.h"

@interface SGNTableViewCellStyleDefault : SGNTableViewCell

@property (strong, nonatomic) IBOutlet SGNManagedImage *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
