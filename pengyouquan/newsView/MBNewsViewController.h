//
//  MBNewsViewController.h
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTimeLineTableViewController.h"

@interface MBNewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) SDTimeLineTableViewController * controller;


@end
