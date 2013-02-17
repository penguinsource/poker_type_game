//
//  Card.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//
//

#import "Card.h"

@implementation Card

@synthesize value;
@synthesize codedValue;

@synthesize position;
@synthesize cardLine;

-(void) dealloc {
    [suit release];
    [super dealloc];
}

-(id) init {
    if (self = [super init]){
        suit = @"none";
        value = 5;
        cardLine = -1;
        position = CGPointMake(0, 0);
    }
    return self;
}

-(void) setSuit:(NSInteger) suit_a {
    if (suit_a == 0) {
        suit = @"spades";
    } else if (suit_a == 1){
        suit = @"hearts";
    } else if (suit_a == 2){
        suit = @"diamonds";
    } else if (suit_a == 3){
        suit = @"clubs";
    } else {
        suit = @"error";
    }
}

-(NSString*) suit {
    return suit;
}

/*
-(id) initWithSuit: (NSInteger)suit_a andValue: (NSInteger) value_a {
    if (self = [super init]){
        if (suit_a == 0) {
            suit = @"spades";
        } else if (suit_a == 1){
            suit = @"hearts";
        } else if (suit_a == 2){
            suit = @"diamonds";
        } else if (suit_a == 3){
            suit = @"clubs";
        }
        value = value_a;
    }
    return self;
}
*/


@end
