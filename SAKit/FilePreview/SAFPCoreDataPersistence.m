//
//  SAFPCoreDataPersistence.m
//  SAKit
//
//  Created by Fan Li Lin on 2020/10/19.
//  Copyright © 2020 zhongjun. All rights reserved.
//

#import "SAFPCoreDataPersistence.h"

#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
#define SALogError(fmt, ...) DDLogError((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SALogVerbose(fmt, ...) DDLogVerbose((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SALogError(...) NSLog(__VA_ARGS__)
#define SALogVerbose(...) NSLog(__VA_ARGS__)
#endif

@implementation SAFPFlow
@dynamic name;
@dynamic url;
@dynamic mimeType;

@end

@interface SAFPCoreDataFlow ()

- (SAFPCoreDataFlow *)initWithContext:(NSManagedObjectContext *)context
                            andObject:(id<SAFPFlow>)object;
@property NSManagedObjectContext *context;
@property id<SAFPFlow> object;

@end

@implementation SAFPCoreDataFlow

@synthesize context;
@synthesize object;

- (SAFPCoreDataFlow *)initWithContext:(NSManagedObjectContext *)context
                            andObject:(id<SAFPFlow>)object
{
    if (self = [super init]) {
        self.context = context;
        self.object = object;
    }
    return self;
}

- (NSString *)name
{
    __block NSString *_name;
    [context performBlockAndWait:^{
        _name = self.object.name;
    }];
    return _name;
}

- (void)setName:(NSString *)name
{
    [context performBlockAndWait:^{
        self.object.name = name;
    }];
}

- (NSString *)url
{
    __block NSString *_url;
    [context performBlockAndWait:^{
        _url = self.object.url;
    }];
    return _url;
}

- (void)setUrl:(NSString *)url
{
    [context performBlockAndWait:^{
        self.object.url = url;
    }];
}

- (NSString *)mimeType
{
    __block NSString *_mimeType;
    [context performBlockAndWait:^{
        _mimeType = self.object.mimeType;
    }];
    return _mimeType;
}

- (void)setMimeType:(NSString *)mimeType
{
    [context performBlockAndWait:^{
        self.object.mimeType = mimeType;
    }];
}

@end

@interface SAFPCoreDataPersistence ()
@property (strong, nonatomic) NSManagedObjectContext *persistingMoc;
@property (strong, nonatomic) NSManagedObjectContext *mainMoc;
@end

@implementation SAFPCoreDataPersistence

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - SAFPPersistence

- (SAFPCoreDataFlow *)flowWithUrl:(NSString *)url
{
    __block SAFPCoreDataFlow *flow = nil;

    [self.mainMoc performBlockAndWait:^{
        flow = [self internalFlowWithUrl:url];
    }];

    return flow;
}

- (void)save
{
    [self.mainMoc performBlockAndWait:^{
        [self internalSync];
    }];
}


- (void)internalSync
{
    if ([self.mainMoc hasChanges] || [self.persistingMoc hasChanges]) {
        SALogVerbose(@"[SAFPPersistence] pre-sync: i%lu u%lu d%lu",
                     (unsigned long)self.mainMoc.insertedObjects.count,
                     (unsigned long)self.mainMoc.updatedObjects.count,
                     (unsigned long)self.mainMoc.deletedObjects.count
                     );
        NSError *error = nil;
        if (![self.mainMoc save:&error]) {
             SALogError(@"[SAFPPersistence] Error: save managed object in main context !!!\n%@\n", [error localizedDescription]);
        }
        if (self.mainMoc.hasChanges) {
             SALogError(@"[SAFPPersistence] sync not complete");
        }
        [self.persistingMoc performBlock:^{
            NSError *error = nil;
            if (![self.persistingMoc save:&error]) {
                 SALogError(@"[SAFPPersistence] Error: save managed object in persisting context !!!\n%@\n", [error localizedDescription]);
            }
        }];
        SALogVerbose(@"[SAFPPersistence] postsync: i%lu u%lu d%lu",
                     (unsigned long)self.mainMoc.insertedObjects.count,
                     (unsigned long)self.mainMoc.updatedObjects.count,
                     (unsigned long)self.mainMoc.deletedObjects.count
                     );
    }
}

- (SAFPCoreDataFlow *)internalFlowWithUrl:(NSString *)Url
{
    SAFPCoreDataFlow *flow = nil;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SAFPFlow"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url = %@", Url];;
    NSArray *rows;
    NSError *error = nil;
    rows = [self.mainMoc executeFetchRequest:fetchRequest error:&error];
    if (!rows) {
        SALogError(@"[SAFPPersistence] flowForUrl %@", error);
    } else {
        if (rows.count) {
            flow = [[SAFPCoreDataFlow alloc] initWithContext:self.mainMoc
                                                   andObject:rows.lastObject];
        }
    }
    return flow;
}

- (SAFPCoreDataFlow *)createFlowWithUrl:(NSString *)url
{
    SAFPCoreDataFlow *flow = (SAFPCoreDataFlow *)[self internalFlowWithUrl:url];
    
    if (!flow) {
        __block id<SAFPFlow> item;
        [self.mainMoc performBlockAndWait:^{
            item = [NSEntityDescription insertNewObjectForEntityForName:@"SAFPFlow"
                                                 inManagedObjectContext:self.mainMoc];
            item.url = url;
        }];
        flow = [[SAFPCoreDataFlow alloc] initWithContext:self.mainMoc andObject:item];
    }
    return flow;
}

#pragma mark - Core Data stack

- (NSManagedObjectModel *)createManagedObjectModel
{
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] init];
    NSMutableArray *entities = [[NSMutableArray alloc] init];
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    
    NSAttributeDescription *attributeDescription;
    
    attributeDescription = [[NSAttributeDescription alloc] init];
    attributeDescription.name = @"name";
    attributeDescription.attributeType = NSStringAttributeType;
    attributeDescription.attributeValueClassName = @"NSString";
    [properties addObject:attributeDescription];
    
    attributeDescription = [[NSAttributeDescription alloc] init];
    attributeDescription.name = @"url";
    attributeDescription.attributeType = NSStringAttributeType;
    attributeDescription.attributeValueClassName = @"NSString";
    [properties addObject:attributeDescription];
    
    attributeDescription = [[NSAttributeDescription alloc] init];
    attributeDescription.name = @"mimeType";
    attributeDescription.attributeType = NSStringAttributeType;
    attributeDescription.attributeValueClassName = @"NSString";
    [properties addObject:attributeDescription];
    
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    entityDescription.name = @"SAFPFlow";
    entityDescription.managedObjectClassName = @"SAFPFlow";
    entityDescription.abstract = FALSE;
    entityDescription.properties = properties;
    
    [entities addObject:entityDescription];
    managedObjectModel.entities = entities;
    
    return managedObjectModel;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator
{
    NSURL *persistentStoreURL = [[self applicationDocumentsDirectory]
                                 URLByAppendingPathComponent:@"SAFPClient"];
    
    NSError *error = nil;
    NSManagedObjectModel *model = [self createManagedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:model];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES,
                              NSSQLiteAnalyzeOption: @YES,
                              NSSQLiteManualVacuumOption: @YES
                              };
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:persistentStoreURL
                                                        options:options
                                                          error:&error]) {
        persistentStoreCoordinator = nil;
    }
    return persistentStoreCoordinator;
}

#pragma mark - lazy mainMoc

- (NSManagedObjectContext *)mainMoc
{
    if (!_mainMoc) {
        NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinator];
        
        _persistingMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _persistingMoc.persistentStoreCoordinator = coordinator;
        
        _mainMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMoc.parentContext = _persistingMoc;
    }
    return _mainMoc;
}

@end
