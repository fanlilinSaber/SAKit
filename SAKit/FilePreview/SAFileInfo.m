//
//  SAFileInfo.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import "SAFileInfo.h"
#import "MMALoadersManager.h"
#import "MSTFileDownloaderConfig.h"
#import "SAFPCoreDataPersistence.h"
#import "MSTFileDownloaderOperation.h"

@interface SAFileInfo ()
@property (nonatomic, strong) SAFPCoreDataFlow *localInfo;
@end

@implementation SAFileInfo

- (BOOL)isHasLocal
{
    if (self.localInfo == nil) {
        return NO;;
    }
    
    NSString *downloadDir = [MSTFileDownloaderConfig downloadDir];
    NSString *diskCachePath = SADiskCacheFileNameForKey(self.downloadUrl);
    NSString *bundlePath = [downloadDir stringByAppendingPathComponent:diskCachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath isDirectory:NULL]) {
        return YES;
    }
    return NO;
}

- (NSURL *)filePathURL
{
    NSString *diskCachePath = SADiskCacheFileNameForKey(self.downloadUrl);
    return [MMALoadersManager bundleURLWithLastPath:diskCachePath];
}

- (SAFPCoreDataFlow *)localInfo
{
    if (_localInfo == nil) {
        /// 本地 coreData
        SAFPCoreDataFlow *flow = (SAFPCoreDataFlow *)[[SAFPCoreDataPersistence sharedInstance] flowWithUrl:self.downloadUrl];
        _localInfo = flow;
    }
    return _localInfo;
}

@end
