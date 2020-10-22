//
//  MMALoadersManager.h
//  MSTRnLoader
//
//  Created by Fan Li Lin on 2019/4/25.
//  Copyright © 2019 puwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSTFileDownloadToken;

@interface MMALoadersManager : NSObject
/*&* 返回一个单例加载器 */
@property (nonatomic, class, readonly) MMALoadersManager *sharedManager;

/// 初始化一个全局下载器 （不需要自己管理下载队列）
/// @param url 下载文件url
/// @param ownFileName 文件名（用于写入沙盒的文件命名，不设置 默认用下载url Hash命名）
/// @param taskIdentifier 下载任务标识
/// @param progressBlock 下载进度回调
/// @param unzProgressBlock 解压进度回调
/// @param completedBlock 完成回调
- (MSTFileDownloadToken *)downloadFileWithURL:(NSURL *)url
                                  ownFileName:(NSString *)ownFileName
                               taskIdentifier:(NSString *)taskIdentifier
                                     progress:(void(^)(NSProgress *downloadProgress, MSTFileDownloadToken *tokenTask))progressBlock
                                  unzProgress:(void(^)(long entryNumber, long total, MSTFileDownloadToken *tokenTask))unzProgressBlock
                                    completed:(void (^)(NSURLResponse *response, NSString *filePath, NSError *error, MSTFileDownloadToken *tokenTask))completedBlock;

/// 获取文件地址
/// @param lastPath 文件名
+ (NSURL *)bundleURLWithLastPath:(NSString *)lastPath;

/**
 取消当前下载器的所有下载任务
 */
- (void)cancelAllDownloads;

@end

