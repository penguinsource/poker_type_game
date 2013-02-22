//
//  pokerlib.h
//  mOneOnePoker
//
//  Created by Mihai on 2013-02-08.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "arrays.h"
#import "poker.h"
#import "Card.h"

@interface pokerlib : NSObject {
    NSInteger* deck;
    NSMutableArray* CardObjDeck;
}

@property (readwrite) NSInteger* deck;

-(void) init_deck;
-(NSInteger) findit: (NSInteger) key;
-(NSInteger) find_card: (NSInteger) rank :(NSInteger) suit :(NSInteger*) deck;
-(void) shuffle_deck: (NSInteger*) deck_a;
-(void) print_hand: (NSInteger*) hand :(NSInteger) n;
-(NSInteger) hand_rank: (short) val;
-(short) eval_5cards: (NSInteger)c1 :(NSInteger)c2 :(NSInteger)c3 :(NSInteger)c4 :(NSInteger) c5;
-(short) eval_5hand: (NSInteger*) hand;

-(NSInteger) getCardValue: (NSInteger) card_intValue;
-(NSString*) getCardSuit: (NSInteger) card_intValue;
-(NSMutableArray*) getObjDeck;

@end
