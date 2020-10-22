//
//  LEEAlert+FileDownload.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import "LEEAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface LEEAlert (FileDownload)

+ (void)showAlertWithTitle:(NSString *)title
               cancelBlock:(void (^)(void))cancelBlock
                startBlock:(void (^)(void))startBlock;

+ (void)showAlertLoadWithTitle:(NSString *)title
                   cancelBlock:(void (^)(void))cancelBlock
                    startBlock:(void (^)(void))startBlock;

+ (void)showAlertProgress:(void (^)(UILabel *titleLabel, UILabel *contentLabel))progressBlock
              cancelBlock:(void (^)(void))cancelBlock;

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelBlock:(void (^)(void))cancelBlock
                startBlock:(void (^)(void))startBlock;

@end

NS_ASSUME_NONNULL_END
