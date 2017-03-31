//
//  ECDHistoryCell.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDHistoryCell.h"
#import "Translation+CoreDataProperties.h"
#import "ResponseData+CoreDataClass.h"
#import "Match+CoreDataClass.h"
#import "Match+CoreDataProperties.h"


@interface ECDHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *translationLabel;


@end

@implementation ECDHistoryCell


- (void)setupWithTranslation:(Translation *)translation
{
      Match * ma = translation.matches.anyObject;
    [self.translationLabel setText: ma.segment];
  
    
  
}





@end
