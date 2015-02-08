//
//  CustomBackButtonTVC.m
//  OwlExpress
//
//  Created by Beck Chen on 2/1/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "CustomBackButtonTVC.h"

@interface CustomBackButtonTVC ()

@end

@implementation CustomBackButtonTVC

- (void)loadView
{
    [super loadView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 30.0f, 30.0f)];
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
