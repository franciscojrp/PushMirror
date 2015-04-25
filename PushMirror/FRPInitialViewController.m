//
//  FRPInitialViewController.m
//  PushMirror
//
//  Created by Fran on 25/04/15.
//  Copyright (c) 2015 franciscojrp. All rights reserved.
//

#import "FRPInitialViewController.h"
#import <Parse/Parse.h>
#import "FRPLoginViewController.h"
#import "FRPSignUpViewController.h"

@interface FRPInitialViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mainButton;

- (IBAction)mainButtonPressed:(id)sender;

@end

@implementation FRPInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([PFUser currentUser]) { // No user logged in
        [self.mainButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (IBAction)mainButtonPressed:(id)sender {
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[FRPLoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields: PFLogInFieldsFacebook | PFLogInFieldsDefault];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[FRPSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        // Present the log in view controller
        [self presentViewController:logInViewController animated:NO completion:NULL];
    } else {
        //TODO: Start/stop: store a setting in the server to send pushes or not
    }
}

#pragma mark - PFLogInViewControllerDelegate methods

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - PFSignUpViewControllerDelegate methods

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
