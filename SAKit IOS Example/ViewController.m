//
//  ViewController.m
//  SAKit IOS Example
//
//  Created by Fan Li Lin on 2020/10/14.
//

#import "ViewController.h"
#import <SAKit/SAKit.h>
#import "DataModel.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
/*&* <##> */
@property (nonatomic, strong) UITableView *tableView;
/*&* <##> */
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *types = @[@"png/jpg", @"doc", @"docx", @"xml", @"ppt", @"xl", @"txt", @"pdf", @"多个文件", @"多个文件2"];
    NSMutableArray *dataSource = NSMutableArray.new;
    for (int i = 0; i < types.count; i ++) {
        DataModel *model = DataModel.new;
        model.type = types[i];
        switch (i) {
            case 0:
                model.url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3922290090,3177876335&fm=26&gp=0.jpg";
                break;
            case 1:
                model.url = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
                break;
            case 2:
                model.url = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017291679316399.docx";
                break;
            case 3:
                model.url = @"hhttps://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/2020102901732566256572.xml";
                break;
            case 4:
                model.url = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029610271967219963.ppt";
                break;
            case 5:
                model.url = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/2020102901537492549413.xlsx";
                break;
            case 6:
                model.url = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017341473914249.txt";
                break;
            case 7:
                model.url = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
                break;
            case 8:

                break;
            case 9:

                break;
            case 10:

                break;

            default:
                break;
        }
        [dataSource addObject:model];
    }
    self.dataSource = dataSource.copy;

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DataModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.type;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8 || indexPath.row == 9) {
        SAFileInfo *info_01 = [SAFileInfo new];
        info_01.downloadUrl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3922290090,3177876335&fm=26&gp=0.jpg";

        SAFileInfo *info_02 = [SAFileInfo new];
        info_02.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017305172551126.pdf";
        
//        SAFileInfo *info_03 = [SAFileInfo new];
//        info_03.downloadUrl = @"https://app.api.marsdt.net/group1/M00/00/2E/wKgABV1d_hiAFbWMAVCEq5sDYms847_big.jpg";
        
        SAFileInfo *info_03 = [SAFileInfo new];
        info_03.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017361579315354.jpg";
        
        SAFileInfo *info_04 = [SAFileInfo new];
        info_04.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/2020102901537492549413.xlsx";
        
        SAFileInfo *info_05 = [SAFileInfo new];
        info_05.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017291679316399.docx";
        
        SAFileInfo *info_06 = [SAFileInfo new];
        info_06.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017314758647171.rtf";
        
        SAFileInfo *info_07 = [SAFileInfo new];
        info_07.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/2020102901732566256572.xml";
        
        SAFileInfo *info_08 = [SAFileInfo new];
        info_08.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017333099230900.doc";
        
        SAFileInfo *info_09 = [SAFileInfo new];
        info_09.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017341473914249.txt";
        
        SAFileInfo *info_010 = [SAFileInfo new];
        info_010.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029017345066650798.docm";
        
        SAFileInfo *info_011 = [SAFileInfo new];
        info_011.downloadUrl = @"https://shigongbang.oss-cn-hangzhou.aliyuncs.com/machine/610000/20201029610271967219963.ppt";
        
        if (indexPath.row == 8) {
            [SARouterNP openFilePreviewWithItems:@[info_01, info_02, info_03, info_04, info_05, info_06, info_07, info_08, info_09, info_010, info_011] style:1];
        }else if (indexPath.row == 9) {
            [SARouterNP openFilePreviewWithItems:@[info_01, info_02, info_03, info_04, info_05, info_06, info_07, info_08, info_09, info_010, info_011] style:0];
        }
    
        return;
    }
    DataModel *model = self.dataSource[indexPath.row];
    if (model.url.length > 0) {
        SAFileInfo *info = [SAFileInfo new];
        info.downloadUrl = model.url;
        [SARouterNP openFilePreviewWithItems:@[info] style:0];
    }
}

//Getters方法 / //Setters方法
#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
