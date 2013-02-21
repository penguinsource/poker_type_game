//
//  Player.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//
//

#import "Player.h"

@implementation Player

-(void) dealloc {
    
    // release all 'card' objects from each 'line' ( 5 lines in total for each lineup ) (1)
    // release all mutable 'line' arrays                                                (2)
    
    for (NSInteger d = 0; d < [lineup count]; d++){
        for (NSInteger c = 0; c < [[lineup objectAtIndex:d] count]; c++){
            [[[lineup objectAtIndex:d] objectAtIndex:c] release];                    // (1)
        }
        
        [[lineup objectAtIndex:d] release];                                          // (2)
    }
    
    // releasing the 'resultLineup' array
    [resultLineup release];
    // releasing player 'lineup' array
    [lineup release];
    [deck release];
    
    [super dealloc];
}

// add card 'card_a' to line 'line_a'
-(void) addCard: (Card*) card_a toLine: (NSInteger) line_a {
    // add assert here that line is < 6 and > 0
    [[lineup objectAtIndex:line_a] addObject:card_a];
    
    // get the lowest level (lowest line count of any)
    currLevel = [[lineup objectAtIndex:0] count];
    for (NSInteger i = 0; i < [lineup count]; i++){
        if (currLevel > [[lineup objectAtIndex:i] count]){
            currLevel = [[lineup objectAtIndex:i] count];
        }
    }
}

-(BOOL) isDeckEmpty {
    //NSLog(@"deck count is %d", [deck count]);
    if ([deck count] < 1)
        return true;
    return false;
}

-(void) addCardtoDeck: (Card*) card_a {
    [deck addObject:card_a];
}

-(NSMutableArray*) getLineup {
    return lineup;
}

-(NSInteger) currentLevel {
    return currLevel;
}

// draw from the deck; remove the object drawn from the deck
-(Card*) drawFromDeck {
    //[self printDeck];
    Card* cardDrawn = [deck objectAtIndex:0];
    //NSLog(@"card drawn has a value of %d and suit %@", [cardDrawn value], [cardDrawn suit]);
    [deck removeObjectAtIndex:0];
    //NSLog(@"AFTER: card drawn has a value of %d and suit %@", [cardDrawn value], [cardDrawn suit]);
    //[self printDeck];
    
    return cardDrawn;
}

-(void) printDeck {
    for (NSInteger i = 0; i < [deck count]; i++){
        Card* card = [deck objectAtIndex:i];
        NSLog(@"deck: %d", [card value] );
    }
}

-(id) init {
    if (self = [super init]){
        deck = [[NSMutableArray alloc] initWithCapacity:20];
        lineup = [[NSMutableArray alloc] initWithCapacity:5];
        resultLineup = [[NSMutableArray alloc] initWithCapacity:5];
        currLevel = 1;
        for (NSInteger n = 0; n < 5; n++){
            NSMutableArray *line = [[NSMutableArray alloc] initWithCapacity:5];
            [lineup addObject:line];
        }
        
    }
    return self;
}

// just for test purposes
-(void) testFunc {
    /*
    Card* v = [[lineup objectAtIndex:0] objectAtIndex:0];
    Card* two = [[Card alloc] init];
    [two setValue:15];
    
    [[lineup objectAtIndex:0] addObject:two];
    Card* check = [[lineup objectAtIndex:0] objectAtIndex:1];
    
    NSLog(@"test function: %d", [v value]);
    NSLog(@"test function: %d", [check value]);
     */
    NSLog(@"deck count is %d", [deck count]);
}
// just for test purposes (above)


@end
