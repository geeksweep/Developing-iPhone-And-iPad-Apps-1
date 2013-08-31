//
//  Deck.m
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "Deck.h"
@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation Deck

-(NSMutableArray *)cards{
    
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    if(atTop){
        [self.cards insertObject:card atIndex:0];
    }
    else{
        [self.cards addObject:card];
    }
}


-(Card *)drawRandomCard{
    
    Card *randomCard = nil;
    
    if(self.cards.count){
        int index = arc4random() % self.cards.count;
        randomCard = [[self cards] objectAtIndex:index]; //or self.cards[index] - bracket notation for iOS6
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}


@end
