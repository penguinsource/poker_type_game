//
//  handCompare.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-02-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "handCompare.h"


@implementation handCompare

@synthesize pOneScore;
@synthesize pTwoScore;

pokerlib* pokerManager;
Player* pOne, *pTwo;
NSMutableArray* results;

-(void) dealloc {
    [super dealloc];
}

-(NSInteger) compareHands: (Player*) one :(Player*) two :(pokerlib*) pokerMngr {
    // save into global vars
    pOne = one;
    pTwo = two;
    pokerManager = pokerMngr;
    
    // get the hand ranks of the two players
    NSMutableArray* pOneRanks = [self getHandRanksOfPlayer:pOne];
    NSMutableArray* pTwoRanks = [self getHandRanksOfPlayer:pTwo];
    results = [NSMutableArray arrayWithCapacity:5];             // store the results of each line here (1 for p1 win, 2 for p2 win)
    
    // for each line, compare hands of each player
    for (NSInteger i = 0; i < 5; i++){
        NSInteger rankOne = [[pOneRanks objectAtIndex:i] integerValue];
        NSInteger rankTwo = [[pTwoRanks objectAtIndex:i] integerValue];
        //NSLog(@"line %d. player 1: %d, player 2: %d", i, [[pOneRanks objectAtIndex:i] integerValue], [[pTwoRanks objectAtIndex:i] integerValue]);
        if (rankOne > rankTwo){         // player two wins line 'i'
            //NSLog(@"line %d to two.", i);
            pOneScore++;
        } else if (rankOne < rankTwo){  // player one wins line 'i'
            //NSLog(@"line %d to one.", i);
            pTwoScore++;
        } else {                        // it's a tie (same rank). call the 'handleTieExcep' func.
            //NSLog(@"TIE %d", i);
            [self handleTieExcep: rankOne :i];
        }
        
        // save the winner
        if (pTwoScore > pOneScore){
            [results addObject:[NSNumber numberWithInt:1]];
        } else if (pTwoScore < pOneScore){
            [results addObject:[NSNumber numberWithInt:2]];
        } else {
            return 0;
        }
        // reset the score
        pOneScore = 0;
        pTwoScore = 0;
    }
    
    // the score between the players is stored in the global variables 'pOneScore' and 'pTwoScore'
    // return the winning player (1 for player one, 2 for player two, 0 for a TIE)
    return 0;
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - START OF TIE EXCEPTIONS (BELOW)
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-(void) handleTieExcep: (NSInteger) rankOfBoth :(NSInteger) lineArg {
    // get each players' lineup
    NSMutableArray* p1Lineup = [pOne getLineup];
    NSMutableArray* p2Lineup = [pTwo getLineup];
    // get the 2 lines that are to be compared
    NSMutableArray* arrayp1 = [p1Lineup objectAtIndex:lineArg]; // player 1's line
    NSMutableArray* arrayp2 = [p2Lineup objectAtIndex:lineArg]; // player 2's line
    NSMutableArray* exceptionInts = [NSMutableArray arrayWithCapacity:2];
    
    if (rankOfBoth == 9){   // high card                                // DONE
        NSLog(@"High Card");
        [self highCardTie:arrayp1 :arrayp2 :exceptionInts];
    } else if (rankOfBoth == 8) {   // one pair                         // DONE
        NSLog(@"One Pair Tie");
        [self OneTwoPairTie:lineArg pairType:1 inList:arrayp1 andList:arrayp2 exceptInt:0];
    } else if (rankOfBoth == 7) {   // two pair                         // DONE
        NSLog(@"Two Pair Tie");
        [self OneTwoPairTie:lineArg pairType:2 inList:arrayp1 andList:arrayp2 exceptInt:0];
    } else if (rankOfBoth == 6) {   // three of a kind                  // DONE
        NSLog(@"Three of a kind Tie");
        [self ThreeOfAKindTie:lineArg inList:arrayp1 andList:arrayp2];
    } else if (rankOfBoth == 5) {   // straight                         // DONE
        NSLog(@"Straight Tie");
        [self highCardTie:arrayp1 :arrayp2 :exceptionInts];
    } else if (rankOfBoth == 4) {   // flush                            // DONE
        NSLog(@"Flush Tie");
        [self highCardTie:arrayp1 :arrayp2 :exceptionInts];
    } else if (rankOfBoth == 3) {   // full house                       // DONE
        NSLog(@"Full House Tie");
        [self ThreeOfAKindTie:lineArg inList:arrayp1 andList:arrayp2];
    } else if (rankOfBoth == 2) {   // four of a kind                   // DONE
        NSLog(@"Four of a Kind Tie");
        [self fourOfAKindTie:lineArg inList:arrayp1 andList:arrayp2];
    } else if (rankOfBoth == 1) {   // straight flush                   // DONE
        NSLog(@"Straight Flush Tie");
        [self fourOfAKindTie:lineArg inList:arrayp1 andList:arrayp2];
    }
    
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - High Card Tie Exception
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void) highCardTie: (NSMutableArray*) linep1 :(NSMutableArray*) linep2 :(NSMutableArray*) exceptionArray {
    NSInteger maxp1 = [self maxIntOfArray:linep1 exceptInts:exceptionArray];
    NSInteger maxp2 = [self maxIntOfArray:linep2 exceptInts:exceptionArray];
    //NSLog(@"maxp1 is %d", maxp1);
    //NSLog(@"maxp2 is %d", maxp2);
    
    if (maxp1 > maxp2){
        NSLog(@"p1 wins ! High card is %d.", maxp1);
        pOneScore++;
    } else if (maxp2 > maxp1){
        NSLog(@"p2 wins ! High card is %d.", maxp2);
        pTwoScore++;
    } else if (maxp2 == maxp1){
        NSLog(@" !! ! ! ! ! ! TIE AGAIN ! High card is %d.", maxp1);
        [exceptionArray addObject:[NSNumber numberWithInt:maxp1]];
        [self highCardTie:linep1 :linep2 :exceptionArray];
    } else {
        // Nothing left to compare.. it's a tie !
    }
}

-(NSInteger) maxIntOfArray: (NSMutableArray*) arrayArg exceptInts:(NSMutableArray*) intsArg {
    // assign an integer (that is not the exception list) to maxInt, then start comparing it with
    // all the other values in the 'array'
    NSInteger maxInt;
    if ((intsArg) && ([intsArg count] > 0)){
        NSInteger n = 0;
        Card* temp = [arrayArg objectAtIndex:n];
        maxInt = [temp value];
        while ([self isInt:maxInt inArray:intsArg]){
            n++;
            temp = [arrayArg objectAtIndex:n];
            maxInt = [temp value];
        }
    } else {
        Card* temp = [arrayArg objectAtIndex:0];
        maxInt = [temp value];
    }
    
    //NSLog(@"the initial max int is %d", maxInt);
    
    
    for (NSInteger i = 0; i < [arrayArg count]; i++){
        Card* temp1 = [arrayArg objectAtIndex:i];
        if ([self isInt:[temp1 value] inArray:intsArg]){

        } else {
            if ([temp1 value] > maxInt){
                maxInt = [temp1 value];
            }
        }
    }
    
    return maxInt;
    
}

// this function checks if integer 'intArg' is found in the array 'arrayArg'
// 'arrayArg' contains NSNumber objects (NSIntegers in NSNumber objects)
-(bool) isInt:(NSInteger) intArg inArray:(NSMutableArray*) arrayArg {
    
    for (NSInteger i = 0; i < [arrayArg count]; i++){
        NSInteger exceptionInt = [[arrayArg objectAtIndex:i] integerValue];
        if (intArg == exceptionInt){
            return true;
        } else
            continue;
    }
    return false;
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - One / Two Pair Tie Exception
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// pair types: 1 (one pair) or 2 (two pair)
-(void) OneTwoPairTie: (NSInteger) lineArg pairType:(NSInteger) pairTypeArg
inList:(NSMutableArray*) arrayp1 andList:(NSMutableArray*) arrayp2 exceptInt:(NSInteger) exceptionInt {
    // get each players' lineup
    //NSMutableArray* p1Lineup = [pOne getLineup];
    //NSMutableArray* p2Lineup = [pTwo getLineup];
    // get the 2 lines that are to be compared
    //NSMutableArray* arrayp1 = [p1Lineup objectAtIndex:lineArg]; // player 1's line
    //NSMutableArray* arrayp2 = [p2Lineup objectAtIndex:lineArg]; // player 2's line
    
    // get value of the card that makes a pair / is found twice in a line
    NSInteger cardPlayer1 = [self findSameCardInList:arrayp1 exceptCard:exceptionInt];
    NSInteger cardPlayer2 = [self findSameCardInList:arrayp2 exceptCard:exceptionInt];
    
    NSLog(@"p1 one pair: %d", cardPlayer1);
    NSLog(@"p2 one pair: %d", cardPlayer2);
    
    // Resolving one-pair tie / adding score to the winning player:
    if (pairTypeArg == 1){  // (ONLY if this is a one-pair tie)
        if (cardPlayer1 > cardPlayer2){ // the bigger one-pair wins..
            pOneScore++;
        } else if (cardPlayer1 < cardPlayer2) {
            pTwoScore++;
        } else{
            //NSLog(@"ONE PAIR TIE BREAKER COMING UP line %d!", lineArg);
            NSMutableArray* exceptions = [NSMutableArray arrayWithCapacity:1];
            [exceptions addObject:[NSNumber numberWithInt:cardPlayer1]];
            [self highCardTie:arrayp1 :arrayp2 :exceptions];
        }
    }
    
    // ----------------- ONLY USED if looking for a two-pair:
    NSInteger card2Player1; // the value of the card that makes the second pair in player 1's line
    NSInteger card2Player2; // ...                                              in player 2's line
    
    if (pairTypeArg == 2){      // if looking for a two-pair.. keep searching
        card2Player1 = [self findSameCardInList:arrayp1 exceptCard:cardPlayer1];
        card2Player2 = [self findSameCardInList:arrayp2 exceptCard:cardPlayer2];
        
        NSLog(@"p1 two pair: %d", card2Player1);
        NSLog(@"p2 two pair: %d", card2Player2);
        
        // Resolving two-pair tie / adding score to the winning player:
        if ((cardPlayer1 > cardPlayer2) && (cardPlayer1 > card2Player2)) {   // cardPlayer1 is the biggest pair
            pOneScore++;
        } else if ((card2Player1 > cardPlayer2) && (card2Player1 > card2Player2)) { // cardPlayer1 is the biggest pair
            pOneScore++;
        } else if ((cardPlayer2 > cardPlayer1) && (cardPlayer2 > card2Player1)) {
            pTwoScore++;
        } else if ((card2Player2 > cardPlayer1) && (card2Player2 > card2Player1)) {
            pTwoScore++;
        } else {          // both pairs of each player are EQUAL.. so compare the sidecards of each line
            // the bigger pairs must be equal then..
            NSInteger p1Max = (cardPlayer1 > card2Player1) ? cardPlayer1 : card2Player1;
            NSInteger p2Max =  (cardPlayer2 > card2Player2) ? cardPlayer2 : card2Player2;
            NSLog(@"bigger pairs: %d and %d", p1Max, p2Max);

            NSInteger p1Min = (cardPlayer1 < card2Player1) ? cardPlayer1 : card2Player1; // obtain the smaller pairs
            NSInteger p2Min = (cardPlayer2 < card2Player2) ? cardPlayer2 : card2Player2;
            NSLog(@"smaller pairs: %d and %d", p1Min, p2Min);
            if (p1Min > p2Min) {                                                         // compare the smaller pairs
                pOneScore++;
            } else if (p2Min > p1Min){
                pTwoScore++;
            } else {            // compare the side card
                NSMutableArray* exceptions = [NSMutableArray arrayWithCapacity:2];
                [exceptions addObject:[NSNumber numberWithInt:cardPlayer1]];
                [exceptions addObject:[NSNumber numberWithInt:cardPlayer2]];
                [self highCardTie:arrayp1 :arrayp2 :exceptions];
            }
        }
        
    }
    
}

// finds the value of the integer/card that appears twice in a list 'list'
// if cardValue is defined, that value will be ignored, hence finding the second pair
// in the list (used for the two-pair exception)
-(NSInteger) findSameCardInList: (NSMutableArray*) list exceptCard:(NSInteger) cardValue {
    NSInteger card1;
    for (NSInteger i = 0; i < [list count]; i++){
        Card* temp1 = [list objectAtIndex:i];
        
        // check for the exception value not to take in consideration (to ignore)
        if ((cardValue) && (cardValue == [temp1 value]))
            continue;
        
        for (NSInteger j = 0; j < [list count]; j++){
            if (i != j){    // don't check the same indices (same value, obviously)
                Card* temp2 = [list objectAtIndex:j];
                if ([temp1 value] == [temp2 value]){
                    card1 = [temp1 value];
                }
            }
        }
    }
    return card1;
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - Three-of-a-kind and Full-House Tie Exceptions
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// if bool fullHArg is true, then this is not a three of a kind tie anymore, but a full house tie
-(void) ThreeOfAKindTie: (NSInteger) lineArg inList:(NSMutableArray*) arrayp1 andList:(NSMutableArray*) arrayp2 {  
    NSInteger cardPlayer1 = [self findSameCard3TimesInList:arrayp1];
    NSInteger cardPlayer2 = [self findSameCard3TimesInList:arrayp2];
    
    if (cardPlayer1 > cardPlayer2){
        //NSLog(@"3ofAKind, p1 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pOneScore++;
    } else if (cardPlayer2 > cardPlayer1){
        //NSLog(@"3ofAKind, p2 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pTwoScore++;
    }
    
}

//finds the integer/card that appears 3 times in the list
-(NSInteger) findSameCard3TimesInList: (NSMutableArray*) list {
    NSInteger count = 0;
    for (NSInteger i = 0; i < [list count]; i++){
        Card* temp1 = [list objectAtIndex:i];
        
        for (NSInteger j = 0; j < [list count]; j++){
            if (i != j){    // don't check the same indices (same value, obviously)
                Card* temp2 = [list objectAtIndex:j];
                if ([temp1 value] == [temp2 value]){
                    count++;
                }
                if (count == 2){
                    return [temp1 value];
                }
            }
        }
    }
    
    return -1; // error.. this should never be reached as the hand has already been identified as having 3
                // equivalent values
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - Four-of-a-kind Tie Exception
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

-(void) fourOfAKindTie: (NSInteger) lineArg inList:(NSMutableArray*) arrayp1 andList:(NSMutableArray*) arrayp2 {    
    NSInteger cardPlayer1 = [self findSameCard4TimesInList:arrayp1];
    NSInteger cardPlayer2 = [self findSameCard4TimesInList:arrayp2];
    
    if (cardPlayer1 > cardPlayer2){
        //NSLog(@"4ofAKind, p1 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pOneScore++;
    } else if (cardPlayer2 > cardPlayer1){
        //NSLog(@"4ofAKind, p2 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pTwoScore++;
    } else {
        // it's a tie..
    }
    
}

//finds the integer/card that appears 4 times in the list
-(NSInteger) findSameCard4TimesInList: (NSMutableArray*) list {
    NSInteger card1;
    NSInteger count = 0;
    for (NSInteger i = 0; i < [list count]; i++){
        Card* temp1 = [list objectAtIndex:i];
        
        for (NSInteger j = 0; j < [list count]; j++){
            if (i != j){    // don't check the same indices (same value, obviously)
                Card* temp2 = [list objectAtIndex:j];
                if ([temp1 value] == [temp2 value]){
                    count++;
                }
                if (count == 3){
                    return [temp1 value];
                }
            }
        }
    }
    return card1;
}

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - END OF TIE EXCEPTIONS (ABOVE)
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-(NSMutableArray *) getHandRanksOfPlayer: (Player*) playerArg{
    NSMutableArray* onelineup = [playerArg getLineup];
    NSMutableArray * playerLineRanks = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSInteger i = 0; i < 5; i++){
        NSInteger c1 = [[[onelineup objectAtIndex:i] objectAtIndex:0] codedValue];
        NSInteger c2 = [[[onelineup objectAtIndex:i] objectAtIndex:1] codedValue];
        NSInteger c3 = [[[onelineup objectAtIndex:i] objectAtIndex:2] codedValue];
        NSInteger c4 = [[[onelineup objectAtIndex:i] objectAtIndex:3] codedValue];
        NSInteger c5 = [[[onelineup objectAtIndex:i] objectAtIndex:4] codedValue];
        short cVal = [pokerManager eval_5cards:c1 :c2 :c3 :c4 :c5];
        [playerLineRanks insertObject:[NSNumber numberWithInt:[pokerManager hand_rank:cVal]] atIndex:i];
    }
    return [playerLineRanks autorelease];
}

-(void) reset {
    pOneScore = 0;
    pTwoScore = 0;
    
}

-(id) init {
    if (self = [super init]){
        pOneScore = 0;
        pTwoScore = 0;
    }
    return self;
}

@end
