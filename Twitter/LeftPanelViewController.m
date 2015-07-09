//
//  LeftPanelViewController.m
//  Twitter
//
//  Created by Dan Weng on 7/8/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "MainViewController.h"

@interface LeftPanelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *tableData;
@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableData = [[NSMutableArray alloc] initWithObjects:@"Profile",@"Home timeline",@"Mentions",@"Sign Out",nil];
    
    [self.tableView reloadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"geekPic.jpg"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    
    switch (selectedRow) {
        case 0:{
            //[_delegate movePanelToOriginalPosition]; todo
            UIViewController *nvc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self presentViewController:nvc animated:YES completion: nil];
            break;
        }
        case 1:
            break;
        default:
            break;
    }
    NSLog(@"touch on row %d", selectedRow);
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
