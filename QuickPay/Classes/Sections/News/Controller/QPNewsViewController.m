//
//  QPNewsViewController.m
//  QuickPay
//
//  Created by Nie on 2016/10/25.
//  Copyright © 2016年 Nie. All rights reserved.
//

#import "QPNewsViewController.h"
#import "NewsTableViewCell.h"
#import "QPHttpManager.h"
#import "QPNewsDetailsViewController.h"
static NSString *const cellIdentifier = @"NewsTableViewCell";

@interface QPNewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic,strong) NSArray *NewsNamelabArry;
@property (nonatomic,strong) NSArray *InfolabArry;


@end

@implementation QPNewsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self getNews];
}

#pragma mark - configureSubViews
-(void)configureTableView
{
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.backgroundColor = UIColorFromHex(0xf8f8f8);
    self.homeTableView.delegate = self;
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.homeTableView.showsVerticalScrollIndicator = NO;
    [self.homeTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:self.homeTableView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.leftView.image = [UIImage imageNamed:@"xiaoxi_logo"];
    cell.NewsNameLabel.text = [self.NewsNamelabArry[indexPath.section] objectForKey:@"name"];
    cell.InfoLabel.text = [self.NewsNamelabArry[indexPath.section] objectForKey:@"key"];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QPNewsDetailsViewController * newsDetailsVC = [[QPNewsDetailsViewController alloc]init];
    newsDetailsVC.newsDetailsDict = self.NewsNamelabArry[indexPath.row];
    [self.navigationController pushViewController:newsDetailsVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 10))];
    timeLabel.backgroundColor = [UIColor clearColor];
//    timeLabel.font = [UIFont systemFontOfSize:12];
//    timeLabel.textColor = RGBACOLOR(138, 140, 146, 1);
//    timeLabel.text = @"10月20日";
//    timeLabel.textAlignment = NSTextAlignmentCenter;
    return timeLabel;
}
- (void)getNews{
    WEAKSELF();
    [QPHttpManager getNewsCompletion:^(id responseData) {
        if ([[responseData objectForKey:@"resp_code"] isEqualToString:@"0000"]) {
            STRONGSELF();
            strongSelf.NewsNamelabArry = [[NSArray alloc]init];
            strongSelf.InfolabArry = [[NSArray alloc]init];
            strongSelf.NewsNamelabArry = [responseData objectForKey:@"list"];
            [strongSelf.homeTableView reloadData];
        } else {
            [[QPHUDManager sharedInstance]showTextOnly:[responseData objectForKey:@"resp_msg"]];
        }
        
    }failure:^(NSError *error) {
        [[QPHUDManager sharedInstance]hiddenHUD];
        [[QPHUDManager sharedInstance]showTextOnly:error.localizedDescription];
        
    }];
}

@end
