//
//  PreviewViewController.m
//  PhotoDemo
//
//  Created by juchunchen on 2018/1/31.
//  Copyright © 2018年 juchunchen. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PreviewViewController

- (instancetype)initWithAsset:(PHAsset *)asset {
	if (self = [super init]) {
		_asset = asset;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	self.imageView.backgroundColor = [UIColor whiteColor];
	self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.imageView];

	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
	options.networkAccessAllowed = YES;
	options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
		NSLog(@"info: %@", info);
		dispatch_async(dispatch_get_main_queue(), ^{
			self.title = @(progress).stringValue;
		});
	};
	[[PHCachingImageManager defaultManager] requestImageForAsset:self.asset
													  targetSize:[UIScreen mainScreen].nativeBounds.size
													 contentMode:PHImageContentModeDefault
														 options:options
												   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
	{
		self.imageView.image = result;
	}];
}

@end
