//
//  SDTimeLineTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//
#import "SDTimeLineTableViewController.h"
#import "SDTimeLineTableHeaderView.h"
#import "SDRefresh.h"
//#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MBNewsViewController.h"
#import "MBSendTimeLineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"


#define kTimeLineTableViewCellId @"SDTimeLineCell"
#define PATH @"http://139.196.172.196:8082/yueche/yuecheApp/appCirclesList"
#define CommentPATH @"http://139.196.172.196:8082/yueche/yuecheApp/appCirclesComment"
// http:// 139.196.172.196:8082/yueche/yuecheApp
//appCirclesComment
//http://115.28.108.41:8080/yueche/yuecheApp/appCirclesList?customerId=101
@implementation SDTimeLineTableViewController

{
    SDRefreshFooterView *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    UISegmentedControl * segmentedControl;
    UIView * view;
    UITextField * textField;
    SDTimeLineCellCommentItemModel *commentItemOld;
    MBNewsViewController * news;
    NSString * _circlesId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"iconfont-jiahao"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendTimeLine) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _circlesId = [[NSString alloc] init];
    segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 180.0f, 30.0f) ];
    [segmentedControl insertSegmentWithTitle:@"车友圈" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"新闻" atIndex:1 animated:YES];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    segmentedControl.momentary = NO;//设置在点击后是否恢复原样
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(segmentedSelected:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    //评论
    view=[[UIView alloc] initWithFrame:CGRectMake(0, appHeight-40, appWidth, 40)];
    view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    view.hidden=YES;
    [self.parentViewController.view addSubview:view];
    textField=[[UITextField alloc] initWithFrame:CGRectMake(8, 4, appWidth-16, 40-8)];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.backgroundColor=[UIColor whiteColor];
    textField.placeholder = @"评论";
    textField.tag=1000;
    [textField setValue:[UIFont boldSystemFontOfSize:(15*(appWidth>320?appWidth/320:1))] forKeyPath:@"_placeholderLabel.font"];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate=self;
    [view addSubview:textField];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Actiondo:) name:UIKeyboardWillHideNotification object:nil];
    //点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture];
    //新闻页面
    news=[[MBNewsViewController alloc] init];
    news.view.frame=CGRectMake(0, 0, appWidth, appHeight);
    news.controller=self;

    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    __weak typeof(self) weakSelf = self;
    
    
    // 上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
            [weakSelf.tableView reloadData];
            [weakRefreshFooter endRefreshing];
        });
    };
//    self.tableView.frame=CGRectMake(0, 169, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-169);
    
    SDTimeLineTableHeaderView *headerView = [SDTimeLineTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 69);
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    [self gitData];
}
-(void)gitData
{
    NSString * customeId = @"1";
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    [session POST:PATH parameters:@{@"customerId":customeId} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *resArr = [NSMutableArray new];
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * messageArray= [dic objectForKey:@"data"];
        
        if ([[dic objectForKey:@"msg"] isEqualToString:@"接口：车友圈-车友圈消息列表--成功..."]) {
            
            for (int i = 0; i<[messageArray count]; i++) {
                SDTimeLineCellModel *model = [SDTimeLineCellModel new];
                model.iconName = [messageArray[i] objectForKey:@"picUrl"];
                model.name = [messageArray[i] objectForKey:@"userName"];
                model.msgContent =[messageArray[i] objectForKey:@"circlesContext"];
//                model.circlesId = [messageArray[i] objectForKey:@"id"]; // 车友圈id
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            
                model.circlesId = [numberFormatter stringFromNumber:[messageArray[i] objectForKey:@"id"]];
//                NSLog(@"%@========%@",[messageArray[i] objectForKey:@"id"],model.circlesId);
                model.picNamesArray = [messageArray[i] objectForKey:@"picUrl"];
                [resArr addObject:model];
                
                NSArray *namesArray = @[@"GSD_iOS",
                                        @"风口上的猪",
                                        @"当今世界网名都不好起了",
                                        @"我叫郭德纲",
                                        @"Hello Kitty"];
                NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                                           @"正宗好凉茶，正宗好声音。。。",
                                           @"你好，我好，大家好才是真的好",
                                           @"有意思",
                                           @"你瞅啥？",
                                           @"瞅你咋地？？？！！！",
                                           @"hello，看我",
                                           @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真，再回首恍然如梦，再回首我心依旧，只有那不变的长路伴着我",
                                           @"人艰不拆",
                                           @"咯咯哒",
                                           @"呵呵~~~~~~~~",
                                           @"我勒个去，啥世道啊",
                                           @"真有意思啊你💢💢💢"];
                int commentRandom = arc4random_uniform(6);
                NSMutableArray *tempComments = [NSMutableArray new];
                for (int i = 0; i < commentRandom; i++) {
                    SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
                    int index = arc4random_uniform((int)namesArray.count);
                    commentItemModel.firstUserName = namesArray[index];
                    commentItemModel.firstUserId = @"666";
                    if (arc4random_uniform(10) < 5) {
                        commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                        commentItemModel.secondUserId = @"888";
                    }
                    commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
                    [tempComments addObject:commentItemModel];
                }
                model.commentItemsArray = [tempComments copy];


            }
            
            
            
            [self.dataArray addObjectsFromArray:[resArr copy]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];
    
}

-(void)segmentedSelected:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 1:

            [self.view addSubview:news.view];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

            self.navigationItem.rightBarButtonItem.customView.hidden=YES;
            
            self.tableView.scrollEnabled=NO;
            break;
        case 0:
            self.navigationItem.rightBarButtonItem.customView.hidden=NO;

            [news.view removeFromSuperview];
            self.tableView.scrollEnabled=YES;

            
            break;
        default:
            break;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake([UIScreen mainScreen].bounds.size.width-50, 45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if(segmentedControl.selectedSegmentIndex==0)
                {
//                    weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
                   
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf gitData];
                    [weakHeader endRefreshing];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf.tableView reloadData];
//                    });
                }else{
                    [weakHeader endRefreshing];

                }
            });
        }];
        [self.tableView.superview addSubview:_refreshHeader];
    }
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
}

-(void)sendTimeLine
{
    MBSendTimeLineViewController * sendTimeLineVC = [[MBSendTimeLineViewController alloc] init];
    UINavigationController * nvc=[[UINavigationController alloc] initWithRootViewController:sendTimeLineVC];
//    UINavigationBar *bar = [UINavigationBar appearance];
//    //设置显示的颜色
//    bar.barTintColor = [UIColor blackColor];
    sendTimeLineVC.controller=self;
    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nvc animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    cell.controller=self;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            NSLog(@"%lu-----%@----%@",(unsigned long)[weakSelf.dataArray count],model.name,model.circlesId);
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}




- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    view.frame=CGRectMake(0, appHeight-height-40, appWidth, 40);
}
-(void)comment:(SDTimeLineCellCommentItemModel *)commentItemModelold circlesId:(NSString *)circlesId
{
    if (commentItemModelold) {
        commentItemOld=commentItemModelold;

    }else{
        commentItemOld=nil;
    }
    _circlesId = circlesId;
    [textField becomeFirstResponder];
    view.hidden=NO;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
    commentItemModel.firstUserName = @"新人";
    commentItemModel.firstUserId = @"666";
    commentItemModel.commentString = textField.text;
    if (commentItemOld) {
        commentItemModel.secondUserName = commentItemOld.firstUserName;
        commentItemModel.secondUserId = commentItemOld.firstUserId;
    }
    __weak typeof(self) weakSelf = self;
    int index;
    for (int i=0; i<[weakSelf.dataArray count];i++ ) {
        SDTimeLineCellModel * model =weakSelf.dataArray[i];
        
        if ([_circlesId isEqualToString:model.circlesId]) {
            index=i;
            break;
        }
    }
    
    SDTimeLineCellModel * model =weakSelf.dataArray[index];
//    NSArray * commentItemArray=model.commentItemsArray;
    NSMutableArray *commentItemArray=[[NSMutableArray alloc] initWithArray:model.commentItemsArray];
    [commentItemArray addObject:commentItemModel];
    model.commentItemsArray = [commentItemArray copy];
    NSLog(@"%lu---%@",(unsigned long)[weakSelf.dataArray count],commentItemArray);
    weakSelf.dataArray[index]= model;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
   
    
    
    
    
    NSString * customeId = @"1";
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSLog(@"-----------%@",model.circlesId);
    [session POST:CommentPATH parameters:@{@"customerId":customeId,@"circlesId":model.circlesId,@"commentContext":textField.text} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *resArr = [NSMutableArray new];
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * messageArray= [dic objectForKey:@"data"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];
    
    
    
    
    
    
    
    [self Actiondo:nil];
    return YES;
}

-(void)Actiondo:(id)sender{
    [textField resignFirstResponder];
    view.hidden = YES;
    [textField setText:@""];
    view.frame=CGRectMake(0, appHeight-40, appWidth, 40);
}
-(void)SessionManager:(NSString *)TextView picArray:(NSArray *)picArray
{
    SDTimeLineCellModel *model = [SDTimeLineCellModel new];
    model.iconName = nil;
    model.name = @"新人";
    model.msgContent =TextView;
//        model.circlesId = [messageArray[i] objectForKey:@"id"]; // 车友圈id
//    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
//    model.circlesId = [numberFormatter stringFromNumber:[messageArray[i] objectForKey:@"id"]];
    //                NSLog(@"%@========%@",[messageArray[i] objectForKey:@"id"],model.circlesId);
    model.circlesId = @"1000000";
    
    model.picNamesArray = picArray;
//    [self.dataArray addObject:model];
    [self.dataArray insertObject:model atIndex:0];
    [self.tableView reloadData];
    
    
}
@end
