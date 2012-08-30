//
//  SGNCustomPopup.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@class SGNCustomPopup;

@protocol SGNCustomPopupDelegate <NSObject>
@optional
- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObject:(id)object;
@end

@interface SGNCustomPopup : UIView <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, assign) id<SGNCustomPopupDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

- (id)initWithNibName:(NSString*)nibNameOrNil;
- (void)loadViewWithData:(NSArray*)data;
- (void)popUp;
- (void)popDown:(id)sender;
@end
