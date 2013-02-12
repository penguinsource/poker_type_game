//
//  playLayer.h
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"
#import "Player.h"
#import "pokerlib.h"

/*
 
 each lineup contains 5 mutable arrays ( the 5 lines of each player )
 
 */

@interface playLayer : CCLayer {
    CGSize winSize;
    CCSprite *bg;
    NSMutableArray *cardDeck;
    Player *pOne;
    Player *pTwo;
    CGPoint pointTouched;
    CCSprite *drawDeckOne; // CAN JUST MAKE THIS AN ARRAY of 2 sprites
    CCSprite *drawDeckTwo; // instead of having 2
    float someScale;
    NSString* gameState;
    NSMutableArray *allSprites;
    
    NSMutableArray *highlightSprites;
    
    pokerlib *pokerManager;
}

@end
