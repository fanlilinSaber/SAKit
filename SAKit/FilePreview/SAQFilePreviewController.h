//
//  SAQFilePreviewController.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import <QuickLook/QuickLook.h>

@class SAFileInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SAQFilePreviewController : QLPreviewController

- (instancetype)initWithItems:(NSArray <SAFileInfo *>*)items;

- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock;

@end

NS_ASSUME_NONNULL_END
