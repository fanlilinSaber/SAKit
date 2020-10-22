//
//  UIViewController+SA.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/16.
//

#import "UIViewController+SA.h"

@implementation UIViewController (SA)

- (void)closeViewController
{
    if (self.navigationController) {
        NSArray *viewcontrollers= self.navigationController.viewControllers;
        if (viewcontrollers.count > 1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1] == self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
