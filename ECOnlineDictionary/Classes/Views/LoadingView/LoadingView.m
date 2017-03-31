//
//  ECDTranslationPreviewViewController.h
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView()
@property (strong,nonatomic) UIActivityIndicatorView *indicator;
@end
@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setUpView];
    return self;
}
- (void)setUpView
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.bounds;
    [self addSubview:visualEffectView];
    
    self.indicator   = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30,30)];
    _indicator.color = [UIColor darkGrayColor];
    [self.indicator setCenter:self.center];
    [self.indicator startAnimating];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0;
    [self addSubview:self.indicator];
    
}
- (void)presentLoadingView:(UIViewController*)controller;
{
    
    [self setCenter:controller.view.center];
    [controller.view addSubview:self];
}

@end
