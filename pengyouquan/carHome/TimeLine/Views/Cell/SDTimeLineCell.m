//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineCellCommentView.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIImageView+WebCache.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    SDTimeLineCellCommentView *_commentView;
    BOOL _shouldOpenContentLabel;
    UIView * commentView;
}

@synthesize controller;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    _shouldOpenContentLabel = NO;
    
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    commentView = [UIView new];
    commentView.backgroundColor=[UIColor colorWithRed:77/255.0 green:81.0/255.0 blue:84.0/255.0 alpha:1.0];
    commentView.layer.cornerRadius=4;
    commentView.hidden=YES;
    UIButton * button1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [button1 setBackgroundColor:[UIColor clearColor]];
    [button1 setTitle:@"赞" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(zan) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont systemFontOfSize:14];
    [commentView addSubview:button1];
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(79, 2, 1, 22)];
    back.backgroundColor=[UIColor colorWithRed:65/255.0 green:69/255.0 blue:72/255.0 alpha:1.0];
    [commentView addSubview:back];
    UIButton * button2=[[UIButton alloc] initWithFrame:CGRectMake(80, 0, 80, 25)];
    [button2 setBackgroundColor:[UIColor clearColor]];
    [button2 setTitle:@"评论" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(ping:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font=[UIFont systemFontOfSize:14];
    [commentView addSubview:button2];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
    [self.contentView addGestureRecognizer:tapGesture];
    
    
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [SDTimeLineCellCommentView new];
    _commentView.lineCell=self;
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel, _operationButton, _commentView,commentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15)
    .autoHeightRatio(0);
    
    _operationButton.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    commentView.sd_layout
    .rightSpaceToView(contentView,40)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(160);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度

}


- (void)setModel:(SDTimeLineCellModel *)model
{
    _model = model;
    
    _commentView.frame = CGRectZero;
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    _shouldOpenContentLabel = NO;
    
//    _iconView.image = [UIImage imageNamed:model.iconName];
    if ([model.iconName count]) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:[model.iconName[0] objectForKey:@"circlesPic"]] placeholderImage:[UIImage imageNamed:@"icon0.jpg"]];
    }else{
        [_iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon0.jpg"]];
    }

    
    _nameLable.text = model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _contentLabel.text = model.msgContent;
//    _picContainerView.picPathStringsArray = model.picNamesArray;
    NSMutableArray * ary=[NSMutableArray new];
    for (int i=0; i<[model.picNamesArray count]; i++) {
        [ary addObject:[model.picNamesArray[i] objectForKey:@"circlesPic"]];
    }
    _picContainerView.picPathStringsArray =[ary copy];
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        _commentView.fixedWith = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        _commentView.sd_layout.topSpaceToView(_timeLabel, 0);
        bottomView = _timeLabel;
    } else {
        _commentView.fixedHeight = nil; // 取消固定宽度约束
        _commentView.fixedWith = nil; // 取消固定高度约束
        _commentView.sd_layout.topSpaceToView(_timeLabel, 10);
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = @"1分钟前";
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)operationButtonClicked
{
    if(commentView.hidden){
        commentView.hidden=NO;
    }else {
        commentView.hidden=YES;
    }
}
-(void)zan
{
    commentView.hidden=YES;
    
}
-(void)ping:(UIButton *)button
{
    [self pinglun:nil];
}
-(void)pinglun:(SDTimeLineCellCommentItemModel *)commentItemModel
{
    commentView.hidden=YES;
    if (commentItemModel) {
        [self.controller comment:commentItemModel circlesId:_model.circlesId];
    }else{
        [self.controller comment:nil  circlesId:_model.circlesId];
    }
}
-(void)Actiondo
{
    commentView.hidden=YES;
    [self.controller Actiondo:nil];
}
//-(void)replayMessage:(SDTimeLineCellCommentItemModel *)commentItemModel
//{
//    [self.controller replayMessage:commentItemModel];
//}
@end
