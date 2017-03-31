//
//  ECDRestManager.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDRestManager.h"
#import <RestKit.h>
#import "ECDMapping.h"


NSString *baseURL = @"http://api.mymemory.translated.net";

@import CoreData;

@implementation ECDRestManager

#pragma mark - 
#pragma mark - Setup

- (void)setupRestWithCoreData
{
  
   	
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
    
    
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
   
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
   
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"ECOnlineDictionaryDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    [managedObjectStore createManagedObjectContexts];
    
  managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
  
  
    RKEntityMapping  *translationMapping = [RKEntityMapping mappingForEntityForName:@"Translation" inManagedObjectStore:managedObjectStore];
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"ResponseData" inManagedObjectStore:managedObjectStore];
    
    [responseMapping addAttributeMappingsFromDictionary:[ECDMapping responseDataAttributeMapping]];
    
    
    RKEntityMapping *matchMapping = [RKEntityMapping mappingForEntityForName:@"Match" inManagedObjectStore:managedObjectStore];
    
    [matchMapping addAttributeMappingsFromDictionary:[ECDMapping matchAttributeMapping]];
    
    RKRelationshipMapping *responseRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"responseData" toKeyPath:@"responseData" withMapping:responseMapping];
    
    RKRelationshipMapping *matchRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"matches" toKeyPath:@"matches" withMapping:matchMapping];
    
    
    [translationMapping addPropertyMapping:matchRelation];
    [translationMapping addPropertyMapping:responseRelation];
    
   
    
    
    RKResponseDescriptor *articleListResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:translationMapping
                                                                                                       method:RKRequestMethodGET
                                                                                                  pathPattern:@"/get"
                                                                                                      keyPath:nil
                                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    [objectManager addResponseDescriptor:articleListResponseDescriptor];
    
}

#pragma mark - Requests


- (void)translateWord:(NSString*)word fromLang:(NSString*)fromLang toLang:(NSString*)toLang result:(resultBlock)result
{
   
    NSString *urlPath = [NSString stringWithFormat:@"/get?q=%@&langpair=%@|%@",word,fromLang,toLang];
    
     NSString *refactoredUrlPath = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; 
    

    
    [[RKObjectManager sharedManager]getObjectsAtPath:refactoredUrlPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        result(word,nil);
       
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
       result(nil,error);
    }];
    
}


@end
