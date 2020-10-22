//
//  NSObject+FileSize.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FileSize)

+ (NSString *)stringFromSize:(unsigned long long)size;

@end

NS_ASSUME_NONNULL_END
