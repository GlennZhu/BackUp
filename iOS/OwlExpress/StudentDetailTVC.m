//
//  StudentDetailTVC.m
//  OwlExpress
//
//  Created by Beck Chen on 1/31/15.
//  Copyright (c) 2015 HackRice. All rights reserved.
//

#import "StudentDetailTVC.h"
#import "AFNetworking.h"
#import "AWSCore.h"
#import "S3.h"

@interface StudentDetailTVC () <UIAlertViewDelegate>

@property (nonatomic) UIActivityIndicatorView *activityView;
@property (nonatomic) NSArray *results;
@property (nonatomic) NSUInteger selectedRowIndex;
@property (nonatomic) NSString *photoUrl;
@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation StudentDetailTVC

NSString *const TEXT_QUERY_PREFIX = @"http://owlexpress.azurewebsites.net/api/RicePeople";
NSString *const PHOTO_QUERY_PREFIX = @"http://owlexpress.azurewebsites.net/api/RicePeoplePhoto";
NSString *const EMAIL_PREFIX = @"http://owlexpress.azurewebsites.net/api/SendEmail";
NSString *const BUCKET_NAME = @"owlexpress2";
NSString *const BUCKET_PREFIX = @"https://s3-us-west-2.amazonaws.com/owlexpress2/";

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) _manager = [AFHTTPRequestOperationManager manager];
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Start activity indicator
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center = self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    if (self.isScan) {
        [self uploadPhoto];
    } else {
        [self queryWithText];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Best Matches";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.results) {
        self.selectedRowIndex = indexPath.row;
        NSDictionary *item = self.results[self.selectedRowIndex];
        
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [item[@"full_name"][@"firstname"] capitalizedString],
                              [item[@"full_name"][@"lastname"] capitalizedString]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm sending email to:"
                                                        message:fullName
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.results) {
        return [self.results count];
    } else {
        return 0;
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        [self sendEmail:(self.results[self.selectedRowIndex])[@"email"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Network

- (void)queryWithText {
    NSDictionary *params = @{@"firstname": self.firstName, @"lastname": self.lastName, @"college": self.college};
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.manager GET:TEXT_QUERY_PREFIX parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), responseObject);
         self.results = responseObject;
         [self.activityView stopAnimating];
         [self.activityView removeFromSuperview];
         [self.tableView reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"[%@ %@] error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
     }];
}

- (void)queryWithPhoto {
    NSDictionary *params = @{@"imageUrl": self.photoUrl};
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.manager GET:PHOTO_QUERY_PREFIX parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), responseObject);
        self.results = responseObject;
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[%@ %@] error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    }];
}

- (void)sendEmail:(NSString *)userEmail {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userEmail, @"email", @"", @"imageUrl", nil];
    if (self.isScan) {
        [params setObject:self.photoUrl forKey:@"imageUrl"];
    }
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.manager GET:EMAIL_PREFIX parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[%@ %@] error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentDetailTVC" forIndexPath:indexPath];
    
    if (self.results) {
        NSUInteger index = indexPath.row;
        NSDictionary *item = self.results[index];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [item[@"full_name"][@"firstname"] capitalizedString],
                               [item[@"full_name"][@"lastname"] capitalizedString]];
        cell.detailTextLabel.text = item[@"email"];
    }
    
    return cell;
}

- (void)uploadPhoto {
    // save photo to file
    NSArray *array = [[[NSDate date] description] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *dateDesc = [NSString stringWithFormat:@"%@-%@", array[0], array[1]];
    NSString *filename = [NSString stringWithFormat:@"%@.jpeg", dateDesc];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    NSLog(@"%@", filePath);
    [UIImageJPEGRepresentation(self.photo, 1.0) writeToFile:filePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    // upload photo
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = fileURL;
    uploadRequest.bucket = BUCKET_NAME;
    uploadRequest.key = filename;
    uploadRequest.contentType = @"image/jpeg";
    __weak StudentDetailTVC *weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        if (task.error) {
            NSLog(@"%@", task.error.description);
        } else {
            self.photoUrl = [[BUCKET_PREFIX stringByAppendingString:filename] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", self.photoUrl);
            [weakSelf queryWithPhoto];
        }
        return nil;
    }];
}

#pragma mark - Helper

//- (NSString *)base64EncodedPhoto {
//    NSString *encoded;
//    
//    if (self.isScan) {
//        NSData *imageData = UIImageJPEGRepresentation(self.photo, 1.0);
//        encoded = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
//    }
//    
//    return encoded;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
