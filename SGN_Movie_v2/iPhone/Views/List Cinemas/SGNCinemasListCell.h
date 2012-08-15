//
//  SGNCinemasCell.h
//  custom table view cell
//
//  Created by TPL2806 on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"HJCache.h"

@class Cinema;
@interface SGNCinemasListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet HJManagedImageV *cinemaImage;
@property (nonatomic, strong) IBOutlet UILabel *cinemaName;
@property (nonatomic, strong) IBOutlet UILabel *cinemaAddress;
@property (nonatomic, strong) IBOutlet UILabel *cinemaPhone;

- (void)fillWithData:(Cinema*)data;

@end
