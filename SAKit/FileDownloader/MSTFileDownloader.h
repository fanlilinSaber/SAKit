//
//  MSTFileDownloader.h
//  MSTRnLoader
//
//  Created by Fan Li Lin on 2019/4/19.
//  Copyright © 2019 puwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSTFileDownloaderConfig.h"
#import "MSTFileDownloadToken.h"

typedef NS_OPTIONS(NSUInteger, MSTFileDownloaderOptions) {
    
//    MSTFileDownloaderDefault = 1 << 0,

    /// 支持后台任务下载
    MSTFileDownloaderContinueInBackground = 1 << 0
};

@interface MSTFileDownloader : NSObject
/*&* 下载配置 */
@property (nonatomic, copy, readonly) MSTFileDownloaderConfig *config;
/*&* 内部NSURLSession使用的配置 */
@property (nonatomic, readonly) NSURLSessionConfiguration *sessionConfiguration;
/*&* 获取/设置下载队列暂停状态 */
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;
/*&* 当前仍需要下载的下载数量 */
@property (nonatomic, assign, readonly) NSUInteger currentDownloadCount;
/*&* 返回一个单例下载器 */
@property (nonatomic, class, readonly) MSTFileDownloader *sharedDownloader;

/**
 初始化下载器

 @param config 下载配置
 @return 下载器实例
 */
- (instancetype)initWithConfig:(MSTFileDownloaderConfig *)config;

/**
 初始化一个下载任务

 @param url 下载文件url
 @param progressBlock 下载进度回调
 @param unzProgressBlock 解压进度回调
 @param completedBlock 完成回调
 @return 返回一个下载任务 token；用于随时取消
 */
- (MSTFileDownloadToken *)downloadFileWithURL:(NSURL *)url
                                       progress:(MSTFileDownloaderProgressBlock)progressBlock
                                    unzProgress:(MSTFileDownloaderUNZProgressBlock)unzProgressBlock
                                      completed:(MSTFileDownloaderCompletedBlock)completedBlock;

/// 初始化一个下载任务
/// @param url 下载文件url
/// @param ownFileName 文件名（用于写入沙盒的文件命名，不设置 默认用下载url Hash命名）
/// @param progressBlock 下载进度回调
/// @param unzProgressBlock 解压进度回调
/// @param completedBlock 完成回调
- (MSTFileDownloadToken *)downloadFileWithURL:(NSURL *)url
                                    ownFileName:(NSString *)ownFileName
                                       progress:(MSTFileDownloaderProgressBlock)progressBlock
                                    unzProgress:(MSTFileDownloaderUNZProgressBlock)unzProgressBlock
                                      completed:(MSTFileDownloaderCompletedBlock)completedBlock;

/// 初始化一个下载任务
/// @param url 下载文件url
/// @param ownFileName 文件名（用于写入沙盒的文件命名，不设置 默认用下载url Hash命名）
/// @param taskIdentifier 下载任务标识
/// @param progressBlock 下载进度回调
/// @param unzProgressBlock 解压进度回调
/// @param completedBlock 完成回调
- (MSTFileDownloadToken *)downloadFileWithURL:(NSURL *)url
                                    ownFileName:(NSString *)ownFileName
                                 taskIdentifier:(NSString *)taskIdentifier
                                       progress:(MSTFileDownloaderProgressBlock)progressBlock
                                    unzProgress:(MSTFileDownloaderUNZProgressBlock)unzProgressBlock
                                      completed:(MSTFileDownloaderCompletedBlock)completedBlock;
/**
 取消一个下载任务

 @param token 任务token
 */
- (void)cancel:(MSTFileDownloadToken *)token;

/**
 取消当前下载器的所有下载任务
 */
- (void)cancelAllDownloads;

@end

