//
//  backgroundLayer.m
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-22.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "backgroundLayer.h"


@implementation backgroundLayer

-(id) init {
    if (self = [super init]){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bg = [CCSprite spriteWithFile:@"bg1smaller.png"];
        [bg setPosition:ccp(winSize.width/2, winSize.height/2)];
        //NSLog(@"YOOO: %f, %f", [bg contentSize].width, [bg contentSize].height);
        [self addChild:bg z:1];
    }
    return self;
}
@end
