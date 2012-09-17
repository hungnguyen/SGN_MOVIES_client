//
//  SGNTableViewCell.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGNTableViewCell : UITableViewCell

- (id)initWithNibName:(NSString*)nibNameOrNil;

@property (strong, nonatomic) UIColor *contentColor;
@property (strong, nonatomic) UIColor *titleColor;

@end
