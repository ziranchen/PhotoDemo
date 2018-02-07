//
//  ViewController.m
//  PhotoDemo
//
//  Created by juchunchen on 2018/1/31.
//  Copyright © 2018年 juchunchen. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@import Photos;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSArray<PHAssetCollection *> *assetCollections;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self addPhotoChangeObserver];
	
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	PHFetchResult<PHAssetCollection *> *fetchResult =
	[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
											 subtype:PHAssetCollectionSubtypeAny
											 options:nil];
	
	PHFetchResult<PHAssetCollection *> *fetchResult2 =
	[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
											 subtype:PHAssetCollectionSubtypeAny
											 options:nil];
	
	NSMutableArray *tmp = [NSMutableArray array];
	[fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[tmp addObject:obj];
	}];
	
	[fetchResult2 enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[tmp addObject:obj];
	}];

	self.assetCollections = [NSArray arrayWithArray:tmp];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
	}
	
	PHAssetCollection *collection = self.assetCollections[indexPath.row];
	
	NSInteger assetCount = [PHAsset fetchAssetsInAssetCollection:collection options:nil].count;
	NSString *title = [collection.localizedTitle stringByAppendingString:@(assetCount).stringValue];
	cell.textLabel.text = title;
	
	
	PHFetchResult<PHAsset *> *keyAssets = [PHAsset fetchKeyAssetsInAssetCollection:collection options:nil];
	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.synchronous = YES;
	[[PHCachingImageManager defaultManager] requestImageForAsset:keyAssets.firstObject
													  targetSize:CGSizeMake(50, 50)
													 contentMode:PHImageContentModeAspectFill
														 options:options
												   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
	{
		NSLog(@"resultHandler. indexPath: %@, info: %@", indexPath, info);
		cell.imageView.image = result;
	}];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailViewController *vc = [[DetailViewController alloc] initWithAssetCollection:self.assetCollections[indexPath.row]];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
	dispatch_async(dispatch_get_main_queue(), ^{
		//TODO
	});
}

- (void)addPhotoChangeObserver {
	[[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

@end
