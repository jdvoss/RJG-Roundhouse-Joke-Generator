//
//  RJGViewController.m
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import "RJGViewController.h"
#import "RJGJokeDataController.h"
#import "RJGJoke.h"
#import "RJGAppDelegate.h"

@interface RJGViewController ()

@end

@implementation RJGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"Chuck_Launch_Image.png"];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [imageView setImage:image];
    
    [self.view addSubview:imageView];
    
    self.byCategory = false;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.detailViewController = [[RJGDetailViewController alloc] init];
    self.detailViewController.delegate = self;
    
    self.datasource = [[RJGJokeDataController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Action Buttons
// ------------------------------
- (IBAction)sortByCategory:(UIBarButtonItem *)sender {
    self.byCategory = !self.byCategory;
    if (self.byCategory)
        self.sortStyleButton.title = @"Sort by Length";
    else
        self.sortStyleButton.title = @"Sort by Category";
    [self.tableView reloadData];
}

// Detail VC Delegate Methods
// ------------------------------
- (void) return:(RJGDetailViewController *)viewController {
    [self.detailViewController dismissViewControllerAnimated:YES completion:nil];
}

// Table Methods
// ----------------------------

- (int) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.byCategory)
        return self.datasource.categories.count;
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.byCategory) {
        if ([[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:section]] count] > 0)
            return ((NSArray*)[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:section]]).count + 1;
        return ((NSArray*)[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:section]]).count;
    }
    if (self.datasource.jokes.count > 0)
        return self.datasource.jokes.count + 1;
    return self.datasource.jokes.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.numberOfLines = 0;
    
    if (self.byCategory) {
        if (indexPath.row == [[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] count]) {
            NSString* category =  (NSString*)[[self.datasource.categories allObjects] objectAtIndex:indexPath.section];
            if ([category isEqualToString:@"Uncategorized"])
                cell.textLabel.text = @"Get more random jokes";
            else
                cell.textLabel.text = [NSString stringWithFormat:@"Get more %@ jokes",category];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return cell;
        }
        cell.textLabel.text = ((RJGJoke*)[[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]).joke;
    }
    else {
        if (indexPath.row == self.datasource.jokes.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"Get more random jokes"];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return cell;
        }
        cell.textLabel.text = [(RJGJoke*)[self.datasource.jokes objectAtIndex:indexPath.row] joke];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RJGJoke* joke;
    if (self.byCategory) {
        if (indexPath.row == [[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] count]) {
            NSString* type = (NSString*)[[self.datasource.categories allObjects] objectAtIndex:indexPath.section];
            NSString* url;
            if ([type isEqualToString:@"Uncategorized"])
                url = @"http://api.icndb.com/jokes/random/10/firstName=Chuck&lastName=Norris";
            else
                url = [NSString stringWithFormat:@"http://api.icndb.com/jokes/random/10?limitTo=[%@]", type];
            
            [(RJGAppDelegate*)[[UIApplication sharedApplication] delegate] performJokeDownload:url initial:NO withType:type];
            return;
        }
        joke =  ((RJGJoke*)[[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
    }
    else {
        if (self.datasource.jokes.count == indexPath.row) {
            NSString* type = (NSString*)[[self.datasource.categories allObjects] objectAtIndex:indexPath.section];
            NSString* url = [NSString stringWithFormat:@"http://api.icndb.com/jokes/random/10?limitTo=[%@]", type];
            [(RJGAppDelegate*)[[UIApplication sharedApplication] delegate] performJokeDownload:url initial:NO withType:type];
            return;
        }
        joke = (RJGJoke*)[self.datasource.jokes objectAtIndex:indexPath.row];
    }
    self.detailViewController.joke = joke.joke;
    self.detailViewController.categories = joke.categories;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.detailViewController.tableView reloadData];
    [self presentViewController:self.detailViewController animated:YES completion:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* string;
    if (self.byCategory) {
        if (indexPath.row == [[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] count])
            return 44.0;
        
        string = ((RJGJoke*)[[self.datasource.sortedCategories objectForKey:[[self.datasource.categories allObjects] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]).joke;
    }
    else {
        if (indexPath.row == self.datasource.jokes.count)
            return 44;
        string = [(RJGJoke*)[self.datasource.jokes objectAtIndex:indexPath.row] joke];
    }
    
    UIFont* font = [UIFont systemFontOfSize:18.0];
    CGSize base = CGSizeMake(280, MAXFLOAT);
    CGSize size = [string sizeWithFont:font constrainedToSize:base lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 20;;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.byCategory) {
        return [((NSString*)[[self.datasource.categories allObjects] objectAtIndex:section]) capitalizedString] ;
    }
    return nil;
}

// Alert View Method
// -----------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

// Helper Methods
// -----------------------

// Determines if the connection failed, or if the download is complete and the 2 seconds for viewing the image are over
// and will call the image remove helper accordingly
- (void) removeImageView:(NSString *)source {
    if ([source isKindOfClass:[NSString class]]) {
        NSLog(@"%@", source);
        
        if ([source isEqualToString:@"failToConnect"])
            [self removeImageViewHelper];
        if ([source isEqualToString:@"doneLoad"]) {
            if (self.timerUp) {
                [self removeImageViewHelper];
            }
        }
    }
    else {
        self.timerUp = YES;
        if (self.datasource.jokes.count > 0) {
            [self removeImageViewHelper];
        }
    }
}

// Removes the image view
- (void) removeImageViewHelper {
    for (UIView* view in self.view.subviews) {
        if ([view class] == [UIImageView class])
            [view removeFromSuperview];
    }
}

// Called by the app delegate if there was an error in downloading the jokes.
- (void) failedInternetConnection {
    [self removeImageView:@"failToConnect"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                    message:@"It appears you don't have an internet connection"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}
@end
