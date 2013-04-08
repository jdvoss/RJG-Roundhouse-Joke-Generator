//
//  RJGJokeDataController.m
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import "RJGJokeDataController.h"
#import "RJGJoke.h"

@implementation RJGJokeDataController

- (id) init {
    if (self = [super init]) {
        self.jokes = [[NSMutableArray alloc] init];
        self.categories = [[NSMutableSet alloc] init];
        [self.categories addObject:@"Uncategorized"];
        self.sortedCategories = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
 take an array of jokes and creates the Joke objects for the mutable array of jokes.  It also keeps track of the categories and adds new one to the
 categories set.
 */
- (void) populateDataSource:(NSArray *)receivedData {
    for (NSDictionary* dict in receivedData) {
        NSString* jokeString = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"joke"]];
        jokeString = [self decodeHTML:jokeString];
        
        RJGJoke* joke = [[RJGJoke alloc] initWithJoke:jokeString
                                        andCategories:[dict objectForKey:@"categories"]
                                                andID:[(NSNumber*)[dict objectForKey:@"id"] intValue]];
        [self.jokes addObject:joke];
        
        if (joke.categories.count > 0) {
            for (NSString*  string in joke.categories) {
                [self.categories addObject:string];
            }
        }
    }
    [self insertionSort];
    [self sortByCategories];
}

/*
 escapes characters so they appear normal in text
 */
- (NSString*) decodeHTML:(NSString*) string {
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return string;
}
/*
 Using insertion sort for the list of jokes because we either have a small (50) list of items or a mostly sorted list of items.
 */
- (void) insertionSort {
    NSMutableArray* tempStore = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.jokes.count; i++) {
        int j = 0;
        int length = ((RJGJoke*)[self.jokes objectAtIndex:i]).joke.length;
        while (j < i && length > ((RJGJoke*)[tempStore objectAtIndex:j]).joke.length) {
            j++;
        }
        [tempStore insertObject:[self.jokes objectAtIndex:i] atIndex:j];
    }
    self.jokes = nil;
    self.jokes = [[NSMutableArray alloc] initWithArray:tempStore];
}

/*
 Adds a mutable array to a dictionary indexed by the category names and by an uncategorized key.
 Each joke is then added to its respective category
 */
- (void) sortByCategories {
    for (NSString* string in self.categories) {
        [self.sortedCategories setObject:[[NSMutableArray alloc] init] forKey:string];
    }
    [self.sortedCategories setObject:[[NSMutableArray alloc] init] forKey:@"Uncategorized"];
    for (RJGJoke* joke in self.jokes) {
        if (joke.categories.count > 0) {
            for (NSString* s in joke.categories)
                [[self.sortedCategories objectForKey:s] addObject:joke];
        }
        else {
            [[self.sortedCategories objectForKey:@"Uncategorized"] addObject:joke];
        }
    }
}

/*
 Used for adding more jokes to the already populated list.
 The only difference from the populate datasource method is a check for the joke already stored in the jokes array.
 */
- (void) addJokesToDatasource:(NSArray *)moreJokes withType:(NSString *)type {
    for (NSDictionary* dict in moreJokes) {
        NSString* jokeString = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"joke"]];
        jokeString = [self decodeHTML:jokeString];
        
        RJGJoke* joke = [[RJGJoke alloc] initWithJoke:jokeString
                                        andCategories:[dict objectForKey:@"categories"]
                                                andID:[(NSNumber*)[dict objectForKey:@"id"] intValue]];
        
        if (![self haveJoke:joke.id :joke.joke])
            [self.jokes addObject:joke];
        
        if (joke.categories.count > 0) {
            for (NSString*  string in joke.categories) {
                [self.categories addObject:string];
            }
        }
    }
    [self insertionSort];
    [self sortByCategories];
}

/*
 Sees if a joke is already held by its ID or string value
 */
- (BOOL) haveJoke:(int) id :(NSString*) string{
    for (RJGJoke* joke in self.jokes) {
        if (joke.id == id || [joke.joke isEqualToString:string])
            return YES;
    }
    return NO;
}
@end
