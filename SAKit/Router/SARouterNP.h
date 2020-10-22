//
//  SARouterNP.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SAKit/SAFileInfo.h"
#import <QuickLook/QLPreviewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface SARouterNP : NSObject

/// 预览文件文件
/// @param items 文件信息
/// @param style 浏览器内核 0 -- WKWebView ；1 -- QLPreviewController
+ (void)openFilePreviewWithItems:(NSArray <SAFileInfo *>*)items style:(NSInteger)style;

/// 返回文件预览的 UIViewController
/// @param items 文件信息（SAFileInfo *info_03 = [SAFileInfo new]; info_03.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017361579315354.jpg";）
+ (UIViewController *)filePreviewWithItems:(NSArray <SAFileInfo *>*)items;

/// 返回文件预览 的 QLPreviewController
/// @param items 文件信息（SAFileInfo *info_03 = [SAFileInfo new]; info_03.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017361579315354.jpg";））
+ (QLPreviewController *)qlFilePreviewWithItems:(NSArray <SAFileInfo *>*)items;

@end

NS_ASSUME_NONNULL_END
