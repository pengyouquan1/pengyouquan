//
//  MBNewsCell.h
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTimeLineTableViewController.h"

@interface MBNewsCell : UITableViewCell

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * picture;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) SDTimeLineTableViewController * controller;
@property (nonatomic,strong) NSString * newsUrl;

-(void)drawCell;

@end
