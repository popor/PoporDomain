//
//  PoporDomainCC.h
//  PoporDomain
//
//  Created by apple on 2019/6/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * PoporDomainCCKey    = @"PoporDomainCC";
static CGFloat    PoporDomainCCHeight = 44;
#define PoporDomainCCFont [UIFont systemFontOfSize:16]

@interface PoporDomainCC : UICollectionViewCell

@property (nonatomic, strong) UILabel * titleL;

+ (int)cellW:(NSString *)str;



@end

NS_ASSUME_NONNULL_END
