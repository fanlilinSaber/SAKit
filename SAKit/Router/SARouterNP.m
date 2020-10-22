//
//  SARouterNP.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/14.
//

#import "SARouterNP.h"
#import "SAFilePreviewViewController.h"
#import "SAQFilePreviewController.h"

@implementation SARouterNP

+ (void)openFilePreviewWithItems:(NSArray <SAFileInfo *>*)items style:(NSInteger)style
{
    UIViewController *viewController;
    if (style == 0) {
        viewController = [[SAFilePreviewViewController alloc] initWithItems:items];
    }else {
        viewController = [[SAQFilePreviewController alloc] initWithItems:items];
    }
    
    if ([SARouterNP currentViewController].navigationController) {
        [[SARouterNP currentViewController].navigationController pushViewController:viewController animated:YES];
    }else {
        [[SARouterNP currentViewController] presentViewController:viewController animated:YES completion:nil];
    }
}

+ (UIViewController *)filePreviewWithItems:(NSArray <SAFileInfo *>*)items
{
    SAFilePreviewViewController *viewController = [[SAFilePreviewViewController alloc] initWithItems:items];
    return viewController;
}

+ (QLPreviewController *)qlFilePreviewWithItems:(NSArray *)items
{
    SAQFilePreviewController *viewController = [[SAQFilePreviewController alloc] initWithItems:items];
    return viewController;
}

#pragma mark - other

+ (UIViewController *)currentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

@end
