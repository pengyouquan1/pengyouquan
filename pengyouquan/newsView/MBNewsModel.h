//
//  MBNewsModel.h
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

//"id": 13,
//"newsHead": "http://7xroyt.com1.z0.glb.clouddn.com/4583096736940251.png",
//"newsTitle": "测试数据4",
//"isDel": "N",
//"createTime": 1458347533000,
//"newsContext"

@interface MBNewsModel : NSObject
//@property (nonatomic,strong) NSString * title;
//@property (nonatomic,strong) NSString * picture;
//@property (nonatomic,strong) NSString * time;
//@property (nonatomic,strong) NSString * content;
//@property (nonatomic,strong) NSString * newsUrl;

@property (nonatomic,assign) NSInteger id;
@property(nonatomic,strong) NSString * newsHead;
@property(nonatomic,strong) NSString * isDel;
@property(nonatomic,strong) NSString * newsContext;
@property(nonatomic,copy) NSString * createTime;
@property(nonatomic,strong) NSString * newsTitle;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
