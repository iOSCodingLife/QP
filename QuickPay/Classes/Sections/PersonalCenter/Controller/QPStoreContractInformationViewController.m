//
//  QPStoreContractInformationViewController.m
//  QuickPay
//
//  Created by Nie on 2016/11/11.
//  Copyright © 2016年 Nie. All rights reserved.
//

#import "QPStoreContractInformationViewController.h"
#import "QPStoreContractInformationTableViewCell.h"
#import "QPAgreementTermsTableViewCell.h"
#import "QPAgreementAndTermsViewController.h"
#import "QPHttpManager.h"

static NSString *const cellIdentifier = @"QPStoreContractInformationTableViewCell";
static NSString *const cellIdentifier1 = @"QPAgreementTermsTableViewCell";


@interface QPStoreContractInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *homeTableView;
@property(nonatomic,strong)NSArray *typelabArry;
@property(nonatomic,strong)NSArray *ratelabArry;
@property(nonatomic,strong)NSArray *typeimageArry;
@property(nonatomic,strong)NSMutableDictionary *RateDict;
@end

@implementation QPStoreContractInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleToNavBar:@"店铺签约信息"];
    [self createBackBarItem];
    self.view.backgroundColor = UIColorFromHex(0xf8f8f8);
    [self configureTableView];
    [self getRate];
};
#pragma mark - configureSubViews
-(void)configureTableView
{
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.backgroundColor=[UIColor clearColor];
    self.homeTableView.delegate = self;
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.homeTableView.showsVerticalScrollIndicator = NO;
    [self.homeTableView registerClass:[QPStoreContractInformationTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.homeTableView registerClass:[QPAgreementTermsTableViewCell class] forCellReuseIdentifier:cellIdentifier1];
    [self.view addSubview:self.homeTableView];
    
    self.typelabArry = @[@"微信收款",@"支付宝收款",@"京东收款",@"QQ钱包"];
//    self.ratelabArry = @[@"0.38%",@"0.6%",@"0.6%",@"0.4%"];
    self.typeimageArry = @[@"jiesuan_weixin",@"jiesuan_zhifubao",@"jiesuan_jingdong",@"jiesuan_qq"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    } else {
        
        return  1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            QPStoreContractInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.typeLab.text = self.typelabArry[indexPath.row];
//            cell.rateLab.text = self.ratelabArry[indexPath.row];
            if (indexPath.row == 0) {
                NSString *str1;
                str1 = [NSString stringWithFormat:@"%0.2f",[self.RateDict[@"ratet1_wx"] floatValue]*100];
                NSString *str2 = @"%";
                cell.rateLab.text = [NSString stringWithFormat:@"%@%@",str1,str2];
            }
            if (indexPath.row == 1) {
                NSString *str1;
                str1 = [NSString stringWithFormat:@"%0.2f",[self.RateDict[@"ratet1_zfb"] floatValue]*100];
                NSString *str2 = @"%";
                cell.rateLab.text = [NSString stringWithFormat:@"%@%@",str1,str2];
            }
            if (indexPath.row == 2) {
                cell.rateLab.text = @"---";
            }
            if (indexPath.row == 3) {
                cell.rateLab.text = @"---";
            }
            cell.typeimage.image = [UIImage imageNamed:self.typeimageArry[indexPath.row]];
            return cell;
        }
            break;
            
        case 1:
        {
            QPAgreementTermsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 1) {
        QPAgreementAndTermsViewController *QPagreetermVC = [[QPAgreementAndTermsViewController alloc]init];
        [self.navigationController pushViewController:QPagreetermVC animated:YES];
        NSLog(@"协议与条款");
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 30))];
        view.backgroundColor = UIColorFromHex(0xf8f8f8);
        UILabel *rateLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 120, 30)];
        rateLab.text = @"费率";
        rateLab.font=[UIFont systemFontOfSize:14];
        rateLab.textColor = [UIColor blackColor];
        [view addSubview:rateLab];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else {
        return 10.0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)getRate{
    WEAKSELF();
    [QPHttpManager getRateCompletion:^(id responseData) {
        if ([[responseData objectForKey:QP_ResponseCode] isEqualToString:QP_Response_SuccsessCode]) {
            STRONGSELF();
            self.RateDict = responseData;
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
