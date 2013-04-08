//
//  RJGDetailViewController.h
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/28/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//
//  This class is used to control the joke details (the joke and its categories)
//  It has two action for returning to the list and sharing the joke
//  If the user hassn't set uu a Facebook or Twitter account it will prompt them to do so.
//  It gives feedback to the user once the Joke has been posted.
//  It has a delegate for helping it close.

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

typedef enum ReportString {
    FaceBookCancel = 0,
    FaceBookSucces,
    TwitterCancel,
    TwitterSucces,
} ReportString;


@interface RJGDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL sharable;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSString* joke;
@property (nonatomic, retain) id delegate;

@property (nonatomic, assign) ReportString reportString;

@property (nonatomic, retain) UIActionSheet* actionSheet;
@property (nonatomic, retain) UIAlertView* alertView;

- (void) updateAccountInfo;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)getActions:(UIBarButtonItem *)sender;


@end

@protocol RJGDetailViewControllerDelegateProtocol <NSObject>
- (void) return:(RJGDetailViewController*)viewController;
@end

