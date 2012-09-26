//
//  PSBroView.h
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCollectionViewCell.h"
#import "SGNManagedImage.h"

@interface SGNCollectionViewCell : PSCollectionViewCell

@property (nonatomic, strong) IBOutlet SGNManagedImage *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *versionView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

- (id)initWithNibName:(NSString*)nibNameOrNil;

@end
