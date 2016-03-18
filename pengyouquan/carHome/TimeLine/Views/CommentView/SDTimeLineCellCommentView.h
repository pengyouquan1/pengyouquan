//
//  SDTimeLineCellCommentView.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SDTimeLineCell.h"
#import "GlobalDefines.h"

@interface SDTimeLineCellCommentView : UIView

@property (nonatomic, assign) SDTimeLineCell * lineCell;


- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@end
