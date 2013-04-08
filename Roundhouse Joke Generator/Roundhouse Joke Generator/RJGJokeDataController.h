//
//  RJGJokeDataController.h
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//
//  This is the datasoure for the main table of jokes.  After a joke download, it will take
//  an array of jokes and create RJGJoke objects to store in the mutable array.  It also sorts the
//  right away by both length and then category.
//
//

#import <Foundation/Foundation.h>

@interface RJGJokeDataController : NSObject

@property (nonatomic, retain) NSMutableArray* jokes;
@property (nonatomic, retain) NSMutableSet* categories;
@property (nonatomic, retain) NSMutableDictionary* sortedCategories;

- (void) populateDataSource:(NSArray*) receivedData;
- (void) addJokesToDatasource:(NSArray*)moreJokes withType:(NSString*)type;
@end
