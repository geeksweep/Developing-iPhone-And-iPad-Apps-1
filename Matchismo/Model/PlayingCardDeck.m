//
//  PlayingCardDeck.m
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"
@implementation PlayingCardDeck


-(id)init{
    self = [super init];
    if(self){
        for(NSString *suit in [PlayingCard validSuits]){
            for(NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++){
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card atTop:YES];
            }
        }
    }
    
    return self;
}


@end
