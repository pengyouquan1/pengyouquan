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

#define kTimeLineTableViewCellId @"SDTimeLineCell"

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
    view=[[UIView alloc] initWithFrame:CGRectMake(0, appHeight/2, appWidth, 40)];
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
    
    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    __weak typeof(self) weakSelf = self;
    
    
    // 上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
            [weakSelf.tableView reloadData];
            [weakRefreshFooter endRefreshing];
        });
    };
//    self.tableView.frame=CGRectMake(0, 169, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-169);
    
    SDTimeLineTableHeaderView *headerView = [SDTimeLineTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 69);
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
}
-(void)segmentedSelected:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 1:
//            self.tableView.hidden=YES;
//            news.view.hidden=NO;
            
            [self.view addSubview:news.view];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

//            [self.tableView removeFromSuperview];
//            news.view.hidden = NO;
            
//            contactTableView.showsVerticalScrollIndicator = YES;
//            mxTableView.hidden = YES;
//            mxTableView.showsVerticalScrollIndicator = NO;
//            [self.view bringSubviewToFront:self.tableView];
            self.tableView.scrollEnabled=NO;
            break;
        case 0:
//            self.tableView.hidden=NO;
//            //            news.view.hidden=NO;
//            
//            [self.view addSubview:self.tableView];
            [news.view removeFromSuperview];
            self.tableView.scrollEnabled=YES;

//            news.view.hidden = YES;
//            
            //            [self.view addSubview:mxTableView];
            //            [contactTableView removeFromSuperview];
            //            contactTableView.hidden = YES;
            //            contactTableView.showsVerticalScrollIndicator = NO;
            //            mxTableView.hidden = NO;
            //            mxTableView.showsVerticalScrollIndicator = YES;
//                        [self.view bringSubviewToFront:news.view];
            
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
                    weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
                    [weakHeader endRefreshing];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
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
    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nvc animated:YES completion:nil];}

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"北京最高大上的卡丁车馆了！不像其他室内卡丁车，一进去就会闻见浓浓的烧油味道。这家居然是电动车控制车辆，设施很新，车速又快又好操控。赛道也很新，地面超平整。两楼的休息区也很大。就算人很多需要排队玩赛车，也可在楼上愉快的边玩耍边等待。唯一需要注意的是，高德导航标注的位置是错误的，建议大家快到前可电话给店家咨询一下去往路线。",
                           @"一想到玩卡丁车，感觉新鲜又刺激，这次终于成行啦。地方有点偏，不过场地蛮大，环境也不错。据说是北京最好的卡丁车赛馆之一。一走进去，大堂宽敞明亮，服务有序，摆放着各式卡丁车，非常霸气。",
                           @"环境不错，总体体验很好，满意，办了会员卡，继续消费了。说说一个细节，绿灯亮了该发车的时候，发现别人都有安全带，我没有，赶紧跟工作人员招手，带了头盔，工作人员听不见我说什么，一直跟我示意让我开车走，没系安全带，哪里敢走…… 直到他们过来，帮我系上，说是忘了。一个大写的囧……",
                           @"由于是第一次，230cc的没敢玩，在赛道外面听到发动机的轰鸣其实还是有点紧张。     放好东西，带上头套，然后戴上眼镜，最后带上头盔，头盔比想象中重，虽然是晚上，还是有点热，但并不影响呼吸。接下来就要挤进狭小紧凑的座位，硬硬的座位刚好能紧紧包裹住半个上半身和屁股，然后系紧安全带，能嘞住腰部和双肩，没有靠枕，没有换挡，左脚刹车，右脚油门，操作相对简单。     工作人员启动发动机后，深踩油门开始上道了，感觉的速度比实际速度要快一些。 讲讲操控。过弯费劲，没有方向助力，转向比很小，轮胎还很宽，像我这样的麒麟臂在过弯时也觉得有点费劲，上半身和脖子也得跟着一起保持平衡，游戏中能做到的最佳过弯路线，在现实中不一定能完成。感觉很棒",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
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
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        model.circlesId = [NSString stringWithFormat:@"%d",1000+i]; // 车友圈id
        
        // 模拟“随机图片”
        int random = arc4random_uniform(10);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        
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
        
        [resArr addObject:model];
    }
    return [resArr copy];
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
    weakSelf.dataArray[index]= model;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
   
    [self Actiondo:nil];
    return YES;
}

-(void)Actiondo:(id)sender{
    [textField resignFirstResponder];
    view.hidden = YES;
    [textField setText:@""];
}
@end
