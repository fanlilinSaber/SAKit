//
//  SAQFilePreviewController.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import "SAQFilePreviewController.h"
#import "SAFileInfo.h"
#import "MMALoadersManager.h"
#import "MSTRnLoaderMacros.h"
#import "MSTFileDownloadToken.h"
#import "LEEAlert+FileDownload.h"
#import "NSObject+FileSize.h"
#import "UIViewController+SA.h"
#import "SAFPDownloaderOperation.h"
#import "SAFPCoreDataPersistence.h"

@interface SAQFilePreviewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>
@property (nonatomic, strong) SAFPCoreDataPersistence *persistence;
@property (nonatomic, copy) NSArray <SAFileInfo *>*items;
@property (nonatomic, copy) BOOL(^shouldOpenUrlBlock)(NSURL *url, id <QLPreviewItem>item);
/*&* 遮挡系统的错误提示 */
@property (nonatomic, strong) UILabel *contentLabel;
/*&* 是否可以加载 */
@property (nonatomic, assign) BOOL isLoad;
/*&* 是否读取数据 */
@property (nonatomic, assign) BOOL read;
/*&* 任务队列 */
@property (nonatomic, strong) NSOperationQueue *queue;
/*&* 本地可查看的文件 */
@property (nonatomic, assign) NSInteger localCount;
@end

@implementation SAQFilePreviewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPreviewItemIndex"];
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

//View初始化
#pragma mark - view init

- (instancetype)initWithItems:(NSArray<SAFileInfo *> *)items
{
    if (self = [super init]) {
        self.items = items;
        self.persistence = [[SAFPCoreDataPersistence alloc] init];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

//View的配置、布局设置
#pragma mark - view config

- (void)loadView
{
    [super loadView];
    [self showStateText];
    self.contentLabel.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// observer
    [self addObserver:self forKeyPath:@"currentPreviewItemIndex" options:
         NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return self.isLoad ? self.items.count : 0;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    SAFileInfo *info = self.items[index];
    return info.filePathURL;
}

#pragma mark - QLPreviewControllerDelegate

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    return !self.shouldOpenUrlBlock ? YES : self.shouldOpenUrlBlock(url, item);
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"currentPreviewItemIndex"] && object == self) {
        NSInteger currentIndex = [[change valueForKey:@"new"] integerValue];
        SAFileInfo *info = self.items[currentIndex];
        if (!info.isHasLocal) {
            [self showStateText];
        }else {
            self.contentLabel.hidden = YES;
        }
    }
}

//私有方法
#pragma mark - private method

- (void)downloadFileWithTitleLabel:(UILabel *)titleLabel contentLabel:(UILabel *)contentLabel;
{
    @weakify(self);
    NSInteger index = 0;
    self.queue = [[NSOperationQueue alloc] init];
    /// 单个依次下载 好做下载进度统计
    self.queue.maxConcurrentOperationCount = 1;
    NSMutableArray *queueArray = [NSMutableArray new];
    /// 下载成功文件数量
    __block NSInteger succeedCount = 0;
    /// 下载任务数量
    __block NSInteger queueCount = 0;
    __block NSInteger completedCount = 0;
    /// for
    for (SAFileInfo *info in self.items) {
        info.taskIdentifier = [NSString stringWithFormat:@"%ld", (long)index];
        /// 开始下载
        if (!info.isHasLocal) {
            self.isLoad = NO;
            
            SAFPDownloaderOperation *operation = [[SAFPDownloaderOperation alloc] initWithUrl:info.downloadUrl taskIdentifier:info.taskIdentifier persistence:self.persistence];
            
            operation.progressBlock = ^(NSProgress *downloadProgress, MSTFileDownloadToken *tokenTask) {
                NSLog(@"下载进度：%f", downloadProgress.fractionCompleted);
                
                NSString *received = [NSString stringFromSize:tokenTask.completedUnitCount];
                NSString *total = [NSString stringFromSize:tokenTask.totalUnitCount];
                NSString *progressText = [NSString stringWithFormat:@"%@/%@", received, total];
                NSString *titleText = [NSString stringWithFormat:@"数据正在下载中(%ld/%ld)", (long)completedCount, (long)queueCount];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    titleLabel.text = titleText;
                    contentLabel.text = progressText;
                });
            };
            
            operation.unzProgressBlock = ^(long entryNumber, long total, MSTFileDownloadToken *tokenTask) {
                NSLog(@"解压进度：%ld/%ld", entryNumber, total);
            };
            
            operation.completedBlock = ^(NSURLResponse *response, NSString *filePath, MSTFileDownloadToken *tokenTask, NSError *error) {
                completedCount ++;
                
                if (error) {
                    NSLog(@"下载失败：%@\n%@\ntaskIdentifier=%@", error, filePath, tokenTask.taskIdentifier);
                }else {
                    NSLog(@"下载成功：%@\ntaskIdentifier=%@", filePath, tokenTask.taskIdentifier);
                    succeedCount ++;
                }
                
                /// 下载任务全部完成（包含下载失败的）
                if (completedCount == queueCount) {

                    /// 全部下载成功直接 reloadData 显示
                    if (succeedCount == queueCount) {
                        [LEEAlert closeWithCompletionBlock:^{
                            @strongify(self);
                            [self loadLocalData];
                        }];
                    }
                    /// 有失败的任务 提示是否尝试重新下载
                    else {
                        NSString *title = [NSString stringWithFormat:@"有%ld个文件下载失败", (long)(queueCount - succeedCount)];
                        [LEEAlert showAlertWithTitle:title content:@"尝试重新下载?" cancelBlock:^{
                            @strongify(self);
                            [self cancelDownloadHandle];
                        } startBlock:^{

                            /// 开始下载
                            [LEEAlert showAlertProgress:^(UILabel * _Nonnull titleLabel, UILabel * _Nonnull contentLabel) {
                                @strongify(self);
                                [self downloadFileWithTitleLabel:titleLabel contentLabel:contentLabel];
                            } cancelBlock:^{
                                @strongify(self);
                                [self cancelDownloadHandle];
                            }];
                        }];
                    }
                }
            };
            
            /// addd queue
            [queueArray addObject:operation];
            
            queueCount ++;
            
        }
        
        index ++;
    }
    
    [self.queue addOperations:queueArray.copy waitUntilFinished:NO];
}

- (void)loadLocalData
{
    NSMutableArray *items = [NSMutableArray new];
    for (SAFileInfo *info in self.items) {
        if (info.isHasLocal) {
            [items addObject:info];
        }
    }
    self.items = items.mutableCopy;
    self.contentLabel.hidden = self.items.count > 0 ? YES : NO;
    self.isLoad = YES;
    [self reloadData];
}

- (void)cancelDownloadHandle
{
    @weakify(self);
    /// 有可查看的文件
    if (self.localCount > 0) {
        NSString *alertTitle = [NSString stringWithFormat:@"有%ld个文件可查看", (long)self.localCount];
        /// 查看提示
        [LEEAlert showAlertLoadWithTitle:alertTitle cancelBlock:^{
            @strongify(self);
            [self closeViewController];
        } startBlock:^{
            @strongify(self);
            [self loadLocalData];
        }];
    }else {
        /// 直接退出
        [self closeViewController];
    }
}

//View的生命周期
#pragma mark - view life

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /// 在这里开始执行数据 是为了 LEEAlert 显示平滑点
    if(!self.read) {
        self.read = YES;
        
        @weakify(self);
        NSInteger index = 0;
        __block NSString *alertTitle = @"下载提醒";
        /// 需要下载文件的文件数量
        NSInteger downloadCount = 0;
        NSInteger localCount = 0;
        for (SAFileInfo *info in self.items) {
            info.taskIdentifier = [NSString stringWithFormat:@"%ld", (long)index];
            /// 需要下载
            if (!info.isHasLocal) {
                downloadCount ++;
            }else {
                localCount ++;
            }
        }
        
        /// 不需要下载-- 直接加载
        if (downloadCount == 0) {
            self.isLoad = YES;
            self.contentLabel.hidden = YES;
            [self reloadData];
        }else {
            alertTitle = [NSString stringWithFormat:@"剩余%ld个文件需要下载(%ld/%ld)", (long)downloadCount, (long)localCount, (long)self.items.count];
            /// 下载提示
            [LEEAlert showAlertWithTitle:alertTitle cancelBlock:^{
                @strongify(self);
                [self cancelDownloadHandle];
            } startBlock:^{
                /// 开始下载
                [LEEAlert showAlertProgress:^(UILabel * _Nonnull titleLabel, UILabel * _Nonnull contentLabel) {
                    @strongify(self);
                    [self downloadFileWithTitleLabel:titleLabel contentLabel:contentLabel];
                } cancelBlock:^{
                    
                }];
            }];
        }
        self.localCount = localCount;
    }
}

//更新View的接口
#pragma mark - update view

- (void)showStateText
{
    if (self.contentLabel.superview == nil) {
        self.contentLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:self.contentLabel];
        self.contentLabel.text = @"正在下载...";
    }
    self.contentLabel.hidden = NO;
}

//处理View的事件
#pragma mark - handle view event

//发送View的事件
#pragma mark - send view event

//公有方法
#pragma mark - public method

//Setters方法
#pragma mark - setters

- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock
{
    _shouldOpenUrlBlock = [shouldOpenUrlBlock copy];
}

//Getters方法
#pragma mark - getters

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = UIColor.blackColor;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = UIColor.whiteColor;
    }
    return _contentLabel;
}

- (NSInteger)localCount
{
    NSInteger localCount = 0;
    for (SAFileInfo *info in self.items) {
        if (info.isHasLocal) {
            localCount ++;
        }
    }
    return localCount;
}

@end
