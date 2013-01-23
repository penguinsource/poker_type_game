//
//  firstScene.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "firstScene.h"


@implementation firstScene

-(id) init {
    if (self = [super init]){
        //bg_layer = [bgLayer node];
        //[self addChild:bg_layer z:0];
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        playLayer *m_layer = [playLayer node];
        backgroundLayer *bg_layer = [backgroundLayer node];
        
        //otherLayer *o_layer = [otherLayer node];
        
        // [m_layer setPosition:ccp(60, 0)];
        //
        [self addChild:bg_layer z:1];
        [self addChild:m_layer z:2];
    }
    return self;
}


@end
