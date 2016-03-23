//
//  SDTimeLineTableViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDBaseTableViewController.h"
#import "SDTimeLineCellModel.h"

//定义应用屏幕宽度
#define appWidth  [UIScreen mainScreen].bounds.size.width

//定义应用屏幕高度
#define appHeight  [UIScreen mainScreen].bounds.size.height
@interface SDTimeLineTableViewController : SDBaseTableViewController<UITextFieldDelegate>
-(void)Actiondo:(id)sender;
-(void)comment:(SDTimeLineCellCommentItemModel *)commentItemModelold circlesId:(NSString *)circlesId;


//-(void)replayMessage:(SDTimeLineCellCommentItemModel *)commentItemModelold;

-(void)SessionManager:(NSString *)TextView picArray:(NSArray *)picArray;

@end
