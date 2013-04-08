//
//  RJGJoke.m
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import "RJGJoke.h"

@implementation RJGJoke

- (id) initWithJoke:(NSString*)joke andCategories:(NSArray*) categories andID:(int)id {
    if (self = [super init]) {
        self.joke = joke;
        self.categories = [[NSArray alloc] initWithArray:categories];
        self.id = id;
    }
    
    return self;
}

- (NSString*) description {
    return [[NSString alloc] initWithFormat:@"<%@ : %d>", self.joke, self.id];
}
@end
