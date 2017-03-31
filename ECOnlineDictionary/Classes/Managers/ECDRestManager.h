//
//  ECDRestManager.h
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "Singleton.h"

extern NSString *baseURL;
typedef void (^resultBlock)(NSString *wordToTranslate, NSError * error);

@interface ECDRestManager : Singleton

- (void)translateWord:(NSString*)word fromLang:(NSString*)fromLang toLang:(NSString*)toLang result:(resultBlock)result;

- (void)setupRestWithCoreData;
@end
