//
//  TweetsViewController.m
//  Twitter
//
//  Created by Dan Weng on 7/2/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import <SVProgressHUD.h>
#import <objc/runtime.h>

@interface TweetsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *blueColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    
    UIImage *image = [UIImage imageNamed:@"hamburger"];
    CGRect frame = CGRectMake(0, 0, 25, 25);
    
    //init a normal UIButton using that image
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    
    //finally, create your UIBarButtonItem using that button
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    button.tag = 1;
    
    //set the button to handle clicks - this one calls a method called 'downloadClicked'
    [button addTarget:self action:@selector(movePanelRight:) forControlEvents:UIControlEventTouchDown];
    
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    
    navitems.leftBarButtonItem = barButtonItem;
    navitems.title=@"Twitter";
    navbar.tintColor = [UIColor whiteColor];
    navbar.barTintColor = blueColor;
    navbar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
    
                                                                                                
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
    
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    self.tableview.estimatedRowHeight = 100;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self getTimeLine];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)getTimeLine{
    [[TwitterClient SharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error){
        
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        [self.tableview reloadData];
    }];
}

-(void)movePanelRight:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
            [_delegate movePanelToOriginalPosition];
            btn.tag = 1;
            break;
        case 1:
            [_delegate movePanelRight];
            btn.tag = 0;
            break;
        default:
            break;
    }
}

-(void)onCreate{

}

- (void)onLogout{
    [User logout];
}

-( NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
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
