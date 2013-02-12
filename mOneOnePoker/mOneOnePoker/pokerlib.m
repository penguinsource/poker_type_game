//
//  pokerlib.m
//  mOneOnePoker
//
// Poker hand evaluator
// C version by Kevin L. Suffecool
// suffecool@bigfoot.com
//
// This modified Objective-C version.. by Mihai Oprescu
// mihaioprescu5@yahoo.com

#import "pokerlib.h"


@implementation pokerlib

@synthesize deck;

void    srand48();
double  drand48();

-(void) dealloc {
    
    //[deck release];
    free(deck);
    [super dealloc];
}

// perform a binary search on a pre-sorted array
//
-(NSInteger) findit: (NSInteger) key {
    NSInteger low = 0, high = 4887, mid;
    
    while ( low <= high )
    {
        mid = (high+low) >> 1;      // divide by two
        if ( key < products[mid] )
            high = mid - 1;
        else if ( key > products[mid] )
            low = mid + 1;
        else
            return( mid );
    }
    fprintf( stderr, "ERROR:  no match found; key = %d\n", key );
    return( -1 );
}

//
//   This routine initializes the deck.  A deck of cards is
//   simply an integer array of length 52 (no jokers).  This
//   array is populated with each card, using the following
//   scheme:
//
//   An integer is made up of four bytes.  The high-order
//   bytes are used to hold the rank bit pattern, whereas
//   the low-order bytes hold the suit/rank/prime value
//   of the card.
//
//   +--------+--------+--------+--------+
//   |xxxbbbbb|bbbbbbbb|cdhsrrrr|xxpppppp|
//   +--------+--------+--------+--------+
//
//   p = prime number of rank (deuce=2,trey=3,four=5,five=7,...,ace=41)
//   r = rank of card (deuce=0,trey=1,four=2,five=3,...,ace=12)
//   cdhs = suit of card
//   b = bit turned on depending on rank of card
//
 
-(void) init_deck {
    //NSInteger hey = 5;
    //NSLog(@"SIZE IS : %ld", sizeof(NSInteger));
    
    NSInteger i, j, n = 0;
    NSInteger suit = 0x8000;
    //NSInteger suit = 2048;
    //NSInteger primes[] = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 };
    NSLog(@"BLAH: %d ", suit);
    for ( i = 0; i < 4; i++, suit >>= 1 ){
        for ( j = 0; j < 13; j++, n++ ) {
            deck[n] = primes[j] | (j << 8) | suit | (1 << (16+j));
            //NSLog(@"card: %d, %d, SUIT: %d, primes: %d, %d", i, deck[n], suit, primes[j], j);
            NSLog(@"index %d, %d, %d, %d, %d", n, primes[j], j, suit, deck[n]);
        }
    }
    
    srand ( (unsigned int) time (0) );
    [self shuffle_deckTwo:deck :52];
    NSInteger hand[5];
    for (NSInteger i = 0; i < 5; i++){
        hand[i] = deck[i];
    }
    short ii = [self eval_5hand:hand];
    NSInteger jj = [self hand_rank:ii];
    NSLog(@"ii is %hd, jj is %d", ii, jj);
    [self print_hand:hand :5];
    //[self cardValue: deck[0]];
    //[self getCardSuit:deck[0]];
    //[self getCardSuit:deck[12]];
    //[self getCardSuit:deck[51]];
    //[self cardValue: deck[1]];
    //[self cardValue: deck[2]];
    //NSLog(@"IT IS: %d", [self find_card:0 :0x4000 :deck]);

}

//  This routine will search a deck for a specific card
//  (specified by rank/suit), and return the INDEX giving
//  the position of the found card.  If it is not found,
//  then it returns -1
//
-(NSInteger) find_card: (NSInteger)rank :(NSInteger)suit :(NSInteger*)deck_a {
	NSInteger i, c;
    
	for ( i = 0; i < 52; i++ )
	{
		c = deck_a[i];
		if ( (c & suit)  &&  (RANK(c) == rank) )
			return( i );
	}
	return( -1 );
}

-(void) shuffle_deckTwo: (NSInteger*) array :(size_t) n {
    if (n > 1){
        size_t i;
        for (i = 0; i < (n-1); i++){
            size_t j = i + rand() / (RAND_MAX / (n-i) + 1);
            int t = array[j];
            array[j] = array[i];
            array[i] = t;
        }
    }
}

//
//  This routine takes a deck and randomly mixes up
//  the order of the cards.
//
-(void) shuffle_deck: (NSInteger*) deck_a {
    NSInteger i, n, temp[52];
    
    for ( i = 0; i < 52; i++ )
        temp[i] = deck_a[i];
    
    for ( i = 0; i < 52; i++ )
    {
        do {
            n = (NSInteger)(51.9999999 * drand48());
        } while ( temp[n] == 0 );
        deck_a[i] = temp[n];
        temp[n] = 0;
    }
}

-(void) print_hand: (NSInteger*) hand :(NSInteger) n {
    NSInteger i, r;
    char suit;
    static char *rank = "23456789TJQKA";
    
    for ( i = 0; i < n; i++ )
    {
        r = (*hand >> 8) & 0xF;
        if ( *hand & 0x8000 )
            suit = 'c';
        else if ( *hand & 0x4000 )
            suit = 'd';
        else if ( *hand & 0x2000 )
            suit = 'h';
        else
            suit = 's';
        
        printf( "BAAAAAA: %c%c \n", rank[r], suit );
        hand++;
    }
}

-(NSInteger) hand_rank: (short) val {
    if (val > 6185) return(HIGH_CARD);        // 1277 high card
    if (val > 3325) return(ONE_PAIR);         // 2860 one pair
    if (val > 2467) return(TWO_PAIR);         //  858 two pair
    if (val > 1609) return(THREE_OF_A_KIND);  //  858 three-kind
    if (val > 1599) return(STRAIGHT);         //   10 straights
    if (val > 322)  return(FLUSH);            // 1277 flushes
    if (val > 166)  return(FULL_HOUSE);       //  156 full house
    if (val > 10)   return(FOUR_OF_A_KIND);   //  156 four-kind
    return(STRAIGHT_FLUSH);                   //   10 straight-flushes
}

-(short) eval_5cards: (NSInteger)c1 :(NSInteger)c2 :(NSInteger)c3 :(NSInteger)c4 :(NSInteger) c5 {
    NSInteger q;
    short s;
    
    q = (c1|c2|c3|c4|c5) >> 16;
    
    //check for Flushes and StraightFlushes
    
    if ( c1 & c2 & c3 & c4 & c5 & 0xF000 )
        return( flushes[q] );
    
    //check for Straights and HighCard hands
    
    s = unique5[q];
    if ( s )  return ( s );
    
    // let's do it the hard way
    
    q = (c1&0xFF) * (c2&0xFF) * (c3&0xFF) * (c4&0xFF) * (c5&0xFF);
    // q = findit( q );
    q = [self findit:q];
    
    return( values[q] );
}

-(short) eval_5hand: (NSInteger*) hand {
    NSInteger c1, c2, c3, c4, c5;
    
    c1 = *hand++;
    c2 = *hand++;
    c3 = *hand++;
    c4 = *hand++;
    c5 = *hand;
    
    //return( eval_5cards(c1,c2,c3,c4,c5) );
    return ( [self eval_5cards:c1 :c2 :c3 :c4 :c5]);
}

// returns the cards value (1,2,3,4..13)
// argument: integer value of the card held in the 'deck'
-(NSInteger) getCardValue: (NSInteger) card_intValue {
    NSInteger check = 63;
    NSInteger diff = check & card_intValue;
    NSInteger cardValue = -1;
    
    // 2 = Two, 1 = Ace, 13 = King, 12 = Queen, 11 = Jacks, 10 = Ten, etc..
    if (diff == 2){
        cardValue = 2;
    } else if (diff == 3){
        cardValue = 3;
    } else if (diff == 5){
        cardValue = 4;
    } else if (diff == 7){
        cardValue = 5;
    } else if (diff == 11){
        cardValue = 6;
    } else if (diff == 13){
        cardValue = 7;
    } else if (diff == 17){
        cardValue = 8;
    } else if (diff == 19){
        cardValue = 9;
    } else if (diff == 23){
        cardValue = 10;
    } else if (diff == 29){
        cardValue = 11;
    } else if (diff == 31){
        cardValue = 12;
    } else if (diff == 37){
        cardValue = 13;
    } else if (diff == 41){
        cardValue = 1;
    }
    
    NSLog(@"Card Value: %d", diff);
    
    // add assert that cardValue is not -1.
    return cardValue;
}

// returns the cards suit (Spades, Diamonds, Clubs or Hearts)
// argument: integer value of the card held in the 'deck'
-(NSString*) getCardSuit: (NSInteger) card_intValue {
    NSInteger check = 0xF000;
    NSInteger diff = check & card_intValue;
    diff = diff >> 12;
    NSString* suitType;
    if (diff == 8){
        suitType = @"clubs";
    } else if (diff == 4){
        suitType = @"diamonds";
    } else if (diff == 2){
        suitType = @"hearts";
    } else if (diff == 1){
        suitType = @"spades";
    }
    NSLog(@"Suit type: %@", suitType);
    return suitType;
}

// init
-(id) init {
    if (self = [super init]){
        // init # of cards..
        deck = malloc(sizeof(NSInteger) * 52);
        for (NSInteger n = 0; n < 52; n++)
            deck[n] = -1;
        
        
    }
    return self;
}

@end
