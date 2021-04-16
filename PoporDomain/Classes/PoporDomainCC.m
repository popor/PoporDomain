//
//  PoporDomainCC.m
//  PoporDomain
//
//  Created by apple on 2019/6/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainCC.h"

#import "PoporDomainAssist.h"

@implementation PoporDomainCC

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
    }
    
    return self;
}

- (void)addViews {
    self.titleL = ({
        UILabel * l = [UILabel new];
        l.backgroundColor = [UIColor clearColor];
        l.font            = PoporDomainCCFont;
        l.textColor       = [UIColor darkGrayColor];
        l.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:l];
        l;
    });
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    {
        UIView * view0     = self.titleL;
        UIView * superView = self;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *leftLC    = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:7];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC   = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-7];
        [superView addConstraint:rightLC];
        
        NSLayoutConstraint *centerXLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [superView addConstraint:centerXLC];
        
        
        NSLayoutConstraint *heightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:(self.titleL.font.lineHeight + 3)];
        [superView addConstraint:heightLC];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleL.textColor = [UIColor whiteColor];
    }else{
        self.titleL.textColor = [UIColor darkGrayColor];
    }
}

+ (int)cellW:(NSString *)str {
    static UIFont * font;
    if (!font) {
        font = PoporDomainCCFont;
    }
    CGSize size = [PoporDomainAssist sizeInFont:font str:str];
    return size.width + 14;
}

@end
