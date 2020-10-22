//
//  SAFilePreviewViewController.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import <UIKit/UIKit.h>

@class SAFileInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SAFilePreviewViewController : UIViewController

/// 返回一个文件浏览器
/// @param items 包含文件的基本信息
- (instancetype)initWithItems:(NSArray <SAFileInfo *>*)items;

@end

NS_ASSUME_NONNULL_END
