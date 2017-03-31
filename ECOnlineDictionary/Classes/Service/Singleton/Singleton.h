//
//  Singleton.h
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject


+ (instancetype)sharedInstance;

+ (instancetype)instance;

+ (void)destroyInstance;

@property (assign, readonly) BOOL isInitialized;

@end
