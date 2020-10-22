//
//  SAFilePreviewCell.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAFilePreviewCell : UICollectionViewCell
/*&* filePathURL */
@property (nonatomic, strong) NSURL *filePathURL;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
