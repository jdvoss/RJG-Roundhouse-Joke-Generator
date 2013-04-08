//
//  RJGAppDelegate.h
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJGViewController;

@interface RJGAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate>

extern NSString *const FBSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RJGViewController *viewController;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic) BOOL originalDownload;
@property (nonatomic, retain) NSString* downloadType;

- (void) performJokeDownload:(NSString*) url initial:(BOOL) initialDownload withType:(NSString*) type;

@end
