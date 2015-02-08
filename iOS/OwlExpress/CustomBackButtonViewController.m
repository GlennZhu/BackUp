//
//  CustomBackButtonViewController.m
//  OwlExpress
//
//  Created by Beck Chen on 2/1/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "CustomBackButtonViewController.h"

@interface CustomBackButtonViewController ()

@end

@implementation CustomBackButtonViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
