//
//  ImagePickerChooseCell.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/15.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "ImagePickerChooseCell.h"
#define appWidth  [UIScreen mainScreen].bounds.size.width

@implementation ImagePickerChooseCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ImagePickerChooseCell";
    
    //缓存中取
    ImagePickerChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //创建
    if (!cell)
    {
        
        
        cell = [[ImagePickerChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *imagePickerName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, appWidth, self.contentView.frame.size.height)];
        imagePickerName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:imagePickerName];
        self.imagePickerName = imagePickerName;
        imagePickerName.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
