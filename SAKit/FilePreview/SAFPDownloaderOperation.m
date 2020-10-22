//
//  SAFPDownloaderOperation.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import "SAFPDownloaderOperation.h"
#import "MMALoadersManager.h"
#import "MSTRnLoaderMacros.h"
#import "SAFPCoreDataPersistence.h"

@interface SAFPDownloaderOperation ()
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *taskIdentifier;
@property (weak, nonatomic) id<SAFPPersistence> persistence;
@end

@implementation SAFPDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithUrl:(NSString *)url
             taskIdentifier:(NSString *)taskIdentifier
                persistence:(id<SAFPPersistence>)persistence;
{
    self = [super init];
    if (self) {
        _url = url;
        _taskIdentifier = taskIdentifier;
        _persistence = persistence;
    }
    return self;
}

- (void)start
{
    @weakify(self);
    [[MMALoadersManager sharedManager] downloadFileWithURL:[NSURL URLWithString:self.url] ownFileName:nil taskIdentifier:self.taskIdentifier progress:^(NSProgress *downloadProgress, MSTFileDownloadToken *tokenTask) {
        @strongify(self);
        if (self.progressBlock) {
            self.progressBlock(downloadProgress, tokenTask);
        }
    } unzProgress:^(long entryNumber, long total, MSTFileDownloadToken *tokenTask) {
        @strongify(self);
        if (self.unzProgressBlock) {
            self.unzProgressBlock(entryNumber, total, tokenTask);
        }
    } completed:^(NSURLResponse *response, NSString *filePath, NSError *error, MSTFileDownloadToken *tokenTask) {
        @strongify(self);
        if (!error) {
            SAFPCoreDataFlow *flow = (SAFPCoreDataFlow *)[self.persistence flowWithUrl:self.url];
            if (flow) {
                flow.name = filePath.lastPathComponent;
                flow.mimeType = response.MIMEType;
            }else {
                flow = (SAFPCoreDataFlow *)[self.persistence createFlowWithUrl:self.url];
                flow.url = self.url;
                flow.name = filePath.lastPathComponent;
                flow.mimeType = response.MIMEType;
            }
            if (flow) {
                [self.persistence save];
            }
        }
        if (self.completedBlock) {
            self.completedBlock(response, filePath, tokenTask, error);
        }
        [self done];
    }];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

//- (void)dealloc
//{
//    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//}

@end
