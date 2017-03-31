//
//  Singleton.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

// Dictionary that holds all instances of DOSingleton subclasses
static NSMutableDictionary *_sharedInstances = nil;



+ (void)initialize
{
    if (_sharedInstances == nil) {
        _sharedInstances = [NSMutableDictionary dictionary];
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    return [self sharedInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    
    return [self sharedInstance];
}

#pragma mark -

+ (instancetype)sharedInstance
{
    id sharedInstance = nil;
    
    @synchronized(self) {
        NSString *instanceClass = NSStringFromClass(self);
        
       
        sharedInstance = [_sharedInstances objectForKey:instanceClass];
        
        
        if (sharedInstance == nil) {
            sharedInstance = [[super allocWithZone:nil] init];
            [_sharedInstances setObject:sharedInstance forKey:instanceClass];
        }
    }
    
    return sharedInstance;
}

+ (instancetype)instance
{
    return [self sharedInstance];
}

#pragma mark -

+ (void)destroyInstance
{
    [_sharedInstances removeObjectForKey:NSStringFromClass(self)];
}

#pragma mark -

- (id)init
{
    self = [super init];
    
    if (self && !self.isInitialized) {
        
        _isInitialized = YES;
    }
    
    return self;
}





@end
