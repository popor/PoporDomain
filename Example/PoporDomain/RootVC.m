//
//  APPViewController.m
//  PoporDomain
//
//  Created by popor on 04/16/2021.
//  Copyright (c) 2021 popor. All rights reserved.
//

#import "RootVC.h"

#import "PoporDomain.h"

@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        // config
        //PoporDomain * config = [PoporDomain share];
        NSMutableArray * array = [NSMutableArray new];
        
        [array addObject:[self getBaiduEntity]];
        [array addObject:[self getBingEntity]];
        [array addObject:[self getGoogleEntity]];
        
        [PoporDomain setNetDefaultArray:array defaultInfo:nil];
    }
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"域名配置" style:UIBarButtonItemStylePlain target:self action:@selector(action1)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"输出测试" style:UIBarButtonItemStylePlain target:self action:@selector(showList)];
        // [item1 setTitleTextAttributes:@{NSFontAttributeName:Font16} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
}

- (PoporDomainLE *)getBaiduEntity {
    PoporDomainLE * entity = [PoporDomainLE new];
    entity.title  = @"百度";
    entity.domain = @"https://www.baidu.com/dev";
    entity.selectIndex = 0;
    
    [entity.ueArray addObject:PoporDCE(@"开发", @"https://www.baidu.com/dev")];
    [entity.ueArray addObject:PoporDCE(@"测试", @"https://www.baidu.com/test")];
    [entity.ueArray addObject:PoporDCE(@"正式", @"https://www.baidu.com/release")];
    
    return entity;
}

- (PoporDomainLE *)getBingEntity {
    PoporDomainLE * entity = [PoporDomainLE new];
    entity.title  = @"必应";
    entity.domain = @"https://cn.bing.com/dev";
    entity.selectIndex = 0;
    
    [entity.ueArray addObject:PoporDCE(@"开发", @"https://cn.bing.com/dev")];
    [entity.ueArray addObject:PoporDCE(@"测试", @"https://cn.bing.com/test")];
    [entity.ueArray addObject:PoporDCE(@"正式", @"https://cn.bing.com/release")];
    
    return entity;
}

- (PoporDomainLE *)getGoogleEntity {
    PoporDomainLE * entity = [PoporDomainLE new];
    entity.title  = @"谷歌";
    entity.domain = @"https://www.google.com/dev";
    entity.selectIndex = 0;
    
    [entity.ueArray addObject:PoporDCE(@"开发", @"https://www.google.com/dev")];
    [entity.ueArray addObject:PoporDCE(@"测试", @"https://www.google.com/test")];
    [entity.ueArray addObject:PoporDCE(@"正式", @"https://www.google.com/release")];
    
    return entity;
}

- (void)action1 {
    NSDictionary * dic;
    dic = @{
        
    };
    [self.navigationController pushViewController:[PoporDomainVC new] animated:YES];
}

- (void)showList {
    PoporDomain * config = [PoporDomain share];
    for (PoporDomainLE * le in config.configEntity.leArray) {
        NSLog(@"le.title : %@, le.domain : %@", le.title, le.domain);
    }
    NSLog(@"");
}


@end
