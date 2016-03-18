//
//  MBNewsViewController.m
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import "MBNewsViewController.h"
#import "MBNewsCell.h"
#import "MBNewsModel.h"
//义应用屏幕宽度
#define appWidth  [UIScreen mainScreen].bounds.size.width

//定义应用屏幕高度
#define appHeight  [UIScreen mainScreen].bounds.size.height

@interface MBNewsViewController ()
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation MBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, appWidth, appHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉默认下划线
    self.tableView.estimatedRowHeight=200;//预估行高可以提高性能
    [self.view addSubview:_tableView];
}

//懒加载数据源
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        MBNewsModel * group0 = [[MBNewsModel alloc] init];
        group0.title = @"韩寒与小卡丁车手比拼车技(组图)";
        group0.picture = @"icon0.jpg";
        group0.content = @"2015年中国汽车拉力竞标赛11月22日正在浙江省武义举行，著名车手韩寒利用空闲时间来到三美卡丁车赛场，辅导小卡丁车手并同场交流、较量。";
        group0.time = @"20:21";
        group0.newsUrl = @"http://www.baidu.com";
        
        MBNewsModel * group1 = [[MBNewsModel alloc] init];
        group1.title = @"浙江赛赛(媒体杯)卡丁车赛落幕全新赛道试驾体验";
        group1.picture = @"icon1.jpg";
        group1.content = @"11月21日，2015浙江赛赛(媒体杯)卡丁车挑战赛在浙江三美赛车场举行，本次卡丁车挑战赛诚邀媒体众界好友出席比赛现场。";
        group1.time = @"19:29";
        group1.newsUrl = @"http://www.sohu.com";
        
        MBNewsModel * group2 = [[MBNewsModel alloc] init];
        group2.title = @"韩寒与小卡丁车手比拼车技(组图)";
        group2.picture = @"icon2.jpg";
        group2.content = @"11月11日下午，在市中区迫楼路一卡丁车训练场地，22岁的任晨秋正在驾驶一辆卡丁车";
        group2.time = @"10:49";
        group2.newsUrl = @"http://www.qq.com";
        
        MBNewsModel * group3 = [[MBNewsModel alloc] init];
        group3.title = @"韩寒与小卡丁车手比拼车技(组图)";
        group3.picture = @"icon3.jpg";
        group3.content = @"2015年中国汽车拉力竞标赛11月22日正在浙江省武义举行，著名车手韩寒利用空闲时间来到三美卡丁车赛场，辅导小卡丁车手并同场交流、较量。";
        group3.time = @"20:21";
        group3.newsUrl = @"http://www.163.com";
        
        MBNewsModel * group4 = [[MBNewsModel alloc] init];
        group4.title = @"韩寒与小卡丁车手比拼车技(组图)";
        group4.picture = @"icon4.jpg";
        group4.content = @"2015年中国汽车拉力竞标赛11月22日正在浙江省武义举行，著名车手韩寒利用空闲时间来到三美卡丁车赛场，辅导小卡丁车手并同场交流、较量ygygygygygygiygggghghjggygygyugyuguygyugyuguyguygyggu。";
        group4.time = @"20:21";
        group4.newsUrl = @"http://http://www.sina.com.cn";
        
        [_dataSource addObject:group0];
        [_dataSource addObject:group1];
        [_dataSource addObject:group2];
        [_dataSource addObject:group3];
        [_dataSource addObject:group4];
        
    }
    return _dataSource;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * newsCell = @"newsCell";
    MBNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:newsCell];
    if (cell == nil) {
        cell = [[MBNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:225.0/255.0 blue:220.0/255.0 alpha:1.0];
    for (UIView *item in cell.contentView.subviews) {
        [item removeFromSuperview];
    }
    cell.controller = _controller;
    if ([self.dataSource count]>0) {
        MBNewsModel * model = self.dataSource[indexPath.row];
        //        MDDrugVO * service=dataArray[indexPath.row];
        cell.title=model.title;
        cell.content=model.content;
        cell.picture = model.picture;
        cell.time = model.time;
        cell.newsUrl = model.newsUrl;
    }
    
    
    [cell drawCell];
    
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