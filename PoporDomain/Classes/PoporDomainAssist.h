//
//  PoporDomainAssist.h
//  PoporDomain
//
//  Created by popor on 2021/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporDomainAssist : NSObject

+ (CGSize)sizeInFont:(UIFont * _Nonnull)font str:(NSString *)str;
+ (CGSize)sizeInFont:(UIFont * _Nonnull)font width:(CGFloat)width str:(NSString *)str;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
