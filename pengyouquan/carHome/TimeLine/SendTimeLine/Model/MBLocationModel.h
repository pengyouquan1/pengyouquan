//
//  MBLocationModel.h
//  pengyouquan
//
//  Created by 巫筠 on 16/3/22.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    City = "天津市";
//    Country = "中国";
//    CountryCode = CN;
//    FormattedAddressLines =     (
//                                 "中国天津市河西区大营门街道芜湖道"
//                                 );
//    Name = "富力中心";
//    State = "天津市";
//    Street = "芜湖道";
//    SubLocality = "河西区";
//    Thoroughfare = "芜湖道";
//}

@interface MBLocationModel : NSObject

@property (nonatomic,copy) NSString * City;
@property (nonatomic,assign) NSArray * FormattedAddressLines;
@property (nonatomic,copy) NSString * Name;
@property (nonatomic,copy) NSString * Street;
@property (nonatomic,copy) NSString * SubLocality;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
