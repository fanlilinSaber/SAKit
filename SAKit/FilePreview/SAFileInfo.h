//
//  SAFileInfo.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import <Foundation/Foundation.h>

@class SAFPCoreDataFlow;

NS_ASSUME_NONNULL_BEGIN

@interface SAFileInfo : NSObject
/*&* 本地缓存的文件信息 */
@property (nonatomic, strong, readonly) SAFPCoreDataFlow *localInfo;
/*&* 下载地址 */
@property (nonatomic, copy) NSString *downloadUrl;
/*&* 本地是否有数据 */
@property (nonatomic, assign, readonly, getter=isHasLocal) BOOL hasLocal;
/*&* 本地地址路径(根据下载文件地址自动生成) */
@property (nonatomic, copy, readonly) NSURL *filePathURL;
/*&* 用于下载任务标识 */
@property (nonatomic, copy) NSString *taskIdentifier;
@end

NS_ASSUME_NONNULL_END
