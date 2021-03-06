//
//  MSTFileDownloadToken.h
//  MSTRnLoader
//
//  Created by Fan Li Lin on 2019/4/22.
//  Copyright © 2019 puwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSTWebFileOperation.h"

@protocol MSTFileDownloaderOperation;
@class MSTFileDownloader;

/**
 A token associated with each download. Can be used to cancel a download
 */
@interface MSTFileDownloadToken : NSObject <MSTWebFileOperation>
/*&* 下载 URL */
@property (nonatomic, strong, readonly) NSURL *url;
/*&* 取消下载token */
@property (nonatomic, strong, readonly) id downloadOperationCancelToken;
/*&* 任务标识,跟下载队列没有关系，用于多个下载的地址一样时，返回对比数据 */
@property (nonatomic, copy, readonly) NSString *taskIdentifier;
/*&* 下载进度 */
@property (assign, nonatomic, readonly) float progress;
/*&* 解压进度 */
@property (assign, nonatomic, readonly) float unzProgress;
/*&* 下载文件总大小 */
@property (assign, nonatomic, readonly) int64_t totalUnitCount;
/*&* 已下载文件的大小 */
@property (assign, nonatomic, readonly) int64_t completedUnitCount;
/*&* 解压index */
@property (assign, nonatomic, readonly) long entryNumber;
/*&* 解压文件数量 */
@property (assign, nonatomic, readonly) long total;
/*&* 下载状态 */
@property (assign, nonatomic, readonly) MSTFileDownloaderState state;
/*&* 取消成功后回调 */
@property (nonatomic, copy) void (^cancelBlock)(void);

/// 初始化一个文件下载管理对象
/// @param downloadOperation 下载队列
/// @param url 下载url
/// @param taskIdentifier 任务标识
/// @param downloader 下载器
/// @param downloadOperationCancelToken 下载队列Token
- (instancetype)initWithDownloadOperation:(NSOperation<MSTFileDownloaderOperation> *)downloadOperation
                                      url:(NSURL *)url 
                           taskIdentifier:(NSString *)taskIdentifier
                               downloader:(MSTFileDownloader *)downloader
             downloadOperationCancelToken:(id)downloadOperationCancelToken;

/// 监听一个下载任务
/// @param progressBlock 下载进度
/// @param unzProgressBlock 解压进度
/// @param completedBlock 完成回调
- (MSTFileDownloadToken *)listenerForProgress:(MSTFileDownloaderProgressBlock)progressBlock
                                  unzProgress:(MSTFileDownloaderUNZProgressBlock)unzProgressBlock
                                    completed:(MSTFileDownloaderCompletedBlock)completedBlock;
/**
 取消当前下载
 */
- (void)cancel;

@end

