//
//  PublicEyeViewController.m
//  TrafficBuddy
//
//  Created by Chandrasekhar Pasumarthi on 18/05/16.
//  Copyright © 2016 Testing. All rights reserved.
//

#import "PublicEyeViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"

@interface PublicEyeViewController ()

@end

@implementation PublicEyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize Account Kit
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAuthorizationCode];
    }
    
    // view controller for resuming login
    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.categories.delegate = self;
    self.categories.dataSource = self;
    self.comments.delegate = self;
    self.categoryTypes = [[NSArray alloc] initWithObjects:@"Traffic Voilation",@"Report Traffic Accident",@"Refusal by Taxi/Auto/Public Bus",@"Over charging by Taxi/Auto/Public Bus", @"Misbehaviour by Taxi/Auto/Public Bus", @"Other", nil];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.categories.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"in viewWillAppear");
    
    
    if (_pendingLoginViewController != nil) {
        // resume pending login (if any)
        [self _prepareLoginViewController:_pendingLoginViewController];
        [self presentViewController:_pendingLoginViewController
                           animated:animated
                         completion:NULL];
        _pendingLoginViewController = nil;
    }
}

- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state{
    NSLog(@"Testing: ");
}


- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
{
    loginViewController.delegate = self;
    // Optionally, you may use the Advanced UI Manager or set a theme to customize the UI.
    //    loginViewController.advancedUIManager = _advancedUIManager;
    //    loginViewController.theme = [Themes bicycleTheme];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_categoryTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_categoryTypes objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"In didSelectRowAtIndexPath %d", indexPath.row);
    UITableViewCell *cell = [self.categoryTypes objectAtIndex:indexPath.row];
    [_selectedCategory setTitle:cell forState:UIControlStateNormal];
    self.categories.hidden = YES;
    NSLog(@"In didSelectRowAtIndexPath %@", cell);
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectCategory:(id)sender {
    
    if(self.categories.hidden == YES){
        NSLog(@"making invisible");
        self.categories.hidden = NO;
    }else{
        NSLog(@"making visible");
        self.categories.hidden = YES;
    }
}
- (IBAction)upLoadImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"My Title"
                                 message:@"Select you Choice"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Camera"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSLog(@"Clicked camera option");
                             //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             //[self presentViewController:picker animated:YES completion:NULL];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Gallery"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Clicked gallery option");
                                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                 [self presentViewController:picker animated:YES completion:NULL];
//                                 [self dismissViewControllerAnimated:YES completion:^{
//                                    //nothing
//                                 }];
                                 
                             }];
    
    
    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    NSLog(@"leaving upLoadImage");
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    

}

- (IBAction)submitIncident:(id)sender {
    
    NSLog(@"Submitted successfully!! %@", _selectedImage.debugDescription);
    [Utils displayAlert:@"Image Upload success" displayText:@"Congratulations!!"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
//    NSString *inputState = [[NSUUID UUID] UUIDString];
//    AKFPhoneNumber *phone = [[AKFPhoneNumber alloc] initWithCountryCode:@"IN" phoneNumber:@""];
//    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:phone
//                                                                                                            state:inputState];
//    //viewController.enableSendToFacebook = YES; // defaults to NO
//    [self _prepareLoginViewController:viewController]; // see below
//    [self presentViewController:viewController animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _selectedImage= info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"uploaded image name is %@", _selectedImage);
    //[Utils displayAlert:@"Image Upload success" displayText:@"Congratulations!!"];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-60), self.view.frame.size.width, self.view.frame.size.height);
//    self.selectedCategory.hidden = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //textView.frame = CGRectMake(textView.frame.origin.x, (70), textView.frame.size.width, textView.frame.size.height);
    [UIView commitAnimations];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+60), self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //textView.frame = CGRectMake(textView.frame.origin.x, (334), textView.frame.size.width, textView.frame.size.height);
    [UIView commitAnimations];
//    self.selectedCategory.hidden = NO;
    
}

@end