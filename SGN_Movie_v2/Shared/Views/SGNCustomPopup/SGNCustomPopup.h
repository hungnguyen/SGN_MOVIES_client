//
//  SGNCustomPopup.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGNCustomPopup;

@protocol SGNCustomPopupDelegate
@optional
- (void)SGNCustomPopup:(SGNCustomPopup*)customPopup withObjectId:(int)ObjectId;
@end

@interface SGNCustomPopup : UIView

@property (nonatomic, assign) id<SGNCustomPopupDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *srollView;

- (id)initWithNibName:(NSString*)nibNameOrNil;
- (void)setScrollViewData:(NSArray*)data;
- (void)popUp;
@end
