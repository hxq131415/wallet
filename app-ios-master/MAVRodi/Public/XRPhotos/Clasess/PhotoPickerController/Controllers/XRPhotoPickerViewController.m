//
//  XRPhotoPickerViewController.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 rttx. All rights reserved.
//

#import "XRPhotoPickerViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <RSKImageCropper/RSKImageCropper.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "XRPhtoManager.h"
#import "XRPhotoAssetModel.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotoPickerAssetCell.h"
#import "XRPhotoAlbumListCell.h"
#import "XRPhotoAlbumListView.h"
#import "XRPhotoPickerTakeCameraCell.h"
#import "XRPhotosConfigs.h"
#import "UIImage+XRPhotosCategorys.h"
#import "XRPhotoPickerBottomView.h"
#import "XRPhotoBrowser.h"
#import "XRPhotoPickerNavigationTitleView.h"
#import "XRPhotoPickerNavigationBar.h"

@interface XRPhotoPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XRPhotoAlbumListViewDelegate, XPhotoBrowserDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

// PhotoPicker
@property (nonatomic, strong) UICollectionView * mainCollection;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* assetArray;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* selectedAssetArray;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* tmpSelectedAssetArray;
@property (nonatomic, assign) NSUInteger selectStepCounter;

@property (nonatomic, strong) XRPhtoManager * phManager;
@property (nonatomic, strong) NSString * saveLocalIdentifier;

// PhotoAlbums
@property (nonatomic, strong) NSArray <XRPhotoAlbumModel *>* Allalbums;
@property (nonatomic, strong) XRPhotoAlbumModel * selectedAlbum;
@property (nonatomic, strong) XRPhotoAlbumListView * albumListView;
@property (nonatomic, assign) CGFloat albumListContentHeight;
@property (nonatomic, strong) UIView * albumListMaskView;
@property (nonatomic, assign) CGSize targetSize;

@property (nonatomic, strong) XRPhotoPickerNavigationBar * customNavigationBar;
@property (nonatomic, strong) XRPhotoPickerNavigationTitleView * navigationTitleBtn;
@property (nonatomic, assign) BOOL isShowedAlbumList;

@property (nonatomic, strong) XRPhotoPickerBottomView * bottomView;

/// 为了适配横竖屏幕
@property (nonatomic, assign) CGFloat photoAlbumListMaxHeight;
@end

@implementation XRPhotoPickerViewController

#pragma mark - deinit
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XRLog(@"'%@' is dealloc!", NSStringFromClass([self class]));
}

#pragma mark - Initilizations
// 当PhotoAlbumList在外面时，调用该初始化方法创建照片选择页面
- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)albumModel {
    if (self = [super init]) {
        [self initilizationPhotoPicker];
        [_assetArray addObjectsFromArray:albumModel.phAssets];
    }
    return self;
}

// 当PhotoAlbumList在里面时，调用该初始化方法创建照片选择页面
- (instancetype)init {
    if (self = [super init]) {
        [self initilizationPhotoPicker];
    }
    return self;
}

- (void)initilizationPhotoPicker {
    
    _statusBarStyle = UIStatusBarStyleDefault;
    _assetArray = [NSMutableArray arrayWithCapacity:10];
    _selectedAssetArray = [NSMutableArray arrayWithCapacity:10];
    _tmpSelectedAssetArray = [NSMutableArray arrayWithCapacity:5];
    
    _selectStepCounter = 0;
    _isPortrait = YES; // 默认是竖屏
    _maxSelectPhotos = 5; // 默认最多选择的照片数为5张
}

#pragma mark - Setter Override
- (void)setMaxSelectPhotos:(NSInteger)maxSelectPhotos {
    if (maxSelectPhotos != _maxSelectPhotos) {
        _maxSelectPhotos = maxSelectPhotos;
    }
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
}

- (void)setIsAscingForCreation:(BOOL)isAscingForCreation {
    if (_isAscingForCreation != isAscingForCreation) {
        _isAscingForCreation = isAscingForCreation;
        _phManager.isAscingForCreation = _isAscingForCreation;
    }
}

- (void)setIsAllowMultipleSelect:(BOOL)isAllowMultipleSelect {
    if (isAllowMultipleSelect != _isAllowMultipleSelect) {
        _isAllowMultipleSelect = isAllowMultipleSelect;
    }
}

- (void)setIsPortrait:(BOOL)isPortrait {
    if (_isPortrait != isPortrait) {
        _isPortrait = isPortrait;
    }
    
    ///只适配竖屏，暂时不适配横屏模式
    if (_isPortrait) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            self.screenWidth = XR_Screen_Size.height;
            self.screenHeight = XR_Screen_Size.width;
        }
        else {
            self.screenWidth = XR_Screen_Size.width;
            self.screenHeight = XR_Screen_Size.height;
        }
    }
    else {
        // 若需要则需要适配横屏，但是现在都是竖屏模式
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            self.screenWidth = XR_Screen_Size.height;
            self.screenHeight = XR_Screen_Size.width;
        }
        else {
            self.screenWidth = XR_Screen_Size.width;
            self.screenHeight = XR_Screen_Size.height;
        }
    }
}

#pragma mark - Lazy Porpertys
- (XRPhtoManager *)phManager {
    if (!_phManager) {
        _phManager = [XRPhtoManager defaultManager];
        _phManager.isAscingForCreation = _isAscingForCreation;
    }
    return _phManager;
}

- (UIView *)albumListMaskView {
    if (!_albumListMaskView) {
        _albumListMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, XR_NavigationBar_Height, self.screenWidth, self.screenHeight - XR_NavigationBar_Height)];
        _albumListMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _albumListMaskView.alpha = 0;
    }
    return _albumListMaskView;
}

#pragma mark - Setups

- (void)setupMainCollectionView {
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat collectionViewOriginalY = XR_NavigationBar_Height;
    
    CGFloat collectionViewHeight = self.screenHeight - XR_NavigationBar_Height - XR_PhotoPicker_BottomView_Height;
    if (!self.isAllowMultipleSelect) {
        collectionViewHeight = self.screenHeight - XR_NavigationBar_Height;
    }
    
    _mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewOriginalY, self.screenWidth, collectionViewHeight) collectionViewLayout:flowLayout];
    _mainCollection.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _mainCollection.delegate = self;
    _mainCollection.dataSource = self;
    _mainCollection.alwaysBounceVertical = YES;
    
    [_mainCollection registerClass:[XRPhotoPickerAssetCell class] forCellWithReuseIdentifier:@"XRPhotoPickerAssetCell"];
    [_mainCollection registerClass:[XRPhotoPickerTakeCameraCell class] forCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell"];
    [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:_mainCollection];
}

- (void)setupPhotoAlbumListView {
    
    _targetSize = CGSizeMake(XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToLeft * 2.0, XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToTop * 2.0);
    
    // 蒙层
    self.albumListMaskView.alpha = 0.0;
    [self.view addSubview:self.albumListMaskView];
    
    CGFloat y = -_photoAlbumListMaxHeight + XR_NavigationBar_Height;
    _albumListView = [[XRPhotoAlbumListView alloc] initWithFrame:CGRectMake(0, y, self.screenWidth,  _photoAlbumListMaxHeight)];
    [self.view addSubview:_albumListView];
    [self.view bringSubviewToFront:_albumListView];
    _albumListView.delegate = self;
}

- (void)setupPhotoPickerBottomView {
    
    CGFloat bottomViewOriginalY = self.screenHeight - XR_PhotoPicker_BottomView_Height - XR_Virtual_Bottom_Height;
    if (!self.isAllowMultipleSelect) {
        bottomViewOriginalY = self.screenHeight - XR_NavigationBar_Height - XR_Virtual_Bottom_Height;
    }
    
    _bottomView = [[XRPhotoPickerBottomView alloc] initWithFrame:CGRectMake(0, bottomViewOriginalY, self.screenWidth, XR_PhotoPicker_BottomView_Height)];
    _bottomView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.view addSubview:_bottomView];
    
    _bottomView.hidden = !self.isAllowMultipleSelect;
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
    
    __weak __typeof(self) weakSelf = self;
    
    // 预览
    _bottomView.preToViewCallBack = ^{
        
        if (weakSelf.selectedAssetArray.count == 0) {
            return;
        }
        
        weakSelf.tmpSelectedAssetArray = [NSMutableArray arrayWithArray:weakSelf.selectedAssetArray];
        
        XRPhotoBrowser * photoBrowser = [[XRPhotoBrowser alloc] initWithDelegate:weakSelf tmpAssets:weakSelf.tmpSelectedAssetArray];
        photoBrowser.zoomPhotosToFill = NO;
        photoBrowser.displayNavArrows = YES;
        photoBrowser.displayActionButton = NO;
        photoBrowser.displaySelectionButtons = NO;
        photoBrowser.alwaysShowControls = NO;
        photoBrowser.enableGrid = NO;
        photoBrowser.enableSwipeToDismiss = NO;
        photoBrowser.startOnGrid = NO;
        photoBrowser.autoPlayOnAppear = NO;
        
        [weakSelf.navigationController pushViewController:photoBrowser animated:YES];
    };
    
    // 完成
    _bottomView.finishSelectCallBack = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_photoPickerControllerDidFinished:didSelectAssets:)]) {
            [weakSelf.delegate xr_photoPickerControllerDidFinished:weakSelf didSelectAssets:weakSelf.selectedAssetArray];
        }
    };
}

- (void)setupNavigationBar {
    
    _customNavigationBar = [[XRPhotoPickerNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, XR_NavigationBar_Height)];
    _customNavigationBar.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:_customNavigationBar];
    
    [_customNavigationBar.leftButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_customNavigationBar.leftButton setImage:[UIImage imageForResouceName:@"xr_photo_nav_back"] forState:UIControlStateNormal];
    __weak __typeof(self) weakSelf = self;
    _customNavigationBar.leftBtnClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationTitleBtn = [[XRPhotoPickerNavigationTitleView alloc] init];
    self.navigationTitleBtn.frame = CGRectMake(60, XR_StatusBar_Height, self.screenWidth - 120, XR_NavigationBar_Height - XR_StatusBar_Height);
    [self.navigationTitleBtn configNavigationTitleViewWithTitle:@"所有照片"];
    self.navigationTitleBtn.backgroundColor = [UIColor whiteColor];
    [self.customNavigationBar insertSubview:self.navigationTitleBtn belowSubview:self.customNavigationBar.bottomLineView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbumListWithAnimate)];
    tapGesture.numberOfTapsRequired = 1;
    [self.navigationTitleBtn addGestureRecognizer:tapGesture];
}

#pragma mark - Life Cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    // 设置不允许UIScrollView及其子类向下偏移
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    // 适配iOS11
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
    ///只适配竖屏，暂时不适配横屏模式
    if (_isPortrait) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            self.screenWidth = XR_Screen_Size.height;
            self.screenHeight = XR_Screen_Size.width;
        }
        else {
            self.screenWidth = XR_Screen_Size.width;
            self.screenHeight = XR_Screen_Size.height;
        }
    }
    else {
        // 若需要则需要适配横屏，但是现在都是竖屏模式
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            self.screenWidth = XR_Screen_Size.height;
            self.screenHeight = XR_Screen_Size.width;
        }
        else {
            self.screenWidth = XR_Screen_Size.width;
            self.screenHeight = XR_Screen_Size.height;
        }
    }
    
    _photoAlbumListMaxHeight = (self.screenHeight - XR_Virtual_Bottom_Height - XR_NavigationBar_Height) * 0.5;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            [self setAutomaticallyAdjustsScrollViewInsets:NO];
        }
    }
    
    [self setupMainCollectionView];
    [self setupPhotoPickerBottomView];
    [self setupPhotoAlbumListView];
    [self setupNavigationBar];
    
    [self requestAllPhotoAlbums];
    
    UITapGestureRecognizer * tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbumListWithAnimate)];
    tapGestrue.numberOfTapsRequired = 1;
    [self.albumListMaskView addGestureRecognizer:tapGestrue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// when present called
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Actions

- (void)cancelPhotoPickerAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerControllerDidCancel:)]) {
        [self.delegate xr_photoPickerControllerDidCancel:self];
    }
}

- (void)showAlbumListWithAnimate {
    
    if (self.Allalbums.count == 0) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    if (!_isShowedAlbumList) {
        // 展开
        [UIView animateWithDuration:XR_AlbumListShow_AnimateTime animations:^{
            weakSelf.albumListMaskView.alpha = 1.0;
            CGRect tmpFrame = weakSelf.albumListView.frame;
            tmpFrame.origin.y = XR_NavigationBar_Height;
            weakSelf.albumListView.frame = tmpFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.isShowedAlbumList = YES;
            }
        }];
    }
    else {
        // 关闭
        [UIView animateWithDuration:XR_AlbumListShow_AnimateTime animations:^{
            weakSelf.albumListMaskView.alpha = 0;
            CGRect tmpFrame = weakSelf.albumListView.frame;
            tmpFrame.origin.y = -weakSelf.photoAlbumListMaxHeight + XR_NavigationBar_Height;
            weakSelf.albumListView.frame = tmpFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.isShowedAlbumList = NO;
            }
        }];
    }
}

#pragma mark - Request 
- (void)requestAllPhotoAlbums {
    
    __weak __typeof(self) weakSelf = self;
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            [weakSelf.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:weakSelf.targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    weakSelf.Allalbums = albumList;
                    [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:YES];
                    
                    weakSelf.albumListContentHeight = XR_PhotoAlbumList_Cell_Height * weakSelf.Allalbums.count;
                    
                    weakSelf.albumListContentHeight = weakSelf.albumListContentHeight > weakSelf.photoAlbumListMaxHeight ? weakSelf.photoAlbumListMaxHeight : weakSelf.albumListContentHeight;
                    
                    CGFloat y = -weakSelf.albumListContentHeight + XR_NavigationBar_Height;
                    
                    weakSelf.albumListView.frame = CGRectMake(0, y, weakSelf.screenWidth,  weakSelf.albumListContentHeight);
                    
                    // 默认选择第一个相册
                    if (weakSelf.Allalbums.count > 0) {
                        weakSelf.selectedAlbum = weakSelf.Allalbums.firstObject;
                        
                        [weakSelf.navigationTitleBtn configNavigationTitleViewWithTitle:weakSelf.selectedAlbum.albumTitle];
                        [weakSelf.assetArray removeAllObjects];
                        [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                        [weakSelf.mainCollection reloadData];
                    }
                });
            }];
        }];
    }
    else {
        // 首次授权后最好有个加载提示
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied) {
                // 用户首次授权时点击了 '不允许'，或者手动关闭了访问照片库的权限，需要做引导让用户打开照片库权限
                UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"您已关闭了照片库的访问权限，请点击'去设置'以打开照片库访问权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction * settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                
                [alertCtrl addAction:cancelAction];
                [alertCtrl addAction:settingAction];
                
                [self presentViewController:alertCtrl animated:YES completion:nil];
            }
            else if (status == PHAuthorizationStatusAuthorized) {
                // 用户首次授权时点击了 '好'，开始请求数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 获取相册
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:weakSelf.targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                            weakSelf.Allalbums = albumList;
                            [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:YES];
                            weakSelf.albumListContentHeight = XR_PhotoAlbumList_Cell_Height * weakSelf.Allalbums.count;
                            
                            weakSelf.albumListContentHeight = weakSelf.albumListContentHeight > weakSelf.photoAlbumListMaxHeight ? weakSelf.photoAlbumListMaxHeight : weakSelf.albumListContentHeight;
                            
                            CGFloat y = -weakSelf.albumListContentHeight + XR_NavigationBar_Height;
                            
                            weakSelf.albumListView.frame = CGRectMake(0, y, weakSelf.screenWidth,  weakSelf.albumListContentHeight);
                            
                            // 默认选择第一个相册
                            if (weakSelf.Allalbums.count > 0) {
                                weakSelf.selectedAlbum = weakSelf.Allalbums.firstObject;
                                
                                [weakSelf.navigationTitleBtn configNavigationTitleViewWithTitle:weakSelf.selectedAlbum.albumTitle];
                                [weakSelf.assetArray removeAllObjects];
                                [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                                [weakSelf.mainCollection reloadData];
                            }
                        });
                    }];
                });
            }
        }];
    }
}

#pragma mark - Methods
- (UICollectionViewCell *)cellForPhotoPickerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    __block XRPhotoPickerAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerAssetCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    NSInteger index = indexPath.item;
    if (self.isSupportCamera) {
        index = self.phManager.isAscingForCreation ? indexPath.item : indexPath.item - 1;
    }
    
    if (index < _assetArray.count) {
        __block XRPhotoAssetModel * assetModel = _assetArray[index];
        
        cell.representedAssetIdentifier = assetModel.phAsset.localIdentifier;
        
        if (self.isAllowMultipleSelect) {
            cell.selectButton.hidden = NO;
            cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
        }
        else {
            cell.selectButton.hidden = YES;
        }
        
        CGFloat itemWidth = (self.screenWidth - XR_PhotoAsset_Grid_Border * 5.0) / 4.0;
        
        [self.phManager getThumbImageWithAsset:assetModel targetSize:CGSizeMake(itemWidth, itemWidth) completeBlock:^(BOOL isDegrade, UIImage *image) {
            if ([cell.representedAssetIdentifier isEqualToString:assetModel.phAsset.localIdentifier] && image) {
                cell.assetImageView.image = image;
            }
        }];
        
        return cell;
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (void)takePhotoAction {
    
    __weak __typeof(self) weakSelf = self;
    
    if (![AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"无法检测到摄像头，请确定是在真机上运行哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIImagePickerController * pickerCtrl = [[UIImagePickerController alloc] init];
                        pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
                        pickerCtrl.delegate = weakSelf;
                        [weakSelf presentViewController:pickerCtrl animated:YES completion:nil];
                    }
                }];
            }
        }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"系统限制原因，无法使用摄像功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"您已关闭了相机的访问权限，请点击'去设置'以打开相机访问权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:settingAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * pickerCtrl = [[UIImagePickerController alloc] init];
            pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerCtrl.delegate = self;
            [self presentViewController:pickerCtrl animated:YES completion:nil];
        }
    }
}

// 裁剪图片
- (void)cropPhotoWithImage:(UIImage *)image {
    
    RSKImageCropViewController * imageCroper = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
    imageCroper.delegate = self;
    imageCroper.dataSource = self;
    imageCroper.maskLayerColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    imageCroper.maskLayerLineWidth = 1.0;
    imageCroper.maskLayerStrokeColor = [UIColor whiteColor];
    
    imageCroper.avoidEmptySpaceAroundImage = YES;
    imageCroper.alwaysBounceHorizontal = YES;
    imageCroper.alwaysBounceVertical = YES;
    imageCroper.applyMaskToCroppedImage = YES;
    imageCroper.rotationEnabled = NO;
    [self.navigationController pushViewController:imageCroper animated:YES];
}

#pragma mark - Delegates
#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isSupportCamera) {
        return _assetArray.count + 1;
    }
    return _assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSupportCamera) {
        if (indexPath.item < _assetArray.count + 1) {
            
            if (self.phManager.isAscingForCreation) {
                if (indexPath.item == _assetArray.count) {
                    XRPhotoPickerTakeCameraCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell" forIndexPath:indexPath];
                    cell.backgroundColor = UIColorFromRGB(0x999999);
                    return cell;
                }
                else {
                    return [self cellForPhotoPickerWithCollectionView:collectionView indexPath:indexPath];
                }
            }
            else {
                if (indexPath.item == 0) {
                    XRPhotoPickerTakeCameraCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell" forIndexPath:indexPath];
                    cell.backgroundColor = UIColorFromRGB(0x999999);
                    return cell;
                }
                else {
                    return [self cellForPhotoPickerWithCollectionView:collectionView indexPath:indexPath];
                }
            }
        }
    }
    else {
        return [self cellForPhotoPickerWithCollectionView:collectionView indexPath:indexPath];
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.assetArray.count;
    if (self.isSupportCamera) {
        count = self.assetArray.count + 1;
    }
    if (indexPath.item < count) {
        
        __weak __typeof(self) weakSelf = self;
        if (self.isSupportCamera) {
            if (self.phManager.isAscingForCreation) {
                if (indexPath.item == self.assetArray.count) {
                    // 拍照
                    [self takePhotoAction];
                }
                else {
                    XRPhotoPickerAssetCell * cell = (XRPhotoPickerAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (indexPath.item < self.assetArray.count) {
                        XRPhotoAssetModel * assetModel = self.assetArray[indexPath.item];
                        
                        if (self.isAllowMultipleSelect) {
                            // 多选
                            if ([self.selectedAssetArray containsObject:assetModel]) {
                                // remove
                                [self.selectedAssetArray removeObject:assetModel];
                                self.selectStepCounter--;
                            }
                            else {
                                // add
                                if (self.selectedAssetArray.count < self.maxSelectPhotos) {
                                    [self.selectedAssetArray addObject:assetModel];
                                }
                                self.selectStepCounter++;
                                if (self.selectStepCounter > self.maxSelectPhotos) {
                                    self.selectStepCounter = self.maxSelectPhotos;
                                    // 提示不能选择了
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerControllerDidOverrunMaxAllowSelectCount:)]) {
                                        [self.delegate xr_photoPickerControllerDidOverrunMaxAllowSelectCount:self];
                                    }
                                }
                            }
                            
                            cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
                            [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
                        }
                        else {
                            // 单选
                            [[self phManager] getFitsBigImageWithAsset:assetModel completeBlock:^(UIImage *image) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    if (weakSelf.isAllowCrop) {
                                        [weakSelf cropPhotoWithImage:image];
                                    }
                                    else {
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_photoPickerController:didSelectAssetWithOriginalImage:)]) {
                                            [weakSelf.delegate xr_photoPickerController:weakSelf didSelectAssetWithOriginalImage:image];
                                        }
                                    }
                                }];
                            }];
                        }
                    }
                }
            }
            else {
                if (indexPath.item == 0) {
                    // 拍照
                    [self takePhotoAction];
                }
                else {
                    XRPhotoPickerAssetCell * cell = (XRPhotoPickerAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (indexPath.item - 1 < self.assetArray.count) {
                        XRPhotoAssetModel * assetModel = self.assetArray[indexPath.item - 1];
                        if (self.isAllowMultipleSelect) {
                            if ([self.selectedAssetArray containsObject:assetModel]) {
                                // remove
                                [self.selectedAssetArray removeObject:assetModel];
                                self.selectStepCounter--;
                            }
                            else {
                                // add
                                if (self.selectedAssetArray.count < self.maxSelectPhotos) {
                                    [self.selectedAssetArray addObject:assetModel];
                                }
                                self.selectStepCounter++;
                                if (self.selectStepCounter > self.maxSelectPhotos) {
                                    self.selectStepCounter = self.maxSelectPhotos;
                                    // 提示不能选择了
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerControllerDidOverrunMaxAllowSelectCount:)]) {
                                        [self.delegate xr_photoPickerControllerDidOverrunMaxAllowSelectCount:self];
                                    }
                                }
                            }
                            
                            cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
                            [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
                        }
                        else {
                            // 单选
                            [self.phManager getFitsBigImageWithAsset:assetModel completeBlock:^(UIImage *image) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    if (weakSelf.isAllowCrop) {
                                        [weakSelf cropPhotoWithImage:image];
                                    }
                                    else {
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_photoPickerController:didSelectAssetWithOriginalImage:)]) {
                                            [weakSelf.delegate xr_photoPickerController:weakSelf didSelectAssetWithOriginalImage:image];
                                        }
                                    }
                                }];
                            }];
                        }
                    }
                }
            }
        }
        else {
            XRPhotoPickerAssetCell * cell = (XRPhotoPickerAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            if (indexPath.item < self.assetArray.count) {
                XRPhotoAssetModel * assetModel = self.assetArray[indexPath.item];
                
                if (self.isAllowMultipleSelect) {
                    // 多选
                    if ([self.selectedAssetArray containsObject:assetModel]) {
                        // remove
                        [self.selectedAssetArray removeObject:assetModel];
                        self.selectStepCounter--;
                    }
                    else {
                        // add
                        if (self.selectedAssetArray.count < self.maxSelectPhotos) {
                            [self.selectedAssetArray addObject:assetModel];
                        }
                        self.selectStepCounter++;
                        if (self.selectStepCounter > self.maxSelectPhotos) {
                            self.selectStepCounter = self.maxSelectPhotos;
                            // 提示不能选择了
                            if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerControllerDidOverrunMaxAllowSelectCount:)]) {
                                [self.delegate xr_photoPickerControllerDidOverrunMaxAllowSelectCount:self];
                            }
                        }
                    }
                    
                    cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
                    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
                }
                else {
                    // 单选
                    [self.phManager getFitsBigImageWithAsset:assetModel completeBlock:^(UIImage *image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (weakSelf.isAllowCrop) {
                                [weakSelf cropPhotoWithImage:image];
                            }
                            else {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_photoPickerController:didSelectAssetWithOriginalImage:)]) {
                                    [weakSelf.delegate xr_photoPickerController:weakSelf didSelectAssetWithOriginalImage:image];
                                }
                            }
                        }];
                    }];
                }
            }
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return XR_PhotoAsset_Grid_Border;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return XR_PhotoAsset_Grid_Border;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (self.screenWidth - XR_PhotoAsset_Grid_Border * 5.0) / 4.0;
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - XRPhotoAlbumListViewDelegate

- (void)didSelectPhotoAlbumList:(XRPhotoAlbumListView *)albumListView selectAlbum:(XRPhotoAlbumModel *)album {
    
    [self showAlbumListWithAnimate];
    
    if (self.selectedAlbum != album) {
        self.selectedAlbum = album;
        
        [self.navigationTitleBtn configNavigationTitleViewWithTitle:self.selectedAlbum.albumTitle];
        [self.assetArray removeAllObjects];
        [self.assetArray addObjectsFromArray:self.selectedAlbum.phAssets];
        [self.mainCollection reloadData];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak __typeof(self) weakSelf = self;
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage] && [info objectForKey:UIImagePickerControllerOriginalImage]) {
        UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        originalImage = [originalImage fixOrientation];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (weakSelf.isAllowCrop) {
                [weakSelf cropPhotoWithImage:originalImage];
            }
            else {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_photoPickerController:didSelectAssetWithOriginalImage:)]) {
                    [weakSelf.delegate xr_photoPickerController:weakSelf didSelectAssetWithOriginalImage:originalImage];
                }
            }
        }];
        
        // Save to PhotoLibrary
        __weak __typeof(self) weakSelf = self;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest * creationRquest = [PHAssetChangeRequest creationRequestForAssetFromImage:originalImage];
            weakSelf.saveLocalIdentifier = creationRquest.placeholderForCreatedAsset.localIdentifier;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                XRLog(@"cratation asset error!");
            }
            else {
                PHFetchResult * ftResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[weakSelf.saveLocalIdentifier] options:nil];
                PHAsset * asset = ftResult.firstObject;
                XRPhotoAssetModel * assetModel = [[XRPhotoAssetModel alloc] init];
                assetModel.phAsset = asset;
                NSInteger insertIndex = 0;
                if (weakSelf.phManager.isAscingForCreation) {
                    insertIndex = weakSelf.selectedAlbum.phAssets.count;
                }
                else {
                    insertIndex = 0;
                }
                [weakSelf.selectedAlbum.phAssets insertObject:assetModel atIndex:insertIndex];
                [weakSelf.assetArray removeAllObjects];
                [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.mainCollection performBatchUpdates:^{
                        [weakSelf.mainCollection insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [weakSelf.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:weakSelf.targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.Allalbums = albumList;
                                    [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:NO];
                                });
                            }];
                        }
                    }];
                });
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate & XRPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.selectedAssetArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.selectedAssetArray.count) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageSize = MAX(self.screenWidth, self.screenHeight) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale); // 大图
        
        XRPhotoAssetModel * asset = self.selectedAssetArray[index];
        MWPhoto * photo = [[MWPhoto alloc] initWithAsset:asset.phAsset targetSize:imageTargetSize];
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    if (index < self.selectedAssetArray.count) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageSize = MAX(self.screenWidth, self.screenHeight) * 1.5;
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale); // 缩略图
        
        XRPhotoAssetModel * asset = self.selectedAssetArray[index];
        MWPhoto * photo = [[MWPhoto alloc] initWithAsset:asset.phAsset targetSize:thumbTargetSize];
        return photo;
    }
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return nil;
}
    
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    XRLog(@"didDisplay Index -> %lu", (unsigned long)index);
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
}

#pragma mark - XRPhotoBrowserDelegate
- (NSUInteger)xr_MaxSelectedPhotosForPhotoBrowser {
    return self.maxSelectPhotos;
}

- (void)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser asset:(XRPhotoAssetModel *)asset isSelected:(BOOL)selected {
    
    if (selected) {
        if (![self.tmpSelectedAssetArray containsObject:asset]) {
            [self.tmpSelectedAssetArray addObject:asset];
        }
    }
    else {
        if ([self.tmpSelectedAssetArray containsObject:asset]) {
            [self.tmpSelectedAssetArray removeObject:asset];
        }
    }
}

- (BOOL)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedWithAsset:(XRPhotoAssetModel *)asset {
    return [self.tmpSelectedAssetArray containsObject:asset];
}

- (void)xr_navigationLeftItemActionForPhotoBrowser {
    // 刷新选择的状态
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:self.tmpSelectedAssetArray];
    [self.mainCollection reloadData];
    
    self.selectStepCounter = self.selectedAssetArray.count;
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
}

- (void)xr_finishedBtnActionForPhotoBrowser {
    
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:self.tmpSelectedAssetArray];
    [self.mainCollection reloadData];
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerControllerDidFinished:didSelectAssets:)]) {
        [self.delegate xr_photoPickerControllerDidFinished:self didSelectAssets:self.selectedAssetArray];
    }
}

#pragma mark - RSKImageCropViewControllerDelegate & DataSource

/**
 Tells the delegate that crop image has been canceled.
 */
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    
    [controller.navigationController popViewControllerAnimated:YES];
}

/**
 Tells the delegate that the original image has been cropped. Additionally provides a crop rect and a rotation angle used to produce image.
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_photoPickerController:didSelectAssetWithCropImage:)]) {
        [self.delegate xr_photoPickerController:self didSelectAssetWithCropImage:croppedImage];
    }
}

/**
 Tells the delegate that the original image will be cropped.
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller willCropImage:(UIImage *)originalImage {
    // Show HUD
}

/**
 Asks the data source a custom rect for the mask.
 
 @param controller The crop view controller object to whom a rect is provided.
 
 @return A custom rect for the mask.
 */
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    
    CGFloat cropOriginX = (self.screenWidth - self.cropSize.width) * 0.5;
    CGFloat cropOriginY = (self.screenHeight - self.cropSize.height) * 0.5;
    return CGRectMake(cropOriginX, cropOriginY, self.cropSize.width, self.cropSize.height);
}

/**
 Asks the data source a custom path for the mask.
 
 @param controller The crop view controller object to whom a path is provided.
 
 @return A custom path for the mask.
 */
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    
    CGRect bezierPathRect = controller.maskRect;
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:bezierPathRect];
    return bezierPath;
}

/**
 Asks the data source a custom rect in which the image can be moved.
 
 @param controller The crop view controller object to whom a rect is provided.
 
 @return A custom rect in which the image can be moved.
 */
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
    
    return controller.maskRect;
}

@end






