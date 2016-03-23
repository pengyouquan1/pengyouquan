//
//  MBNewsCell.m
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import "MBNewsCell.h"
#import "MX_MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import "MBNewsWebViewController.h"
#import "UIImageView+WebCache.h"

@implementation MBNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawCell
{
    UIImageView * headImg = [[UIImageView alloc] init];
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.picture] placeholderImage:[UIImage imageNamed:@"icon0.jpg"]];
    headImg.layer.cornerRadius = 25.0;
    headImg.layer.masksToBounds = YES;
    headImg.backgroundColor = [UIColor whiteColor];
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(25);
        make.top.equalTo(self.mas_top).with.offset(30);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.text = self.title;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textColor = [UIColor blackColor];
    [titleLab sizeToFit];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).with.offset(8);
        make.centerY.equalTo(headImg.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:77.0/255.0 blue:47.0/255.0 alpha:1.0];
    bgView.layer.cornerRadius = 8;
    //添加点击手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToWeb)];
    [bgView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_left);
        make.right.equalTo(titleLab.mas_right);
        make.top.equalTo(headImg.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UILabel * contentLab = [[UILabel alloc] init];
    contentLab.text = self.content;
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont boldSystemFontOfSize:13];
    contentLab.textColor = [UIColor whiteColor];
    [contentLab sizeToFit];
    [self addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).with.offset(8);
        make.right.equalTo(bgView.mas_right).with.offset(-40);
        make.centerY.equalTo(bgView.mas_centerY);
        make.top.equalTo(bgView.mas_top).with.offset(12);
    }];
    
    UILabel * timeLab = [[UILabel alloc] init];
    timeLab.text = self.time;
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.numberOfLines = 0;
    timeLab.font = [UIFont boldSystemFontOfSize:11];
    timeLab.textColor = [UIColor whiteColor];
    [timeLab sizeToFit];
    [self addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).with.offset(-10);
        make.bottom.equalTo(bgView.mas_bottom).with.offset(-3);
    }];
    
    [bgView mas_updateConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_left);
        make.right.equalTo(titleLab.mas_right);
        make.top.equalTo(headImg.mas_bottom).with.offset(8);
        make.bottom.equalTo(contentLab.mas_bottom).with.offset(8);
    }];
    
    UIImageView * arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"箭头"];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MX_MASConstraintMaker *make) {
        make.left.equalTo(contentLab.mas_right).with.offset(17);
        make.centerY.equalTo(contentLab.mas_centerY);
    }];

}

-(void)pushToWeb
{
    MBNewsWebViewController * newsWebVC = [[MBNewsWebViewController alloc] init];
    newsWebVC.newsUrl = self.newsUrl;
    [self.controller.navigationController pushViewController:newsWebVC animated:YES];
}












@end
