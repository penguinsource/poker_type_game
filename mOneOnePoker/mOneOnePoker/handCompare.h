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
}

@property (readonly) NSInteger* handsOfPlayers;

-(NSInteger) compareHands: (Player*) one :(Player*) two :(pokerlib*) pokerMngr;


@end
