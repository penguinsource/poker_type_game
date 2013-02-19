//
//  handCompare.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-02-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "handCompare.h"


@implementation handCompare

@synthesize handsOfPlayers;

NSInteger numberOfPlayers = 2;

-(void) dealloc {
    [super dealloc];
}

-(NSInteger) handleTieExcep: (NSInteger) rankp1 :(NSInteger) rankp2 {
    if (rankp1 == 9){
        // high card
    } else if (rankp1 == 8) {
        // 
    } else if (rankp1 == 7) {
        //
    } else if (rankp1 == 6) {
        //
    } else if (rankp1 == 5) {
        //
    } else if (rankp1 == 4) {
        //
    } else if (rankp1 == 3) {
        //
    } else if (rankp1 == 2) {
        //
    } else if (rankp1 == 1) {
        //
    }
    
    return 0;
}

-(NSInteger) compareHands: (Player*) one :(Player*) two :(pokerlib*) pokerMngr {
    NSInteger pOneScore, pTwoScore = 0;
    NSMutableArray* pOneRanks = [self getHandRanksOfPlayer:one :pokerMngr];
    NSMutableArray* pTwoRanks = [self getHandRanksOfPlayer:two :pokerMngr];
    for (NSInteger i = 0; i < 5; i++){
        NSInteger rankOne = [[pOneRanks objectAtIndex:i] integerValue];
        NSInteger rankTwo = [[pTwoRanks objectAtIndex:i] integerValue];
        NSLog(@"line %d. player 1: %d, player 2: %d", i, [[pOneRanks objectAtIndex:i] integerValue], [[pTwoRanks objectAtIndex:i] integerValue]);
        if (rankOne > rankTwo){
            NSLog(@"line %d to two.", i);
            pOneScore++;
        } else if (rankOne < rankTwo){
            NSLog(@"line %d to one.", i);
            pTwoScore++;
        } else {
            NSLog(@"TIE %d", i);
            [self handleTieExcep: rankOne :rankTwo];
        }
    }
    
    if (pTwoScore > pOneScore){
        return 2;
    }else return 1;
}

-(NSInteger) sameHandRankException: (Player*) p1 :(Player*) p2 {
        
    return 1;
}

-(NSMutableArray *) getHandRanksOfPlayer: (Player*) playerArg :(pokerlib*) pokerMngr {
    NSMutableArray* onelineup = [playerArg getLineup];
    NSMutableArray * playerLineRanks = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSInteger i = 0; i < 5; i++){
        NSInteger c1 = [[[onelineup objectAtIndex:i] objectAtIndex:0] codedValue];
        NSInteger c2 = [[[onelineup objectAtIndex:i] objectAtIndex:1] codedValue];
        NSInteger c3 = [[[onelineup objectAtIndex:i] objectAtIndex:2] codedValue];
        NSInteger c4 = [[[onelineup objectAtIndex:i] objectAtIndex:3] codedValue];
        NSInteger c5 = [[[onelineup objectAtIndex:i] objectAtIndex:4] codedValue];
        short cVal = [pokerMngr eval_5cards:c1 :c2 :c3 :c4 :c5];
        [playerLineRanks insertObject:[NSNumber numberWithInt:[pokerMngr hand_rank:cVal]] atIndex:i];
    }
    return [playerLineRanks autorelease];
}

-(id) init {
    if (self = [super init]){
        
    }
    return self;
}

@end
