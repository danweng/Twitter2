//
//  LeftPanelViewController.h
//  Twitter
//
//  Created by Dan Weng on 7/8/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LeftPanelViewControllerDelegate <NSObject>


@end

@interface LeftPanelViewController : UIViewController

@property(nonatomic, assign) id<LeftPanelViewControllerDelegate>delegate;

@end
