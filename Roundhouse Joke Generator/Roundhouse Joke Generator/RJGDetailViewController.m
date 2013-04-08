//
//  RJGDetailViewController.m
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/28/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import "RJGDetailViewController.h"
#import <Twitter/Twitter.h>

@interface RJGDetailViewController ()

@end

@implementation RJGDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.categories = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateAccountInfo];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Table Methods
// ----------------------------
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.categories.count;
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Joke";
    }
    else {
        return @"Category";
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    if (indexPath.section == 0) {
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = self.joke;
    }
    else if (self.categories.count > 0) {
        cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* string = self.joke;
        UIFont* font = [UIFont systemFontOfSize:18.0];
        CGSize base = CGSizeMake(280, MAXFLOAT);
        CGSize size = [string sizeWithFont:font constrainedToSize:base lineBreakMode:NSLineBreakByWordWrapping];
        return size.height + 20;;
    }
    return 44;
}

// Action Sheet methods
// ----------------------------
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Post"])
        [self createShareSheet:YES];
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Tweet"]) {
        if (self.joke.length > 140) {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"It apears this joke has too much Chuck Norris for twitter to handle!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK" , nil];
            [self.alertView show];
        }
        else
            [self createShareSheet:NO];
        
    }
}

// Alert View Method
// ------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

// Action Methods
// ------------------------
- (IBAction)done:(UIBarButtonItem *)sender {
    [self.delegate return:self];
}

- (IBAction)getActions:(UIBarButtonItem *)sender {
    if (self.sharable) {
        [self.actionSheet showInView:self.view];
    }
    else {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"You can share a joke if you enable a Facebook or Twitter account from you device Settings "
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
        [self.alertView show];
    }
}

// Helper Methods
// ------------------------------

/*
 This method is used to determine the available social  media accounts and include them in the action sheet.
 This method is a bit overkill because the iOS Simulator will always return true for the method isAvailableForServiceType
 So it checks the ammount of each account and if there is atleast one it will add it.
 */
- (void) updateAccountInfo {
    ACAccountStore* store  = [[ACAccountStore alloc] init];
    ACAccountType* twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountType* facebookAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSArray* twitterAccounts = [store accountsWithAccountType:twitterAccountType];
    NSArray* facebookAccounts = [store accountsWithAccountType:facebookAccountType];
    if (twitterAccounts.count > 0 || facebookAccounts.count > 0)
        self.sharable = YES;
    else {
        self.sharable = NO;
        return;
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    if (facebookAccounts.count > 0)
        [self.actionSheet addButtonWithTitle:@"Post"];
    if (twitterAccounts.count > 0)
        [self.actionSheet addButtonWithTitle:@"Tweet"];
    
    [self.actionSheet addButtonWithTitle:@"Cancel"];
    [self.actionSheet setCancelButtonIndex:self.actionSheet.numberOfButtons -1];
    
}

/*
 This method creates the sharing sheet (SLComposeViewController).  This one is also a little clunky because there is a wier error
 with the facebook completion handler that causes it to behave differently form the twitter one.
 */
- (void) createShareSheet:(BOOL) isFacebook {
    SLComposeViewController* shareVC;
    
    if (isFacebook) {
        self.reportString = 0;
        shareVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    }
    else {
        self.reportString = 2;
        shareVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }
    
    
    shareVC.completionHandler = ^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                self.reportString++;
                break;
            default:
                break;
        }
        if (!isFacebook) {
            [self dismissViewControllerAnimated:NO completion: ^ {
                NSString* response;
                switch (self.reportString) {
                    case TwitterCancel:
                        response = @"Chuck Norris could smell your fear";
                        break;
                    case TwitterSucces:
                        response = @"Hope that twitter can handle what you just unleashed on them";
                        break;
                    default:
                        break;
                }
                self.alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:response
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK" , nil];
                [self.alertView show];
            }];
        }
        else {
            NSString* response;
            switch (self.reportString) {
                case FaceBookCancel:
                    response = @"Wise choice, Chuck would not be pleased";
                    break;
                case FaceBookSucces:
                    response = @"Your post has been ROUNDHOUSE kicked to Facebook";
                    break;
                default:
                    break;
            }
            self.alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:response
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK" , nil];
            [self.alertView show];
            
        }
    };
    
    NSString* shareString = self.joke;
    if (!isFacebook && self.categories.count > 0) {
        NSString* hashtag = (NSString*)[self.categories objectAtIndex:0];
        shareString = [shareString stringByAppendingFormat:@" #%@", hashtag];
    }
    
    [shareVC setInitialText:shareString];
    
    
    [self presentViewController:shareVC animated:YES completion:nil];
}

@end
