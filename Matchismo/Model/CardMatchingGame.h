//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Chad Saxon on 8/4/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "PlayingCard.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *flipContents;
@property (readonly, nonatomic) NSMutableArray *flipHistoryMutableArray;
@property (nonatomic) int gameMode;
@property (readonly, nonatomic) BOOL gameOver;
//designated initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
-(void)flipCardAtIndex:(NSUInteger)index;
-(void)startNewGame;
-(Card *)cardAtIndex:(NSUInteger)index;
-(NSString *)flipHistoryWithScrollValue:(float)scrollValue;
-(int)numberOfRecordedFlips;

@end
