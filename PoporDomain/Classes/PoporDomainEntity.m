//
//  PoporDomainEntity.m
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainEntity.h"

@implementation PoporDomainUE

- (id)initTitle:(NSString *)title withDomain:(NSString *)domain {
    if (self = [super init]) {
        _title  = title;
        _domain = domain;
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation PoporDomainLE

- (id)init {
    if (self = [super init]) {
        _ueArray = [NSMutableArray<PoporDomainUE> new];
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation PoporDomainEntity

- (id)init {
    if (self = [super init]) {
        _leArray = [NSMutableArray<PoporDomainLE> new];
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
