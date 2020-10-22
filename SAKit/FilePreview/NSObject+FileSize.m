//
//  NSObject+FileSize.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/15.
//

#import "NSObject+FileSize.h"

@implementation NSObject (FileSize)

+ (NSString *)stringFromSize:(unsigned long long)size
{
    NSInteger KB = 1024;
    NSInteger MB_ = KB*KB;
    NSInteger GB = MB_*KB;
    
    if (size < 1000)
    {
        return @"0 B";
        
    }else if (size < KB)
    {
        return [NSString stringWithFormat:@"%.1f B", (float)size];
    }else if (size < MB_)
    {
        return [NSString stringWithFormat:@"%.1f KB",((float)size)/KB];
        
    }else if (size < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((float)size)/MB_];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((float)size)/GB];
    }
}

@end
