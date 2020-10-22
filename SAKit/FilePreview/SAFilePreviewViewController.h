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

- (instancetype)initWithItems:(NSArray <SAFileInfo *>*)items;

@end

NS_ASSUME_NONNULL_END
