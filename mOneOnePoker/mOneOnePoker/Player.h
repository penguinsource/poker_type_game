//
//  Player.h
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Player : NSObject {
    NSMutableArray *lineup;         // lineup = the cards the player knows about / on table
    NSMutableArray *deck;
    NSInteger currLevel;         // lowest line count of all lines
}

-(void) addCardtoDeck: (Card*) card_a;
-(void) addCard: (Card*) card_a toLine: (NSInteger) line_a;
-(void) testFunc;
-(NSMutableArray*) getLineup;
-(Card*) drawFromDeck;
-(NSInteger) currentLevel;
-(BOOL) isDeckEmpty;
@end
