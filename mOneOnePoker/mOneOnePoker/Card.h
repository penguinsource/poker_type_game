//
//  Card.h
//  mOneOnePoker
//
//  Created by Mihai on 2013-01-20.
//
//

#import <Foundation/Foundation.h>

@interface Card : NSObject {
    NSString *suit;
    NSInteger value;
    CGPoint position;
    NSInteger cardLine;
}

@property (readwrite) NSInteger value;
@property (readwrite) CGPoint position;
@property (readwrite) NSInteger cardLine;

-(void) setSuit:(NSInteger) suit_a;
-(NSString*) suit;
@end
