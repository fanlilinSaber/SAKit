//
//  SAFilePreviewCell.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import "SAFilePreviewCell.h"
#import <WebKit/WebKit.h>

@interface SAFilePreviewCell () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation SAFilePreviewCell

//View初始化
#pragma mark - view init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.contentView addSubview:self.webView];
        [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        [self addConstraints:@[topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]];
    }
    return self;
}

//View的配置、布局设置
#pragma mark - view config

//私有方法
#pragma mark - private method

//View的生命周期
#pragma mark - view life

//更新View的接口
#pragma mark - update view

//处理View的事件
#pragma mark - handle view event

//发送View的事件
#pragma mark - send view event

//公有方法
#pragma mark - public method

- (void)reload
{
    [self.webView.configuration.userContentController removeAllUserScripts];
    
    /// 目前针对单张图片居中显示处理方案---（有更好的方案可以优化）
    NSString *type = self.filePathURL.pathExtension;
    if ([type isEqualToString:@"png"] || [type isEqualToString:@"jpg"] || [type isEqualToString:@"jpge"]) {
        NSString *JScript = @"var body = document.getElementsByTagName('body')[0];\n"
        "body.style.padding = '0px'; \n"
        "body.style.margin = '0px'; \n"
        "body.style.display = '-webkit-flex'; \n"
        ;
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:JScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.webView.configuration.userContentController addUserScript:wkUScript];
    }
    
    [self.webView loadFileURL:self.filePathURL allowingReadAccessToURL:self.filePathURL.URLByDeletingLastPathComponent];
}

//Setters方法
#pragma mark - setters

//Getters方法
#pragma mark - getters

- (WKWebView *)webView
{
    if (_webView == nil) {
    
        WKUserContentController *userContentController = [WKUserContentController new];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

@end
