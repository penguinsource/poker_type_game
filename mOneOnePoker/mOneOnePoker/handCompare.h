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
    NSInteger* handsOfPlayers;
    NSInteger pOneScore, pTwoScore;     // holds the score for each player
}

@property (readonly) NSInteger* handsOfPlayers;
@property (readonly) NSInteger pOneScore;
@property (readonly) NSInteger pTwoScore;

-(NSInteger) compareHands: (Player*) one :(Player*) two :(pokerlib*) pokerMngr;
-(void) checkHighCard: (NSInteger) lineArg;
-(void) pairTieException: (NSInteger) lineArg pairType:(NSInteger) pairTypeArg;

-(NSInteger) findSameCardInList: (NSMutableArray*) list exceptCard:(NSInteger) cardValue;
// three of a kind:
-(NSInteger) getHighCard: (NSMutableArray*) lineArrayArg exceptCard: (NSInteger) cardValue;


@end
