//
//  PoporDomainVC.m
//  PoporDomain
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import "PoporDomainVC.h"

#import "PoporDomainCC.h"

#import "PoporDomain.h"
#import "PoporDomainCC.h"
#import "PoporDomainAssist.h"

@interface PoporDomainVC ()
<
UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate,
UICollectionViewDelegate, UICollectionViewDataSource
>

@property (nonatomic, strong) NSLayoutConstraint * infoTV_bottomLC;

@end

@implementation PoporDomainVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startMonitorTapEdit];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopMonitorTapEdit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"域名配置";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews];
}

- (void)addViews {
    self.domainConfig = [PoporDomain share];
    self.cellFont     = [UIFont systemFontOfSize:16];
    self.screenW      = self.view.frame.size.width;
    
    self.headCV = [self addCV];
    [self addInfo];
    
    self.infoTV = [self addTVs];
    
    {
        UIView * view0     = self.infoTV;
        UIView * superView = self.view;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *topLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoL attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        [superView addConstraint:topLC];
        
        NSLayoutConstraint *leftLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [superView addConstraint:rightLC];
        
        self.infoTV_bottomLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [superView addConstraint:self.infoTV_bottomLC];
    }
    

    [self setDefaultValue];
    
    [self addTapGRs];
}

- (void)setDefaultValue {
    PoporDomain   * config     = [PoporDomain share];
    PoporDomainLE * leCurrent = config.configEntity.leArray[0];
    self.defaultUrlTF.text = leCurrent.domain;
}

- (UICollectionView *)addCV {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView * cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    cv.layer.cornerRadius = 6;
    
    [self.view addSubview:cv];
    cv.backgroundColor = [UIColor whiteColor];
    
    [cv registerClass:[PoporDomainCC class] forCellWithReuseIdentifier:PoporDomainCCKey];
    
    cv.delegate   = self;
    cv.dataSource = self;
    
    {
        UIView * view0     = cv;
        UIView * superView = self.view;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        

        NSLayoutConstraint *leftLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:PoporDomainVCXGap];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-PoporDomainVCXGap];
        [superView addConstraint:rightLC];
        
        // top
        CGFloat top = 0;
        if (self.navigationController.navigationBar) {
            if (self.navigationController.navigationBar.translucent) {
                top = [self statusBarHeight] +self.navigationController.navigationBar.frame.size.height +20;
            } else {
                top = 20;
            }
        } else {
            top = [self statusBarHeight] +self.navigationController.navigationBar.frame.size.height +20;
        }
        NSLayoutConstraint *topLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];
        [superView addConstraint:topLC];
        
        
        // height
        PoporDomain * pdConfig = [PoporDomain share];
        CGFloat height = 0;
        if (pdConfig.configEntity.leArray.count <= 1) {
            height = 0;
        }else{
            height = PoporDomainCCHeight;
        }
        
        NSLayoutConstraint *heightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        [superView addConstraint:heightLC];
        
    }
    
    return cv;
}

- (CGFloat)statusBarHeight {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        return mainWindow.safeAreaInsets.top;
    }else{
        return 20;
    }
}

- (void)addInfo {
    PoporDomain * pdConfig = [PoporDomain share];
    NSMutableArray * titleArray = [NSMutableArray new];
    for (PoporDomainLE * le in pdConfig.configEntity.leArray) {
        [titleArray addObject:le.title];
    }
    
    if (!self.defaultUrlTF) {
        UITextField * tf = [[UITextField alloc] initWithFrame:CGRectZero];        
        tf.backgroundColor = [UIColor whiteColor];
        tf.font            = [UIFont systemFontOfSize:16];
        
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        tf.layer.cornerRadius = 5;
        tf.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        tf.layer.borderWidth  = 1;
        tf.clipsToBounds      = YES;
        
        tf.delegate           = self;
        
        [self.view addSubview:tf];
        self.defaultUrlTF = tf;
    }
    
    self.saveBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(100, 100, 80, 44);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"新增" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[PoporDomainAssist imageFromColor:self.view.tintColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    self.infoL = ({
        UILabel * l = [UILabel new];
        l.frame              = CGRectMake(0, 0, 0, 44);
        l.backgroundColor    = [UIColor clearColor];
        l.font               = [UIFont systemFontOfSize:15];
        l.textColor          = [UIColor darkGrayColor];
        l.textAlignment      = NSTextAlignmentCenter;
        
        [self.view addSubview:l];
        
        l.text = pdConfig.defaultInfo;
        
        [l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        l.numberOfLines =0;
        
        l;
    });
    
    {
        UIView * view0     = self.defaultUrlTF;
        UIView * superView = self.view;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        
        CGFloat top_offset = (pdConfig.configEntity.leArray.count <= 1) ? 0: 20;
        
        NSLayoutConstraint *topLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headCV attribute:NSLayoutAttributeBottom multiplier:1.0 constant:top_offset];
        [superView addConstraint:topLC];;
        
        NSLayoutConstraint *leftLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:PoporDomainVCXGap];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-PoporDomainVCXGap];
        [superView addConstraint:rightLC];
        
        NSLayoutConstraint *heightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        [superView addConstraint:heightLC];
        
    }
    
    {
        UIView * view0     = self.saveBT;
        UIView * superView = self.view;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *topLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.defaultUrlTF attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        [superView addConstraint:topLC];
        
        NSLayoutConstraint *leftLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:PoporDomainVCXGap];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-PoporDomainVCXGap];
        [superView addConstraint:rightLC];
        
        NSLayoutConstraint *heightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        [superView addConstraint:heightLC];
    }
    
    {
        UIView * view0     = self.infoL;
        UIView * superView = self.view;
        view0.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *topLC = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.saveBT attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        [superView addConstraint:topLC];
        
        NSLayoutConstraint *leftLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
        [superView addConstraint:leftLC];
        
        NSLayoutConstraint *rightLC  = [NSLayoutConstraint constraintWithItem:view0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
        [superView addConstraint:rightLC];
    }
}

#pragma mark - UITableView
- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.delegate   = self;
    oneTV.dataSource = self;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    //oneTV.separatorColor = ColorTV_separator;
    
    [self.view addSubview:oneTV];
    
    return oneTV;
}

#pragma mark - present
#pragma mark - VC_DataSource
- (PoporDomainLE *)listEntity {
    if (self.cvSelectIndex < 0) {
        return self.domainConfig.configEntity.leArray.firstObject;
    }else{
        return self.domainConfig.configEntity.leArray[self.cvSelectIndex];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.domainConfig.configEntity.leArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainCC * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PoporDomainCCKey forIndexPath:indexPath];
    PoporDomainLE * le   = self.domainConfig.configEntity.leArray[indexPath.row];
    cell.titleL.text           = le.title;
    
    if (indexPath.row == 0) {
        cell.selected      = YES;
        self.cvSelectIndex = 0;
        [self selectCvIndex:self.cvSelectIndex];
    }
    
    return cell;
}

#pragma layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainLE * le = self.domainConfig.configEntity.leArray[indexPath.row];
    return CGSizeMake(le.titleW, PoporDomainCCHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 1, 0, 1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PoporDomainCvXyGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PoporDomainCvXyGap;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != self.cvSelectIndex) {
        
        PoporDomainCC *cell = (PoporDomainCC *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:YES];
        cell = (PoporDomainCC *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.cvSelectIndex inSection:0]];
        [cell setSelected:NO];
        self.cvSelectIndex = indexPath.row;
        
        [self selectCvIndex:self.cvSelectIndex];
    }
    
}

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listEntity.ueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainUE * entity = self.listEntity.ueArray[indexPath.row];
    NSString * title = entity.title ? [NSString stringWithFormat:@"%@: %@", entity.title, entity.domain] : entity.domain;
    CGFloat height   = [PoporDomainAssist sizeInFont:self.cellFont width:self.screenW -34 str:title].height + 14;
    
    return MAX(height, 50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = self.cellFont;
    }
    PoporDomainUE * entity = self.listEntity.ueArray[indexPath.row];
    
    if (entity.title) {
        NSString * title = [NSString stringWithFormat:@"%@: %@", entity.title, entity.domain];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:title];
        
        NSRange range0 = (NSRange){0, entity.title.length +1};
        NSRange range1 = (NSRange){entity.title.length +1, title.length -entity.title.length -1};
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range0];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range1];
        
        cell.textLabel.attributedText = att;
    } else {
        cell.textLabel.text = entity.domain;
    }
    
    if (self.listEntity.selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainUE * entity = self.listEntity.ueArray[indexPath.row];
    
    {
        NSMutableArray * actionArray = [[NSMutableArray alloc] init];
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            if (self.listEntity.selectIndex == indexPath.row) {
                self.listEntity.selectIndex = -1;
            } else if (self.listEntity.selectIndex > indexPath.row){
                self.listEntity.selectIndex --;
            }
            [self.listEntity.ueArray removeObjectAtIndex:indexPath.row];
            if (self.listEntity.ueArray.count == 0) {
                if (self.cvSelectIndex == -1) {
                    self.cvSelectIndex = 0;
                }
                //AlertToastTitle(@"恢复默认数据");
                [PoporDomain restoreNetArrayAt:self.cvSelectIndex];
            }
            [PoporDomain updateDomain];
            [self.infoTV reloadData];
        }];
        deleteRowAction.backgroundColor = [UIColor redColor];
        
        UITableViewRowAction *titleRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"设置标题" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            {
                UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"修改" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    
                    textField.placeholder = @"请设置标题";
                    textField.text = entity.title ? : @"";
                }];
                
                UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UITextField * nameTF = oneAC.textFields[0];
                    entity.title = nameTF.text;
                    
                    [PoporDomain updateDomain];
                    [self.infoTV reloadData];
                }];
                
                [oneAC addAction:cancleAction];
                [oneAC addAction:changeAction];
                
                [self presentViewController:oneAC animated:YES completion:nil];
            }
        }];
        titleRowAction.backgroundColor = [UIColor lightGrayColor];
        
        UITableViewRowAction *domainRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"更新域名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            {
                UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"更新域名" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    
                    textField.placeholder = @"更新域名";
                    textField.text = entity.domain ? : @"";
                }];
                
                UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UITextField * nameTF = oneAC.textFields[0];
                    entity.domain = nameTF.text;
                    
                    [PoporDomain updateDomain];
                    [self.infoTV reloadData];
                }];
                
                [oneAC addAction:cancleAction];
                [oneAC addAction:changeAction];
                
                [self presentViewController:oneAC animated:YES completion:nil];
            }
        }];
        domainRowAction.backgroundColor = [UIColor grayColor];
        
        
        [actionArray addObject:deleteRowAction];
        [actionArray addObject:domainRowAction];
        [actionArray addObject:titleRowAction];
        
        
        return actionArray;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != self.listEntity.selectIndex) {
        UITableViewCell * cellOld = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.selectIndex inSection:0]];
        UITableViewCell * cellNew = [tableView cellForRowAtIndexPath:indexPath];
        
        cellOld.accessoryType = UITableViewCellAccessoryNone;
        cellNew.accessoryType = UITableViewCellAccessoryCheckmark;
        
        PoporDomainUE * entity = self.listEntity.ueArray[indexPath.row];
        
        self.listEntity.domain = entity.domain;
        self.defaultUrlTF.text = self.listEntity.domain;
        self.listEntity.selectIndex = indexPath.row;
        
        [PoporDomain updateDomain];
    }
}

#pragma mark - Interactor_EventHandler
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textField.text = @"http://";
    });
    return YES;
}

#pragma mark - tag GR
- (void)addTapGRs {
    if (!self.tapEndEditGR) {
        self.tapEndEditGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEndEditGRAction)];
        self.tapEndEditGR.cancelsTouchesInView = NO;
        
        [self.view addGestureRecognizer:self.tapEndEditGR];
    }
    
    self.tapEndEditGR.enabled = NO;
}

- (void)tapEndEditGRAction {
    [self.view endEditing:YES];
    [self.view becomeFirstResponder];
    self.tapEndEditGR.enabled = NO;
}

- (void)startMonitorTapEdit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapEndEditGR_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapEndEditGR_keyboardDidShow:)  name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapEndEditGR_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapEndEditGR_keyboardDidHide:)  name:UIKeyboardDidHideNotification object:nil];
}
- (void)stopMonitorTapEdit {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
}

- (void)tapEndEditGR_keyboardWillShow:(NSNotification *)notification {
    CGRect endRect      = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self keyboardFrameChanged:endRect duration:animationTime show:YES];
    });
}

- (void)tapEndEditGR_keyboardDidShow:(NSNotification *)notification {
    self.tapEndEditGR.enabled = YES;
}

- (void)tapEndEditGR_keyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self keyboardFrameChanged:CGRectZero duration:animationTime show:NO];
    });
    [self.view becomeFirstResponder];
}

- (void)tapEndEditGR_keyboardDidHide:(NSNotification *)notification {
    self.tapEndEditGR.enabled = NO;
}

- (void)keyboardFrameChanged:(CGRect)rect duration:(CGFloat)duration show:(BOOL)show {
    if (self.infoTV_bottomLC) {
        [self.view removeConstraint:self.infoTV_bottomLC];
    }
    
    if (show) {
        [UIView animateWithDuration:duration animations:^{
            self.infoTV_bottomLC  = [NSLayoutConstraint constraintWithItem:self.infoTV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-rect.size.height];
            [self.view addConstraint:self.infoTV_bottomLC];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.infoTV_bottomLC  = [NSLayoutConstraint constraintWithItem:self.infoTV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            [self.view addConstraint:self.infoTV_bottomLC];
        }];
    }
}

#pragma mark - VC_EventHandler
- (void)saveAction {
    UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"新增" message:@"请设置标题" preferredStyle:UIAlertControllerStyleAlert];
    
    [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        
        textField.placeholder = @"标题";
        textField.text = @"";
    }];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField * nameTF = oneAC.textFields[0];
        
        PoporDomainUE * entity = [PoporDomainUE new];
        if (nameTF.text.length == 0) {
            entity.title  = nil;
        }else{
            entity.title  = nameTF.text;
        }
        
        entity.domain = self.defaultUrlTF.text;
        
        self.listEntity.selectIndex = self.listEntity.ueArray.count;
        [self.listEntity.ueArray addObject:entity];
        
        [PoporDomain updateDomain];
        
        [self.infoTV reloadData];
        [self.infoTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.ueArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
    
    [oneAC addAction:cancleAction];
    [oneAC addAction:changeAction];
    
    [self presentViewController:oneAC animated:YES completion:nil];
}

- (void)selectCvIndex:(NSInteger)index {
    self.defaultUrlTF.text = self.listEntity.domain;
    [self.infoTV reloadData];
    
    if (self.listEntity.selectIndex >= 0 && self.listEntity.selectIndex < self.listEntity.ueArray.count) {
        [self.infoTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
}

@end
