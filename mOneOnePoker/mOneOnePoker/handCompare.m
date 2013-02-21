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
@synthesize pOneScore;
@synthesize pTwoScore;

pokerlib* pokerManager;
Player* pOne, *pTwo;

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
    
    // for each line, compare hands of each player
    for (NSInteger i = 0; i < 5; i++){
        NSInteger rankOne = [[pOneRanks objectAtIndex:i] integerValue];
        NSInteger rankTwo = [[pTwoRanks objectAtIndex:i] integerValue];
        NSLog(@"line %d. player 1: %d, player 2: %d", i, [[pOneRanks objectAtIndex:i] integerValue], [[pTwoRanks objectAtIndex:i] integerValue]);
        if (rankOne > rankTwo){         // player two wins line 'i'
            //NSLog(@"line %d to two.", i);
            pOneScore++;
        } else if (rankOne < rankTwo){  // player one wins line 'i'
            //NSLog(@"line %d to one.", i);
            pTwoScore++;
        } else {                        // it's a tie (same rank). call the 'handleTieExcep' func.
            NSLog(@"TIE %d", i);
            [self handleTieExcep: rankOne :i];
        }
    }
    
    // the score between the players is stored in the global variables 'pOneScore' and 'pTwoScore'
    // return the winning player (1 for player one, 2 for player two, 0 for a TIE)
    if (pTwoScore > pOneScore){
        return 2;
    } else if (pTwoScore < pOneScore){
        return 1;
    } else {
        return 0;
    }
}

-(NSInteger) handleTieExcep: (NSInteger) rankOfBoth :(NSInteger) lineArg {

    
    if (rankOfBoth == 9){   // high card
        [self checkHighCard:lineArg];
    } else if (rankOfBoth == 8) {
        NSLog(@"One Pair Tie");
        [self pairTieException:lineArg pairType:1];
    } else if (rankOfBoth == 7) {
        NSLog(@"Two Pair Tie");
        [self pairTieException:lineArg pairType:2];
    } else if (rankOfBoth == 6) {
        NSLog(@"Three of a kind Tie");
        [self threeOfAKindException:lineArg];
    } else if (rankOfBoth == 5) {
        // in the case of a straight.. check the highest card !
        NSLog(@"Straight Tie");
        [self checkHighCard:lineArg];
    } else if (rankOfBoth == 4) {
        [self checkHighCard:lineArg];
    } else if (rankOfBoth == 3) {

    } else if (rankOfBoth == 2) {
        //
    } else if (rankOfBoth == 1) {
        //
    }
    
    return 0;
}

// --------------------------------------------------------------------------------------
/* --------- exception handling ties between one and two-pair hands BELOW ---------    */

// pair types: 1 (one pair) or 2 (two pair)
-(void) pairTieException: (NSInteger) lineArg pairType:(NSInteger) pairTypeArg {
    // get each players' lineup
    NSMutableArray* p1Lineup = [pOne getLineup];
    NSMutableArray* p2Lineup = [pTwo getLineup];
    // get the 2 lines that are to be compared
    NSMutableArray* arrayp1 = [p1Lineup objectAtIndex:lineArg]; // player 1's line
    NSMutableArray* arrayp2 = [p2Lineup objectAtIndex:lineArg]; // player 2's line
    
    // get value of the card that makes a pair / is found twice in a line
    NSInteger cardPlayer1 = [self findSameCardInList:arrayp1 exceptCard:0];
    NSInteger cardPlayer2 = [self findSameCardInList:arrayp2 exceptCard:0];
    
    NSLog(@"1 one pair: %d", cardPlayer1);
    NSLog(@"1 one pair: %d", cardPlayer2);
    
    // Resolving one-pair tie / adding score to the winning player:
    if (pairTypeArg == 1){  // (ONLY if this is a one-pair tie)
        if (cardPlayer1 > cardPlayer2){ // the bigger one-pair wins..
            pOneScore++;
        } else if (cardPlayer1 < cardPlayer2) {
            pTwoScore++;
        } else{
            // ANOTHER TIE.. go by SUIT
        }
    }
    
    // ----------------- ONLY USED if looking for a two-pair:
    NSInteger card2Player1; // the value of the card that makes the second pair in player 1's line
    NSInteger card2Player2; // ...                                              in player 2's line
    
    if (pairTypeArg == 2){      // if looking for a two-pair.. keep searching
        card2Player1 = [self findSameCardInList:arrayp1 exceptCard:cardPlayer1];
        card2Player2 = [self findSameCardInList:arrayp2 exceptCard:cardPlayer2];
        
        NSLog(@"1 two pair: %d", card2Player1);
        NSLog(@"1 two pair: %d", card2Player2);
        
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
            // .. comparing sidecards.. 
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

// --------------------------------------------------------------------------------------
/* --------- exception handling ties between three-of-a-kind hands BELOW ---------    */

-(void) threeOfAKindException: (NSInteger) lineArg {
    // get each players' lineup
    NSMutableArray* p1Lineup = [pOne getLineup];
    NSMutableArray* p2Lineup = [pTwo getLineup];
    // get the 2 lines that are to be compared
    NSMutableArray* arrayp1 = [p1Lineup objectAtIndex:lineArg]; // player 1's line
    NSMutableArray* arrayp2 = [p2Lineup objectAtIndex:lineArg]; // player 2's line
    
    NSInteger cardPlayer1 = [self findSameCard3TimesInList:arrayp1];
    NSInteger cardPlayer2 = [self findSameCard3TimesInList:arrayp2];
    
    if (cardPlayer1 > cardPlayer2){
        NSLog(@"3ofAKind, p1 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pOneScore++;
    } else if (cardPlayer2 > cardPlayer1){
        NSLog(@"3ofAKind, p2 wins ! p1: %d, p2: %d", cardPlayer1, cardPlayer2);
        pTwoScore++;
    } else {            // cardPlayer1 and cardPlayer2 are equal.. so check the other cards (high cards)
        NSInteger highCardP1 = [self getHighCard:arrayp1 exceptCard:cardPlayer1];
        NSInteger highCardP2 = [self getHighCard:arrayp2 exceptCard:cardPlayer2];
        if (highCardP1 > highCardP2){
            NSLog(@"3ofAKind, p1 wins !");
            pOneScore++;
        } else if (highCardP2 > highCardP1){
            NSLog(@"3ofAKind, p2 wins !");
            pTwoScore++;
        } else {
            NSLog(@"both high cards are tied..");
        }
    }
    
}

//finds the integer/card that appears 3 times in the list
-(NSInteger) findSameCard3TimesInList: (NSMutableArray*) list {
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
                if (count == 2){
                    card1 = [temp1 value];
                    break;
                }
            }
        }
    }
    return card1;
}

// returns the value of the card with the max value in a mutable array.
-(NSInteger) getHighCard: (NSMutableArray*) lineArrayArg exceptCard: (NSInteger) cardValue {
    NSInteger n = 0;
    Card* maxVal = [lineArrayArg objectAtIndex:n];
    while ([maxVal value] == cardValue){
        n++;
        maxVal = [lineArrayArg objectAtIndex:n];
    }
    
    for (NSInteger i = 0; i < [lineArrayArg count]; i++){
        Card* temp2 = [lineArrayArg objectAtIndex:i];
        if ([temp2 value] != cardValue){
            if (temp2 > maxVal){
                maxVal = temp2;
            }
        }
    }
    return [maxVal value];
}

// ------------------------------------------------------------------------------------------------
// check for the highest card in line with index 'lineArg' of each player and compare/evaluate them
-(void) checkHighCard: (NSInteger) lineArg {
    NSMutableArray* p1Lineup = [pOne getLineup];
    NSMutableArray* p2Lineup = [pTwo getLineup];
    NSInteger max1 = [self maxCardValueOfLine:[p1Lineup objectAtIndex:lineArg]];
    NSInteger max2 = [self maxCardValueOfLine:[p2Lineup objectAtIndex:lineArg]];
    if (max1 > max2){
        // increase player one's score
        pOneScore++;
        NSLog(@"pOne wins on line %d with max %d", lineArg, max1);
    } else if (max1 < max2) {
        // increase player two's score
        pTwoScore++;
        NSLog(@"pTwo wins on line %d with max %d", lineArg, max2);
    } else {
        NSLog(@"TIE AGAIN on line %d with max %d", lineArg, max1);
        // ADD CODE.. check next high card ?
    }
}

// returns the value of the card with the max value in a mutable array.
-(NSInteger) maxCardValueOfLine: (NSMutableArray*) lineArrayArg {
    NSInteger maxCodedCard = [[lineArrayArg objectAtIndex:0] codedValue];
    
    for (NSInteger i = 0; i < [lineArrayArg count]; i++){
        // NSLog(@"args: %d", [pokerManager getCardValue:[[lineArrayArg objectAtIndex:i] codedValue]]);
        if ([pokerManager getCardValue:maxCodedCard :1] < [pokerManager getCardValue:[[lineArrayArg objectAtIndex:i] codedValue] :1]){
            maxCodedCard = [[lineArrayArg objectAtIndex:i] codedValue];
        }
    }
    return [pokerManager getCardValue:maxCodedCard :1];
}

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
