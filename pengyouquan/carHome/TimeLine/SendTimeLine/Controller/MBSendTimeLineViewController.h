//
//  MBSendTimeLineViewController.h
//  朋友圈发布
//
//  Created by 巫筠 on 16/3/18.
//  Copyright © 2016年 巫筠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSendTimeLineViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSString * location;

-(void)openCamera;

@end
