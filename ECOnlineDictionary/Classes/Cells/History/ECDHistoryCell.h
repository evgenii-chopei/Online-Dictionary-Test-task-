//
//  ECDHistoryCell.h
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Translation;

@interface ECDHistoryCell : UITableViewCell


- (void)setupWithTranslation:(Translation*)translation;

@end
