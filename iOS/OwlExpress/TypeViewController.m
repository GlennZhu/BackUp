//
//  TypeViewController.m
//  OwlExpress
//
//  Created by Beck Chen on 1/31/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "TypeViewController.h"
#import "StudentDetailTVC.h"

@interface TypeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UIPickerView *college;
@property (nonatomic) NSArray *pickerData;

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize picker
    self.pickerData = @[@"baker", @"wiess", @"duncan", @"brown", @"lovett", @"mcmurtry", @"martel", @"jones", @"hanszen", @"will rice", @"sid rich"];
    self.college.dataSource = self;
    self.college.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Manual Input";
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"TypeQuerySegue"]) {
        if ([self.firstName.text isEqualToString:@""] ||
            [self.lastName.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please fill all fields."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"No TypeQuerySegue");
            return NO;
        }
    }
    // NSLog(@"%@, %@, %@", self.firstName.text, self.lastName.text, self.college.text);
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TypeQuerySegue"]) {
        if ([segue.destinationViewController isKindOfClass:[StudentDetailTVC class]]) {
            StudentDetailTVC *tvc = (StudentDetailTVC *)segue.destinationViewController;
            tvc.isScan = NO;
            tvc.firstName = self.firstName.text;
            tvc.lastName = self.lastName.text;
            tvc.college = self.pickerData[[self.college selectedRowInComponent:0]];
            NSLog(@"%@ %@ %@", tvc.firstName, tvc.lastName, tvc.college);
        }
    }
}

#pragma mark - Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.pickerData[row];
}

@end
