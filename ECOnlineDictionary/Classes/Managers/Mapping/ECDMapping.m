//
//  ECDMapping.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDMapping.h"

@implementation ECDMapping

+ (NSDictionary*)matchAttributeMapping
{
    return @{@"id"                :@"id",
             @"segment"           :@"segment",
             @"translation"       :@"translation",
             @"quality"           :@"quality",
             @"reference"         :@"reference",
             @"usage-count"       :@"usage_count",
             @"subject"           :@"subject",
             @"created-by"        :@"created_by",
             @"last-updated-by"   :@"last_updated_by",
             @"create-date"       :@"create_date",
             @"last-update-date"  :@"last_update_date",
             @"tm_properties"     :@"tm_properties",
             @"match"             :@"match"};
    
}


+ (NSDictionary*)responseDataAttributeMapping
{
    return @{@"translatedText" :   @"translatedText",
             @"match"          :   @"match"};
    
}
@end
