//
//  ECDTranslateTextField.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/31/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDTranslateTextField.h"

@implementation ECDTranslateTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputModeChanged)
                                                 name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}



- (void)inputModeChanged
{
    UITextInputMode *inputMode = [self textInputMode];
    NSString *fromLang = [inputMode.primaryLanguage substringToIndex:2];
    NSString *toLang = [fromLang isEqualToString:@"uk"] || [fromLang isEqualToString:@"ru"]  ? @"en" : @"uk" ;
    
    UIImageView *fromLangImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:fromLang]];
    UIImageView *toLangImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:toLang]];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setRightViewMode:UITextFieldViewModeAlways];
   
    
    [self setRightView:toLangImage];
    [self setLeftView:fromLangImage];
    
    

    
}




@end
