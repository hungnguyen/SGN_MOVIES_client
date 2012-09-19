//
//  SGNAdmob.h
//  admob
//
//  Created by TPL2806 on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface SGNBannerView : UIView <GADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet GADBannerView *gAdBannerView;
@property (strong, nonatomic) IBOutlet UIImageView *closeImageView;
@property (strong, nonatomic) IBOutlet UIView *closeView;

- (void) start;
- (id)initWithNibName:(NSString*)nibNameOrNil;

@end
