//
//  StudentDetailTVC.h
//  OwlExpress
//
//  Created by Beck Chen on 1/31/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackButtonTVC.h"

@interface StudentDetailTVC : CustomBackButtonTVC

@property (nonatomic, getter=isScan) BOOL isScan;
@property (nonatomic) UIImage *photo;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *college;

@end
