//
//  PoporDomain.m
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomain.h"

//#import <YYCache/YYCache.h>
//#import <YYModel/YYModel.h>

#import "PoporDomainCC.h"
#import "PoporDomainAssist.h"

static NSString * SaveKey = @"config";

@interface PoporDomain ()
// 初始化的时候,或者清空列表的时候,需要这个数据.
// 初始化UI个数也需要这个数据.
//@property (nonatomic, strong) NSMutableArray<PoporDomainLE *> * netDefaultArray;
@property (nonatomic, strong) PoporDomainEntity * configEntity_default;

@end

@implementation PoporDomain

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporDomain * instance;
    dispatch_once(&once, ^{
        instance = [PoporDomain new];
        //instance.netArray = [NSMutableArray<PoporDomainLE *> new];
        instance.configEntity_default = [PoporDomainEntity new];
        
        // NSString * path = [[NSBundle mainBundle] pathForResource:@"liveCity" ofType:@"json"];
        // NSData   * data = [NSData dataWithContentsOfFile:path];
        // self.SelectAreaEntity = [[SelectAreaEntity alloc] initWithDictionary:data.toDic error:nil];
        
        {
            NSData * data = [NSData dataWithContentsOfFile:[self basePath]];
            if (data) {
                NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData * data1 = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                instance.configEntity = [[PoporDomainEntity alloc] initWithData:data1 error:nil];
                
                
            } else {
                instance.configEntity = [PoporDomainEntity new];
                
            }
            
            //            YYDiskCache *yyDiskCache;
            //            yyDiskCache   = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:SaveKey]];
            //            
            //            yyDiskCache.customArchiveBlock = ^NSData * _Nonnull(id  _Nonnull object) {
            //                NSArray * array = (NSArray *)object;
            //                return [array yy_modelToJSONData];
            //            };
            //            
            //            yyDiskCache.customUnarchiveBlock = ^id _Nonnull(NSData * _Nonnull data) {
            //                // https://blog.csdn.net/qw656567/article/details/52367618
            //                
            //                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //                NSMutableArray * mArray = [NSMutableArray new];
            //                NSArray *array = (NSArray *)jsonObject;
            //                for (id oneID in array) {
            //                    PoporDomainListEntity * le = [PoporDomainListEntity yy_modelWithDictionary:oneID];
            //                    
            //                    [mArray addObject:le];
            //                }
            //                return mArray;
            //            };
            //            instance.yyDiskCache = yyDiskCache;
        }
    });
    return instance;
}

+ (NSString *)basePath {
    static NSString * basePath;
    if (!basePath) {
        basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        basePath = [basePath stringByAppendingPathComponent:@"PoporDomain.json"];
    }
    return basePath;
}

+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainLE *> *)array defaultInfo:(NSString * _Nullable)info {
    PoporDomain * config = [PoporDomain share];
    
    config.configEntity_default.leArray = [array mutableCopy];
    config.defaultInfo = info ? : @"域名修改只对debug版本APP有效";
    
    //config.netArray = (NSMutableArray *)[config.yyDiskCache objectForKey:SaveKey];
    // 判断是否需要更新NetArray
    if (!config.configEntity.leArray ||
        config.configEntity.leArray.count != array.count) {
        [self restoreNetArray];
    } else {
        // 判断是否需要更新NetArray
        BOOL isNeedUpdate = NO;
        for (int i = 0; i<array.count; i++) {
            PoporDomainLE * leDefault = config.configEntity_default.leArray[i];
            PoporDomainLE * leCurrent = config.configEntity.leArray[i];
            
            if (![leDefault.title isEqualToString:leCurrent.title] ) {
                isNeedUpdate = YES;
                break;
            }
            // 检查数组数量是否为空,防止代码出bug.
            if (leCurrent.ueArray.count == 0 &&
                leDefault.ueArray.count != 0) {
                isNeedUpdate = YES;
                break;
            }
        }
        // 发生了变更,需要刷新默认数据
        if (isNeedUpdate) {
            [self restoreNetArray];
        }
    }
}

+ (void)restoreNetArray {
    PoporDomain * config = [PoporDomain share];
    
    [self updateLeTitleWArray:config.configEntity_default.leArray];
    config.configEntity.leArray = config.configEntity_default.leArray.mutableCopy;
    
    [self updateDomainDefault];
}

+ (void)restoreNetArrayAt:(NSInteger)index {
    PoporDomain * config = [PoporDomain share];
    PoporDomainLE * leDefault = config.configEntity_default.leArray[index];
    PoporDomainLE * leCurrent = config.configEntity.leArray[index];
    
    [leCurrent.ueArray addObjectsFromArray:leDefault.ueArray];
    
    [self updateDomainDefault];
}

+ (void)updateLeTitleWArray:(NSMutableArray<PoporDomainLE *> *)array {
    int totalW = 0;
    if (array.count == 0) {
        return;
    }
    for (int i = 0; i<array.count; i++) {
        PoporDomainLE * leCurrent = array[i];
        leCurrent.titleW = [PoporDomainCC cellW:leCurrent.title];
        totalW += leCurrent.titleW;
    }
    
    // 检查是不是少容量的文字
    int maxW = [[UIScreen mainScreen] bounds].size.width - PoporDomainVCXGap*2;
    if (totalW + array.count*PoporDomainCvXyGap <= maxW) {
        int w = maxW/array.count;
        for (int i = 0; i<array.count; i++) {
            PoporDomainLE * leCurrent = array[i];
            leCurrent.titleW = w - PoporDomainCvXyGap;
        }
    }
}

+ (void)updateDomainDefault {
    PoporDomain * config = [PoporDomain share];
    [config.configEntity.toJSONData writeToFile:[self basePath] atomically:YES];
}

+ (void)updateDomain {
    PoporDomain * config = [PoporDomain share];
    [config.configEntity.toJSONData writeToFile:[self basePath] atomically:YES];
    
    if (config.blockUpdateDomain) {
        config.blockUpdateDomain();
    }
}

@end
