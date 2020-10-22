//
//  SAFPPersistence.h
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SAFPFlow
/*&* 文件名 */
@property (nonatomic, copy) NSString *name;
/*&* 文件下载地址 */
@property (nonatomic, copy) NSString *url;
/*&* 文件类型 */
@property (nonatomic, copy) NSString *mimeType;
@end

@protocol SAFPPersistence

- (id<SAFPFlow>)flowWithUrl:(NSString *)url;

- (id<SAFPFlow>)createFlowWithUrl:(NSString *)url;

- (void)save;

@end
