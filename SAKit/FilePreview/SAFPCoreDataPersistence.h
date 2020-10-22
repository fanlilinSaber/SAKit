//
//  SAFPCoreDataPersistence.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SAFPPersistence.h"

@interface SAFPCoreDataPersistence : NSObject <SAFPPersistence>

+ (instancetype)sharedInstance;

@end

@interface SAFPFlow : NSManagedObject <SAFPFlow>
@end

@interface SAFPCoreDataFlow : NSObject <SAFPFlow>
@end
