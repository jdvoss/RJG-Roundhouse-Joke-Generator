//
//  RJGJoke.h
//  Roundhouse Joke Generator
//
//  Created by Jamison Voss on 3/23/13.
//  Copyright (c) 2013 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJGJoke : NSObject

@property (nonatomic, retain) NSString* joke;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic) int id;

- (id) initWithJoke:(NSString*)joke andCategories:(NSArray*)categories andID:(int)id;

@end
