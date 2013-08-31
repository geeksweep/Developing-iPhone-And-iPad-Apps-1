//
//  PlayingCard.m
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()

@property (nonatomic) int gameMode;
-(BOOL)enoughMatchingSuits:(NSMutableArray *)filteredArray;
-(BOOL)enoughMatchingRanks:(NSMutableArray *)filteredArray;
-(BOOL)enoughMatchingSuitsOrRanksWithArray:(NSMutableArray *)filteredArray;

@end

@implementation PlayingCard

@synthesize suit = _suit;

-(NSString *)contents{
    
    NSArray *rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+(NSArray *)validSuits{
    
    return @[@"♥", @"♦", @"♠", @"♣"];
    
}

+(NSArray *)rankStrings{
    
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+(NSUInteger)maxRank{
    return [self rankStrings].count -1;
}

-(void)setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

-(void)setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

-(NSString *)suit{
    return _suit ? _suit : @"?";
}

//1. Loops through the remaining cards that are playable to see if we have enough of a certain rank to keep playing
//2. We write a predicate here to filter out each rank to see if we have enough for either a 2 card or 3 card match
//3. Once we find enough we immediately return and don't bother checking the rest of the cards.
//4. We also want to super duper optimize this method. In the case of a 3 card game (or a 20 card game for that matter)
//   we don't want to run the predicate again on a rank that we have already checked previously. We build up a duplicateArray
//   to keep up with cards with specific rank counts greater than 2 in the 3-game mode and then check against that PlayingCard *card
//   object to see if we have already ran the predicate for that particular rank. Obviously for 3 cards this isn't really going to matter
//   as far as optimization but maybe in the future we would have a 100 card game or 1,000.(HAHA, who knows.)
-(BOOL)enoughMatchingRanks:(NSMutableArray *)filteredArray{
    
    NSArray *validRanks = [PlayingCard rankStrings];
    NSMutableArray *duplicateArray = [NSMutableArray array];
    
    for(PlayingCard *card in filteredArray){
        if(![duplicateArray containsObject:[NSNumber numberWithInt:card.rank]]){
            NSPredicate *rankPredicate = [NSPredicate predicateWithFormat:@"rank == %i", card.rank];
            NSArray *rankFilteredArray = [filteredArray filteredArrayUsingPredicate:rankPredicate];
            NSLog(@"rank array predicate count %i for %@", [rankFilteredArray count], [validRanks objectAtIndex:card.rank]);
            
            if(self.gameMode == 1){
                if([rankFilteredArray count] >= 2)
                    return YES;
            }
            else if(self.gameMode == 2){
                if([rankFilteredArray count] >= 3){
                    return YES;
                }
                else{
                    if([rankFilteredArray count] >= 2)
                        [duplicateArray addObject:[NSNumber numberWithInt:card.rank]];
                }
            }
        }
    }
    return NO;
}

//1. Loops through the remaining cards that are playable to see if we have enough of a certain suit to keep playing
//2. We write a predicate here to filter out each suit to see if we have enough for either a 2 card or 3 card match
//3. Once we find enough we immediately return and don't bother checking the rest of the cards.
-(BOOL)enoughMatchingSuits:(NSMutableArray *)filteredArray{
    
    NSArray *validSuits = [PlayingCard validSuits];
    for(NSString *suit in validSuits){
        NSPredicate *suitPredicate = [NSPredicate predicateWithFormat:@"suit == %@", suit];
        NSArray *suitFilteredArray = [filteredArray filteredArrayUsingPredicate:suitPredicate];
        NSLog(@"suit array predicate count %i for suit %@", [suitFilteredArray count], suit);
        
        
        if(self.gameMode == 1){
            if([suitFilteredArray count] >= 2)
                return YES;
        }
        else if(self.gameMode == 2){
            if([suitFilteredArray count] >= 3)
                return YES;
        }
    }
    return NO;    
}

//1. Check to see if we have either enough suits or ranks to keep playing.
//2. It is easier to start off checking for suits than ranks so we will check suits first in the 'OR' statement below in the code.
-(BOOL)enoughMatchingSuitsOrRanksWithArray:(NSMutableArray *)filteredArray{
    
    if([self enoughMatchingSuits:filteredArray] || [self enoughMatchingRanks:filteredArray]){
        return YES;
    }
    
    return NO;
    
}

//1. We want to check to see if there are even more matches possible
//2. We dont want to keep flipping over cards, losing more points if we can't get more matches
-(BOOL)areMoreMatchesPossibleWithRemainingCards:(NSMutableArray *)cards withGameMode:(int)gameMode{
    
    self.gameMode = gameMode;
    if([self enoughMatchingSuitsOrRanksWithArray:cards]){
        return YES;
    }
    
    return NO;
}

-(int)match:(NSArray *)otherCards{
    
    int score = 0;
    //I want to keep fast enumeration instead of opting for the classical for loop so I will use this local index to check the first match.
    //Yeah I know about pre-mature optimization but still. - Need to run some analytics for how much slower this would run with the classical for-loop. 
    int cardIndex = 0;
    BOOL shouldMatchSuit;
    
    //Search the first 2 cards to see whether they match suit or rank. For all other cards (doesn't matter whether we are in a 3-card match or even more, we have to check to see
    //if the remaining cards also match the same suit or rank. Please note that this algorithm requires that the player match ALL cards either with the same suit or rank. There are
    //not partial points/partial matches. If you don;t match the remaining card(s) by suit or rank your score is set back to 0 and we break out of the loop.
    
    for(PlayingCard *card in otherCards){
        if(cardIndex == 0){
            if(card.suit == self.suit){
                score += 1;
                shouldMatchSuit = YES;
            }
            else if(card.rank == self.rank){
                shouldMatchSuit = NO;
                score += 4;
            }
            cardIndex++;
        }
        else{
            if(shouldMatchSuit){
                if(card.suit == self.suit){
                    score += score * 4;
                }
                else{
                    score = 0;
                    break;
                }
            }
            else{
                if(card.rank == self.rank){
                    score += score * 8;
                }
                else{
                    score = 0;
                    break;
                }
            }
        }
        
    }
    
    return score;
}

@end
