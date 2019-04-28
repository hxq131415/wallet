//
//  PhotoAlbumListViewController.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 rttx. All rights reserved.
//

#import "PhotoAlbumListViewController.h"
#import <UIKit/UIKit.h>
#import "XRPhtoManager.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotoAlbumListCell.h"
#import <Photos/Photos.h>
#import "XRPhotosConfigs.h"

@interface PhotoAlbumListViewController ()<UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>
{
    XRPhtoManager * _phManager;
}

@property (nonatomic, strong) NSArray * albums;
@property (nonatomic, strong) UITableView * mainTableView;

@property (nonatomic, assign) CGSize targetSize;
@end

@implementation PhotoAlbumListViewController

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    _albums = [NSArray array];
    
    _targetSize = CGSizeMake(XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToLeft * 2.0, XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToTop * 2.0);
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _mainTableView.estimatedRowHeight = 0;
    _mainTableView.estimatedSectionFooterHeight = 0;
    _mainTableView.estimatedSectionHeaderHeight = 0;
    
    [_mainTableView registerClass:[XRPhotoAlbumListCell class] forCellReuseIdentifier:@"XRPhotoAlbumListCell"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.tableHeaderView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
    
    _phManager = [XRPhtoManager defaultManager];
    
    __weak __typeof(self) weakSelf = self;
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        // 获取相册
        [_phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:_targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.albums = albumList;
                [weakSelf.mainTableView reloadData];
            });
        }];
    }
    else {
        // 首次授权后最好有个加载提示
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied) {
                // 用户首次授权时点击了 '不允许'，或者手动关闭了访问照片库的权限，需要做引导让用户打开照片库权限
            }
            else if (status == PHAuthorizationStatusAuthorized) {
                // 用户首次授权时点击了 '好'，开始请求数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 获取相册
                    [_phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:_targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.albums = albumList;
                            [weakSelf.mainTableView reloadData];
                        });
                    }];
                });
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < _albums.count) {
        XRPhotoAlbumListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XRPhotoAlbumListCell"];
        if (!cell) {
            cell = [[XRPhotoAlbumListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XRPhotoAlbumListCell"];
        }
        
        XRPhotoAlbumModel * model = _albums[indexPath.row];
        [cell configPhotoAlbumCellWithAlbumModel:model];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XR_PhotoAlbumList_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < _albums.count) {
        XRPhotoAlbumModel * album = _albums[indexPath.row];
//        XRImagePickerController * imagePicker = [[XRImagePickerController alloc] initWithAlbumModel:album];
//        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}

@end
