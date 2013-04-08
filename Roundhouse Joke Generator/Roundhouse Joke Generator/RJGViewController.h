//
//  RJGViewController.h
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//
//  This class is the main view controller for the appication.  It has a grouped table view for displaying the jokes
//  RJCAppDelegate is responsible for downloading the jokes so once it is done, or after 2 seconds, the image of Chuck Norris
//  will be removed and the jokes will be displayed.  It has one action button for sorting the jokes by category.  it uses an
//  additional table cell fo getting more jokes.  Upon clicking a joke, a RJGDetailViewControler will be presneted.
//
//


#import <UIKit/UIKit.h>
#import "RJGDetailViewController.h"

@class RJGJokeDataController;


@interface RJGViewController : UIViewController <NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, RJGDetailViewControllerDelegateProtocol, UIAlertViewDelegate>

@property (nonatomic, retain) RJGJokeDataController* datasource;
@property (nonatomic, strong) RJGDetailViewController* detailViewController;
@property (nonatomic) BOOL byCategory;
@property (nonatomic) BOOL timerUp;

- (void) removeImageView:(NSString*) source;
- (void) failedInternetConnection;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortStyleButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)sortByCategory:(UIBarButtonItem *)sender;


@end
