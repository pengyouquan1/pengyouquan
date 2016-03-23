//
//  LocationViewController.h
//  MyFamily
//
//  Created by 陆洋 on 15/7/14.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setLocationTextDelegate <NSObject>

-(void)setLocationTextWithText:(NSString *)text;

@end
@interface MBLocationViewController : UITableViewController
@property (nonatomic,weak) id<setLocationTextDelegate>delegate;

@end
