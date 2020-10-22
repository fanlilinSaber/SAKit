//
//  LEEAlert+FileDownload.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import "LEEAlert+FileDownload.h"
#import "LEEAlert.h"
#import "MMALoadersManager.h"
#import "MSTRnLoaderMacros.h"

@implementation LEEAlert (FileDownload)

+ (void)showAlertWithTitle:(NSString *)title
               cancelBlock:(void (^)(void))cancelBlock
                startBlock:(void (^)(void))startBlock
{
    [LEEAlert alert].config
    .LeeHeaderColor([UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f])
    .LeeAddTitle(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:15];
        label.text = title;
        label.textColor = UIColor.whiteColor;
    })
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"确认开始下载?";
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消下载";
        action.titleColor = [UIColor colorWithHue:6/360.0f saturation:74/100.0f brightness:91/100.0f alpha:1.0];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            [[MMALoadersManager sharedManager] cancelAllDownloads];
            if (cancelBlock) {
                cancelBlock();
            }
        }];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"确认下载";
        action.titleColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            if (startBlock) {
                startBlock();
            }
        }];
    })
    .LeeShow();
}

+ (void)showAlertLoadWithTitle:(NSString *)title
                   cancelBlock:(void (^)(void))cancelBlock
                    startBlock:(void (^)(void))startBlock
{
    [LEEAlert alert].config
    .LeeHeaderColor([UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f])
    .LeeAddTitle(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:15];
        label.text = title;
        label.textColor = UIColor.whiteColor;
    })
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"确认查看?";
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消查看";
        action.titleColor = [UIColor colorWithHue:6/360.0f saturation:74/100.0f brightness:91/100.0f alpha:1.0];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            if (cancelBlock) {
                cancelBlock();
            }
        }];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"确认查看";
        action.titleColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            if (startBlock) {
                startBlock();
            }
        }];
    })
    .LeeShow();
}

+ (void)showAlertProgress:(void (^)(UILabel *titleLabel, UILabel *contentLabel))progressBlock
              cancelBlock:(void (^)(void))cancelBlock;
{
    __weak __block UILabel *titleLabel;
    __weak __block UILabel *contentLabel;
    
    [LEEAlert alert].config
    .LeeHeaderColor([UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f])
    .LeeAddTitle(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"数据正在下载中";
        label.textColor = UIColor.whiteColor;
        titleLabel = label;
    })
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"下载准备中";
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
        contentLabel = label;
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消下载";
        action.titleColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            [[MMALoadersManager sharedManager] cancelAllDownloads];
            if (cancelBlock) {
                cancelBlock();
            }
        }];
    })
    .LeeShow();
    if (progressBlock) {
        progressBlock(titleLabel, contentLabel);
    }
}

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelBlock:(void (^)(void))cancelBlock
                startBlock:(void (^)(void))startBlock;
{
    [LEEAlert alert].config
    .LeeHeaderColor([UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f])
    .LeeAddTitle(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:15];
        label.text = title;
        label.textColor = UIColor.whiteColor;
    })
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.font = [UIFont systemFontOfSize:14];
        label.text = content;
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消下载";
        action.titleColor = [UIColor colorWithHue:6/360.0f saturation:74/100.0f brightness:91/100.0f alpha:1.0];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            [[MMALoadersManager sharedManager] cancelAllDownloads];
            if (cancelBlock) {
                cancelBlock();
            }
        }];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"重新下载";
        action.titleColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
        action.backgroundColor = [UIColor whiteColor];
        [action setClickBlock:^{
            if (startBlock) {
                startBlock();
            }
        }];
    })
    .LeeShow();
}

@end
