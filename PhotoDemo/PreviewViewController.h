//
//  PreviewViewController.h
//  PhotoDemo
//
//  Created by juchunchen on 2018/1/31.
//  Copyright © 2018年 juchunchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface PreviewViewController : UIViewController

- (instancetype)initWithAsset:(PHAsset *)asset;

@end
