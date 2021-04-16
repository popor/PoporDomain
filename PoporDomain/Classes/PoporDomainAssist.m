//
//  PoporDomainAssist.m
//  PoporDomain
//
//  Created by popor on 2021/4/8.
//

#import "PoporDomainAssist.h"

@implementation PoporDomainAssist

+ (CGSize)sizeInFont:(UIFont * _Nonnull)font str:(NSString *)str {
    if (str.length==0 || !font) {
        return CGSizeZero;
    }
    
    NSDictionary * attributes = @{NSFontAttributeName : font};
    CGSize contentSize        = [str sizeWithAttributes:attributes];
    contentSize               = CGSizeMake(ceil(contentSize.width), ceil(contentSize.height));
    
    return contentSize;
}

+ (CGSize)sizeInFont:(UIFont * _Nonnull)font width:(CGFloat)width str:(NSString *)str {
    if (str.length==0 || !font) {
        return CGSizeZero;
    }
    
    CGSize         size = CGSizeMake(width, 200000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    return size;
    
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path stroke];
    [path fill];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
