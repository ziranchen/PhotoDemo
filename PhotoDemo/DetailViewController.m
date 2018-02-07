//
//  DetailViewController.m
//  PhotoDemo
//
//  Created by juchunchen on 2018/1/31.
//  Copyright © 2018年 juchunchen. All rights reserved.
//

#import "DetailViewController.h"
#import "PreviewViewController.h"

@interface DetailViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) NSMutableDictionary *imageDict;

@end

@implementation DetailViewController

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
	if (self = [super init]) {
		_imageDict = [@{} mutableCopy];
		_collection = assetCollection;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.delegate = self;
	view.dataSource = self;
	[view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"a"];
	view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:view];

	self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.collection options:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.fetchResult.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor redColor];
	UIImageView *imageView = [cell viewWithTag:10002];
	if (imageView == nil) {
		imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.tag = 10002;
		[cell.contentView addSubview:imageView];
	}
	
	PHAsset *asset = self.fetchResult[indexPath.row];
	
	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.synchronous = YES;
	options.networkAccessAllowed = YES;
	if (self.imageDict[asset.localIdentifier] == nil) {
		[[PHCachingImageManager defaultManager] requestImageForAsset:asset
														  targetSize:CGSizeMake(80, 80)
														 contentMode:PHImageContentModeAspectFill
															 options:options
													   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
		 {
			 NSLog(@"info: %@", info);
			 self.imageDict[asset.localIdentifier] = result;
			 dispatch_async(dispatch_get_main_queue(), ^{
				 [collectionView reloadData];
			 });
		 }];
	}
	
	imageView.image = self.imageDict[asset.localIdentifier];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	PreviewViewController *vc = [[PreviewViewController alloc] initWithAsset:self.fetchResult[indexPath.row]];
	[self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	PHAsset *asset = self.fetchResult[indexPath.row];
	UIImage *image = self.imageDict[asset.localIdentifier];
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	CGSize size = CGSizeMake(width, width);
	if (image) {
		size = CGSizeMake(width, width / image.size.width * image.size.height);
	}

	return CGSizeMake(80, 80);
}

@end
