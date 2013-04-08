//
//  RJGAppDelegate.m
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import "RJGAppDelegate.h"
#import "RJGViewController.h"
#import "RJGJokeDataController.h"

@implementation RJGAppDelegate

NSString *const FBSessionStateChangedNotification = @"com.jamisonvoss.Roundhouse-Joke-Generator:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RJGViewController alloc] initWithNibName:@"RJGViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    [self performJokeDownload:@"http://api.icndb.com/jokes/random/50?firstName=Chuck&lastName=Norris" initial:YES withType:@""];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self.viewController selector:@selector(removeImageView:) userInfo:nil repeats:NO];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.viewController.detailViewController updateAccountInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.viewController = nil;
    self.window = nil;
    self.receivedData = nil;
    self.downloadType = nil;
}


- (void) performJokeDownload:(NSString*) url initial:(BOOL) initialDownload withType:(NSString*) type {
    self.originalDownload = initialDownload;
    self.downloadType = type;
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.receivedData = [[NSMutableData alloc] init];
    } else {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    [self.viewController failedInternetConnection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.receivedData
                          
                          options:kNilOptions
                          error:&error];
    NSArray* array = [json objectForKey:@"value"];
    if (self.originalDownload) {
        [self.viewController.datasource populateDataSource:array];
        [self.viewController.tableView reloadData];
        [self.viewController removeImageView:@"doneLoad"];
    }
    else {
        [self.viewController.datasource addJokesToDatasource:array withType:self.downloadType];
        [self.viewController.tableView reloadData];
    }
    
}

@end
