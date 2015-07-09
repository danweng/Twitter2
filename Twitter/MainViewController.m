//
//  MainViewController.m
//  Twitter
//
//  Created by Dan Weng on 7/1/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "LeftPanelViewController.h"
#import "QuartzCore/QuartzCore.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <TweesViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) TweetsViewController *tweetsViewController; //centerview
@property (nonatomic, strong) LeftPanelViewController  *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setupView];
}


- (void)setupView{
    self.tweetsViewController = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    self.tweetsViewController.view.tag = CENTER_TAG;
    self.tweetsViewController.delegate = self;
    [self.view addSubview:self.tweetsViewController.view];
    [self addChildViewController:_tweetsViewController];

    [_tweetsViewController didMoveToParentViewController:self];
    [self setupGestures];
}

- (UIView *) getLeftView{
    if (_leftPanelViewController == nil) {
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _tweetsViewController;
        
        [self.view addSubview:self.leftPanelViewController.view];
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        
    }
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    
    return view;
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset{
    
    if(value){
        [_tweetsViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_tweetsViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_tweetsViewController.view.layer setShadowOpacity:0.8];
        [_tweetsViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }else{
        [_tweetsViewController.view.layer setCornerRadius:0.0f];
        [_tweetsViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(void)movePanelRight{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{_tweetsViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
            if (finished) {
                _tweetsViewController.navigationItem.rightBarButtonItem.tag=0;
            }
        }];
}

-(void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{_tweetsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);} completion:^(BOOL finished){ if (finished) { [self resetMainView]; }}];
}

-(void) resetMainView {
    if(_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        _tweetsViewController.navigationItem.rightBarButtonItem.tag = 1;
        self.showingLeftPanel = NO;
    }
    [self showCenterViewWithShadow:NO withOffset:0];
}

-(void)setupGestures{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_tweetsViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
           childView = [self getLeftView];
        }
        // make sure the view we're working with is front and center
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
        _showPanel = abs([sender view].center.x - _tweetsViewController.view.frame.size.width/2) > _tweetsViewController.view.frame.size.width/2;
        
        // allow dragging only in x coordinates by only updating the x coordinate with translation position
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        // if you needed to check for a change in direction, you could use this code to do so
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
