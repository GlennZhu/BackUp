//
//  ScanViewController.m
//  OwlExpress
//
//  Created by Beck Chen on 1/31/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "ScanViewController.h"
#import "StudentDetailTVC.h"

@interface ScanViewController ()

@property (nonatomic) UIImage *photo;

@end

@implementation ScanViewController

- (IBAction)Scan:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)Type:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photo = nil;
}

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.photo = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"ScanSegue" sender:self];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ScanSegue"]) {
        if (self.photo) {
            NSLog(@"YES ScanSegue");
            return YES;
        } else {
            NSLog(@"NO ScanSegue");
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ScanSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[StudentDetailTVC class]]) {
            StudentDetailTVC *tvc = (StudentDetailTVC *)segue.destinationViewController;
            tvc.isScan = YES;
            tvc.photo = self.photo;
            self.photo = nil;
        }
    } else if ([segue.identifier isEqualToString:@"TypeSegue"]) {
        // TODO
    }
}

@end
