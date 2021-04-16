//
//  PoporDomainVC.h
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import <UIKit/UIKit.h>

@class PoporDomain;

NS_ASSUME_NONNULL_BEGIN

@interface PoporDomainVC : UIViewController 

// UI
@property (nonatomic, strong) UICollectionView * headCV;

@property (nonatomic, strong) UITextField      * defaultUrlTF;
@property (nonatomic, strong) UIButton         * saveBT;
@property (nonatomic, strong) UILabel          * infoL;
@property (nonatomic, strong) UITableView      * infoTV;

// other
@property (nonatomic, weak  ) PoporDomain            * domainConfig;
@property (nonatomic, strong) UIFont                 * cellFont;
@property (nonatomic        ) CGFloat                  screenW;
@property (nonatomic        ) NSInteger                cvSelectIndex;
@property (nonatomic, strong) UITapGestureRecognizer * tapEndEditGR;

@end

NS_ASSUME_NONNULL_END
