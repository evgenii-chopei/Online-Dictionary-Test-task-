//
//  ECDTranslationPreviewViewController.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDTranslationPreviewViewController.h"
#import "Translation+CoreDataProperties.h"
#import "ResponseData+CoreDataProperties.h"
#import "Match+CoreDataProperties.h"

@interface ECDTranslationPreviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textToTranslateLabel;
@property (weak, nonatomic) IBOutlet UILabel *translatedText;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;


@end

@implementation ECDTranslationPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.translation)
    {
        [self.textToTranslateLabel setText:self.translation.matches.anyObject.segment];
        [self.translatedText setText:self.translation.responseData.translatedText];
        [self.subjectLabel setText:self.translation.matches.anyObject.subject];
        
        
    }
        
    
}
- (IBAction)closeAction:(id)sender {
    [UIView animateWithDuration:0.7 animations:^{
        self.view.layer.opacity = 0.0;
    }completion:^(BOOL finished) {
       [self dismissViewControllerAnimated:NO completion:nil];
         }];

}



@end
