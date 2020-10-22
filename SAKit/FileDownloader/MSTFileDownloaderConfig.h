//
//  MSTFileDownloaderConfig.h
//  MSTRnLoader
//
//  Created by Fan Li Lin on 2019/4/19.
//  Copyright © 2019 puwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSTFileDownloaderConfig : NSObject
/*&* 这是默认的下载器配置; 大多数配置属性都支持在下载过程中进行动态更改 */
@property (nonatomic, class, readonly, nonnull) MSTFileDownloaderConfig *defaultDownloaderConfig;
/*&* 并发下载最大数，默认 6 */
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;
/*&* 每个下载任务超时，以秒为单位，默认 15.0 */
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

+ (NSString *)downloadDir;

@end

NS_ASSUME_NONNULL_END


#pragma mark - Hash

#define SA_MAX_FILE_EXTENSION_LENGTH (NAME_MAX - CC_MD5_DIGEST_LENGTH * 2 - 1)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
static inline NSString * _Nonnull SADiskCacheFileNameForKey(NSString * _Nullable key) {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:key];
    NSString *ext = keyURL ? keyURL.pathExtension : key.pathExtension;
    // File system has file name length limit, we need to check if ext is too long, we don't add it to the filename
    if (ext.length > SA_MAX_FILE_EXTENSION_LENGTH) {
        ext = nil;
    }
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
    return filename;
}
#pragma clang diagnostic pop
