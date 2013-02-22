//
//  handCompare.h
//  mOneOnePoker
//
//  Created by Mihai on 2013-02-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "pokerlib.h"

@interface handCompare : NSObject {
    NSInteger pOneScore, pTwoScore;     // holds the score for each player
}

@property (readonly) NSInteger pOneScore;
@property (readonly) NSInteger pTwoScore;

-(NSInteger) compareHands: (Player*) one :(Player*) two :(pokerlib*) pokerMngr;

-(NSInteger) findSameCardInList: (NSMutableArray*) list exceptCard:(NSInteger) cardValue;

// tie handling functions

-(void) OneTwoPairTie: (NSInteger) lineArg pairType:(NSInteger) pairTypeArg
               inList:(NSMutableArray*) arrayp1 andList:(NSMutableArray*) arrayp2 exceptInt:(NSInteger) exceptionInt;
-(void) fourOfAKindTie: (NSInteger) lineArg inList:(NSMutableArray*) arrayp1 andList:(NSMutableArray*) arrayp2;
@end
