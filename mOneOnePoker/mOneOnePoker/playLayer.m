//
//  playLayer.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "playLayer.h"
//#import "poker.h"

@implementation playLayer

Card* cardDrawn;
bool isGameOver = false;
handCompare* comparator;

-(void) dealloc {
    
    // release player objects
    [pOne release];
    [pTwo release];
    
    // releasing card deck array
    for (NSInteger c = 0; c < [cardDeck count]; c++){
        [[cardDeck objectAtIndex:c] release];
    }
    [cardDeck release];
    
    [comparator release];
    [pokerManager release];
    
    [super dealloc];
}

-(void) manualFillGame {
    
}

-(void) autoFillGame {
    gameState = @"fast";
    
    
    if (![pOne isDeckEmpty]){
        for (NSInteger i = 0; i < 5; i++){
            NSLog(@"deck one");
            [self drawACardPlayer:pOne withDeck: drawDeckOne andState:@"fast"];
            [pOne addCard: cardDrawn toLine:i];
            if ([pOne isDeckEmpty]) {
                isGameOver = true;
                //gameState = @"deckOneEmpty";
            }
        }
        for (NSInteger i = 0; i < 5; i++){
            NSLog(@"deck two");
            [self drawACardPlayer:pTwo withDeck: drawDeckTwo andState:@"fast"];
            [pTwo addCard: cardDrawn toLine:i];
            if ([pTwo isDeckEmpty]) {
                isGameOver = true;
            //gameState = @"deckOneEmpty";
            }
        }
    }
    // empty the highlightSprites array; no need to highlight any lines anymore
    [highlightSprites removeAllObjects];
    gameState = @"fast";
    // update the screen
    [self removeAllChildrenWithCleanup:YES];
    [self updateDisplay];
}

// ------------------------ Touches code below ------------------------

-(void) touchesCancelled:(NSSet *) touches withEvent:(UIEvent *)event {
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	//NSLog(@"Touches began!");
    NSArray *touchArray = [touches allObjects];
    UITouch *one = [touchArray objectAtIndex:0];
    CGPoint pointOne = [one locationInView:[one view]];
    pointTouched = [[CCDirector sharedDirector] convertToGL:pointOne];
    NSLog(@"x:%f, %f", pointTouched.x, pointTouched.y);
    
    //Card* bla = [pOne drawFromDeck];
    //[pOne addCard:bla toLine:1];
    //[pTwo addCard:bla toLine:2];
    
    // FOR TESTING !
    //[self autoFillGame];
    // [self manualFillGame];
        
    if (gameState == @"Player1sTurn"){        
        // check if the user (player one) clicked on the deck
        if (CGRectContainsPoint([drawDeckOne boundingBox], pointTouched)){
            // check if there are any cards left to be drawn in the deck
            //if ([pOne isDeckEmpty]){
            //    gameState = @"deckOneEmpty";
            //    isGameOver = true;
            //    NSLog(@"Empty Deck One");
            //}else{
                // if there are.. draw a card
                [self drawACardPlayer:pOne withDeck: drawDeckOne andState:@"oneSelecting"];
            //}
        }
    } else if (gameState == @"Player2sTurn"){
        // check if the user (player two) clicked on the deck
        if (CGRectContainsPoint([drawDeckTwo boundingBox], pointTouched)){
            // check if there are any cards left to be drawn in the deck
            /*if ([pTwo isDeckEmpty]){
                gameState = @"deckTwoEmpty";
                NSLog(@"Empty Deck Two");
            }else{*/
                // if there are.. draw a card
                [self drawACardPlayer:pTwo withDeck: drawDeckTwo andState:@"twoSelecting"];
            //}
        }
    } else if (gameState == @"oneSelecting"){
        // check if any of the highlighted sprites have been selected/touched
        for (NSInteger n = 0; n < [highlightSprites count]; n++){
            if (CGRectContainsPoint([[highlightSprites objectAtIndex:n] boundingBox], pointTouched)){
                
                // user selected a line onto which to apply the drawn card to
                Card *lastCardOfThisLine = [[highlightSprites objectAtIndex:n] userObject];
                // add the drawn card to the line selected
                [pOne addCard: cardDrawn toLine:[lastCardOfThisLine cardLine]];
                
                // empty the highlightSprites array; no need to highlight any lines anymore
                [highlightSprites removeAllObjects];
                
                // change of player turn
                gameState = @"Player2sTurn";
                
                // ...
                if ([pOne isDeckEmpty]){
                    gameState = @"Player2sTurn";     
                }
                
                // update the screen
                [self removeAllChildrenWithCleanup:YES];
                [self updateDisplay];
                

                
            }
        }
        // if the user clicks somewhere else on the screen.. ignore it..
    } else if (gameState == @"twoSelecting"){
        // check if any of the highlighted sprites have been selected/touched
        for (NSInteger n = 0; n < [highlightSprites count]; n++){
            if (CGRectContainsPoint([[highlightSprites objectAtIndex:n] boundingBox], pointTouched)){
                
                // user selected a line onto which to apply the drawn card to
                Card *lastCardOfThisLine = [[highlightSprites objectAtIndex:n] userObject];
                // add the drawn card to the line selected
                [pTwo addCard: cardDrawn toLine:[lastCardOfThisLine cardLine]];
                
                // empty the highlightSprites array; no need to highlight any lines anymore
                [highlightSprites removeAllObjects];
                
                // change of player turn
                gameState = @"Player1sTurn";
                
                if ([pTwo isDeckEmpty]){
                    gameState = @"fast";
                    isGameOver = true;
                }
                
                // update the screen
                [self removeAllChildrenWithCleanup:YES];
                [self updateDisplay];
                
            }
        }
        // if the user clicks somewhere else on the screen.. ignore it..
    } else if (gameState == @"deckOneEmpty"){
        NSLog(@"Empty Deck One");
        
    } else if (gameState == @"deckTwoEmpty"){
        NSLog(@"Empty Deck Two");
    }
    
    // if all the cards have been drawn.. the game is over; time to compare the hands of each line
    if (isGameOver){
        NSLog(@"game is over !");
        // 1 for player one winning; 2 for player two winning; 0 for tie
        NSInteger gameResult = [comparator compareHands:pOne :pTwo :pokerManager];
        
        if (gameResult == 0){
            NSLog(@"GAME OVER: Tie !");
        } else if (gameResult == 1){
            //NSLog(@"GAME OVER: Player one wins ! p1: %d, p2: %d", [pokerManager pOneScore], [pokerManager pTwoScore]);
        } else if (gameResult == 2){
           // NSLog(@"GAME OVER: Player two wins ! p1: %d, p2: %d", [pokerManager pOneScore], [pokerManager pTwoScore]);
        }
    }

}

-(void) drawACardPlayer: (Player*)player_a withDeck:(CCSprite*) deck_a andState: (NSString*) gameState_a {
    // player draws a card
    cardDrawn = [player_a drawFromDeck];
    
    // display the card on top of the deck card
    NSMutableString *cardFileName = [NSString stringWithFormat:@"%d%c.png",
                                     [cardDrawn value],
                                     [[cardDrawn suit] characterAtIndex:0]];
    CCSprite *cardDrawnSprite = [CCSprite spriteWithSpriteFrameName:cardFileName];
    [cardDrawnSprite setPosition:[deck_a position]];
    [cardDrawnSprite setScale:someScale];
    [self addChild:cardDrawnSprite z:150];
    
    // Display the card drawn and wait for user input on which line
    // to add the card to
    
    // Highlight the lines available.
    [self displayAvailableLines: player_a];
    gameState = gameState_a;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}	
// ------------------------ Touches code above ------------------------

// ------------------------ Display code below ------------------------
-(void) displayAvailableLines: (Player*) player_a {
    NSInteger currLevel = [player_a currentLevel];
    NSMutableArray *pLineup = [player_a getLineup];
    for (NSInteger i = 0; i < [pLineup count]; i++){
        if (currLevel == [[pLineup objectAtIndex:i] count]) {
            int lineCount = [[pLineup objectAtIndex:i] count];
            Card *cardEx = [[pLineup objectAtIndex:i] objectAtIndex:(lineCount-1)];
            //NSLog(@"number %d", [cardEx position]);
            CGPoint highlightPosition = CGPointMake([cardEx position].x + 4.0f, [cardEx position].y - 16.0f);
            
            CCSprite *highlightSprite = [CCSprite spriteWithFile:@"greenCard.png"];
            [highlightSprite setOpacity:180];
            [highlightSprite setPosition:highlightPosition];
            [highlightSprite setScale:0.3f];
            
            // save the card line which the sprite is on as the tag of the sprite
            // (just a workaround to save having to create other variables)
            // the card line is needed when the user is selecting where to place the card drawn
            
            [highlightSprite setUserObject:cardEx];
            [self addChild:highlightSprite z:150];
            
            // add the sprite to the highlightSprites array so it is available
            // when checking for user input on where to put the drawn card
            // (in the else if gameState = oneSelecting ..)
            [highlightSprites addObject:highlightSprite];
            // HIGHLIGHT THIS LINE !
            
            // HIGHLIGHT THIS LINE !
        }
    }
}

-(void) updateDisplay {
    
    //CGFloat cardWidth = 85.0f;
    CGFloat cardHeight = 120.f;
    CGFloat distanceBetweenCardLayers = winSize.width * (11.5f/100.0f);
    CGFloat distanceXBetweenCards = 4;
    CGFloat distanceYBetweenCards = 16;
    float tempX;
    float tempY;
    
    // player one display ------------------------------------------------------------------

    // update the current lineup/cards each player has on the table
    NSMutableArray *lineupOne = [pOne getLineup];
    for (NSInteger n = 0; n < 5; n++){
        tempX = winSize.width * (40/100.0f) + distanceBetweenCardLayers * n; // 62 pixels (iphone5)
        tempY = winSize.height * (70.0f/100.0f) + (cardHeight/2.0f); //
        
        for (NSInteger m = 0; m < [[lineupOne objectAtIndex:n] count]; m++){
            tempX = tempX + distanceXBetweenCards;
            tempY = tempY - distanceYBetweenCards;
            Card *cardCurr = [[lineupOne objectAtIndex:n] objectAtIndex:m];
            NSMutableString *cardFileName = [NSString stringWithFormat:@"%d%c.png",
                                             [cardCurr value],
                                             [[cardCurr suit] characterAtIndex:0]];
            
            CCSprite *exSprite = [CCSprite spriteWithSpriteFrameName:cardFileName];
            //CCSprite *exSprite = [CCSprite spriteWithFile:@"Grad1.png"];
            //NSLog(@"WIDTH is: %f, %f", winSize.width, winSize.height);
            //NSLog(@"bounding box is: %f, %f", [exSprite boundingBox].size.width, [exSprite boundingBox].size.height);
            //[allSprites addObject:exSprite];
            [exSprite setPosition:ccp(tempX,tempY)];
            [exSprite setScale:someScale];
            [self addChild:exSprite z:150];
            
            // save the position and line where the card / card's sprite is displayed.
            [cardCurr setPosition:ccp(tempX,tempY)];
            [cardCurr setCardLine:n];
        }
    }
    
    // draw player 1's deck
    drawDeckOne = [CCSprite spriteWithSpriteFrameName:@"drawCardPeng.png"];
    [drawDeckOne setScale:someScale];
    [drawDeckOne setPosition:ccp(winSize.width * (20.0f/100.0f), winSize.height * (65.0f/100.0f) + (cardHeight/2.0f))];
    [self addChild:drawDeckOne z:150];
    
    // draw p1 label
    CCLabelTTF *one = [CCLabelTTF labelWithString:@"pOne" fontName:@"Arial" fontSize:15.0f];
    static const ccColor3B bla = {139,0,0};
    [one setColor:bla];
    [one setPosition:ccp(tempX + 60, 245)];
    [self addChild:one z:150];    
    
    
    // player two display ------------------------------------------------------------------

    // update the current lineup/cards each player has on the table
    NSMutableArray *lineupTwo = [pTwo getLineup];
    for (NSInteger n = 0; n < 5; n++){
        tempX = winSize.width * (40/100.0f) + distanceBetweenCardLayers * n; // 62 pixels (iphone5)
        tempY = winSize.height * (18.0f/100.0f) + cardHeight/2; //
        for (NSInteger m = 0; m < [[lineupTwo objectAtIndex:n] count]; m++){
            tempX = tempX + distanceXBetweenCards;
            tempY = tempY - distanceYBetweenCards;
            Card *cardCurr = [[lineupTwo objectAtIndex:n] objectAtIndex:m];
            NSMutableString *cardFileName = [NSString stringWithFormat:@"%d%c.png",
                                             [cardCurr value],
                                             [[cardCurr suit] characterAtIndex:0]];
            
            CCSprite *exSprite = [CCSprite spriteWithSpriteFrameName:cardFileName];
            [exSprite setPosition:ccp(tempX,tempY)];
            [exSprite setScale:someScale];
            [self addChild:exSprite z:150];
            
            // save the position and line where the card / card's sprite is displayed.
            [cardCurr setPosition:ccp(tempX,tempY)];
            [cardCurr setCardLine:n];
        }
    }
    
    // draw player 2's deck
    drawDeckTwo = [CCSprite spriteWithSpriteFrameName:@"drawCardPeng.png"];
    [drawDeckTwo setScale:someScale];
    [drawDeckTwo setPosition:ccp(winSize.width * (20.0f/100.0f), winSize.height * (13.0f/100.0f) + (cardHeight/2.0f))];
    [self addChild:drawDeckTwo z:150];
    
    CCLabelTTF *two = [CCLabelTTF labelWithString:@"pTwo" fontName:@"Arial" fontSize:15.0f];
    static const ccColor3B blah = {139,0,0};
    [two setColor:blah];
    [two setPosition:ccp(tempX + 60, 65)];
    [self addChild:two z:150];
    
    // other display ------------------------------------------------------------------
}

// ------------------------ Display code above ------------------------

-(void) update:(ccTime) deltaTime {

}

-(void) splitDeck: (NSMutableArray*) anArray {
    
    // keeps track of which line to add cards to
    // there are 5 lines per lineup (one lineup per player)
    NSInteger lineIndex = 0;
    
    // add the first 5 'cards' of the deck to player 1's (pOne) lineup
    for (NSInteger n = 0; n < 5; n++){
        [pOne addCard:[cardDeck objectAtIndex:n] toLine:lineIndex];
        lineIndex++;
    }
    
    lineIndex = 0;
    // add the next 5 'cards' of the deck to player 2's (pTwo) lineup
    for (NSInteger n = 5; n < 10; n++){
        [pTwo addCard:[cardDeck objectAtIndex:n] toLine:lineIndex];
        lineIndex++;
    }
    
    // add the next 20 'cards' of the deck to player 1's deck
    for (NSInteger n = 10; n < 30; n++){
        [pOne addCardtoDeck:[cardDeck objectAtIndex:n]];
    }
    
    // add the next 20 'cards' of the deck to player 2's deck
    for (NSInteger n = 30; n < 50; n++){
        [pTwo addCardtoDeck:[cardDeck objectAtIndex:n]];
    }
    
    // NOTE! The last 2 cards are not used but should be revealed to the players somehow..
    // they have indices 50 and 51
    
}

-(void) shuffleDeck: (NSMutableArray*) anArray {
    /* anArray is a NSMutableArray with some objects */
    NSUInteger count = [anArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [anArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
}

-(void) printDeck {
    //NSLog(@"Printing deck.. ");
    for (NSInteger c = 0; c < [cardDeck count]; c++){
        Card *bla = [cardDeck objectAtIndex:c];
        NSLog(@"PRINT ! value: %d", [bla value]);
    }
}

-(void) initSprites {
    CCSpriteBatchNode *spriteBatchNode;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards3.plist"];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"cards3.png"];
    
    // set the scale of the sprites
    someScale = 0.5f;
    
    // init sprite arrays
    highlightSprites = [[NSMutableArray alloc] initWithCapacity:5];
    allSprites = [NSMutableArray arrayWithCapacity:5];
}

-(void) initDeck {
    // get instance of the card array
    cardDeck = [pokerManager getObjDeck];
    //[self printDeck];
    [self shuffleDeck:cardDeck];    // shuffle the deck
    [self splitDeck:cardDeck];      // split the deck
}

-(void) setupGame {
    winSize = [[CCDirector sharedDirector] winSize];
    
    // set game state
    gameState = @"Player1sTurn";
    
    pokerManager = [[pokerlib alloc] init];
    [pokerManager init_deck];
    
    // initiate a handCompare object
    comparator = [[handCompare alloc] init];
    
    // create player instances
    pOne = [[Player alloc] init];
    pTwo = [[Player alloc] init];
    
    // init the deck
    [self initDeck];
    // init sprites
    [self initSprites];

    // clear and update screen
    [self removeAllChildrenWithCleanup:YES];
    [self updateDisplay];
}

-(id) init {
    if (self = [super init]){
        [self setupGame];                   // init game variables, deck, etc
        [self setIsTouchEnabled:TRUE];      // make layer touch enabled
        [self scheduleUpdate];              // schedule update
    }
    return self;
}

@end
