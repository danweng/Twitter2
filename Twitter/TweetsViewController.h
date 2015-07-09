//
//  TweetsViewController.h
//  Twitter
//
//  Created by Dan Weng on 7/2/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftPanelViewController.h"

@protocol TweesViewControllerDelegate <NSObject>;

@optional
-(void)movePanelLeft;
-(void)movePanelRight;

@required
-(void)movePanelToOriginalPosition;

@end


@interface TweetsViewController : UIViewController <LeftPanelViewControllerDelegate>

@property(nonatomic, assign) id<TweesViewControllerDelegate> delegate;

@end
