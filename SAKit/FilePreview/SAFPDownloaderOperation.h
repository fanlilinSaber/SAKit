//
//  SAFPDownloaderOperation.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAFPPersistence.h"

@class MSTFileDownloadToken;

@interface SAFPDownloaderOperation : NSBlockOperation
/*&* 下载进度回调 */
@property (nonatomic, copy) void (^progressBlock)(NSProgress *downloadProgress, MSTFileDownloadToken *tokenTask);
/*&* 解压进度回调 */
@property (nonatomic, copy) void (^unzProgressBlock)(long entryNumber, long total, MSTFileDownloadToken *tokenTask);
/*&* 任务完成回调 */
@property (nonatomic, copy) void (^completedBlock)(NSURLResponse *response, NSString *filePath, MSTFileDownloadToken *tokenTask, NSError *error);

/// init
/// @param url 下载文件地址
/// @param taskIdentifier 任务标识
/// @param persistence 数据持久化coreData
- (instancetype)initWithUrl:(NSString *)url
             taskIdentifier:(NSString *)taskIdentifier
                persistence:(id<SAFPPersistence>)persistence;

@end

