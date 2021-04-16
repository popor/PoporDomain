//
//  PoporDomainEntity.h
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

#define PoporDCE(title, domain) [[PoporDomainUE alloc] initTitle:title withDomain:domain]

static CGFloat PoporDomainVCXGap  = 20;
static CGFloat PoporDomainCvXyGap = 1; // 左右上下间隔

@protocol  PoporDomainUE;
@interface PoporDomainUE : JSONModel

@property (nonatomic, strong) NSString * _Nullable title;
@property (nonatomic, strong) NSString * domain;

- (id)initTitle:(NSString *)title withDomain:(NSString *)domain;

@end

@protocol  PoporDomainLE;
@interface PoporDomainLE : JSONModel

@property (nonatomic, strong) NSString  * title; // 更改名字之后,将全部更新.
@property (nonatomic, strong) NSString  * domain;// 当前选择的域名
@property (nonatomic        ) CGFloat     titleW;// title 所占用的宽度
@property (nonatomic        ) NSInteger   selectIndex;

@property (nonatomic, strong) NSMutableArray<PoporDomainUE> * ueArray;

@end


@protocol  PoporDomainEntity;
@interface PoporDomainEntity : JSONModel

@property (nonatomic, strong) NSMutableArray<PoporDomainLE> * leArray;

@end

NS_ASSUME_NONNULL_END
