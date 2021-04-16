//
//  PoporDomain.h
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PoporDomainEntity.h"
#import "PoporDomainVC.h"

typedef void(^PoporDomainPVoid) (void);

NS_ASSUME_NONNULL_BEGIN

@interface PoporDomain : NSObject
/*
 目前只针对一个页面的情形, 多情形的还没遇到.
 */

@property (nonatomic, strong) PoporDomainEntity * configEntity;
@property (nonatomic, strong) NSString          * defaultInfo;

// 点击新的域名选项、新增、删除的回调
@property (nonatomic, copy  ) PoporDomainPVoid    blockUpdateDomain;

+ (instancetype)share;

// 假如数组个数 <= 1,将隐藏infoCV.
+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainLE *> *)array defaultInfo:(NSString * _Nullable)info;

+ (void)restoreNetArrayAt:(NSInteger)index;

+ (void)updateDomain;

@end

NS_ASSUME_NONNULL_END
