//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Chad Saxon on 8/4/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "CardMatchingGame.h"
@interface CardMatchingGame()

//readwrite is default.
@property (readwrite, nonatomic) int score;
@property (nonatomic) BOOL gameOver;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (strong, nonatomic) NSMutableArray *flippedCards;
@property (strong, nonatomic) NSMutableArray *flipHistoryMutableArray;
@property (strong, nonatomic) NSString *flipContents;
@property (nonatomic) float currentScrollValue;
-(BOOL)enoughMatchingSuits:(NSMutableArray *)filteredArray;
-(BOOL)enoughMatchingRanks:(NSMutableArray *)filteredArray;
-(BOOL)enoughMatchingSuitsOrRanksWithArray:(NSMutableArray *)filteredArray;
-(BOOL)areMoreMatchesPossible;
-(NSArray *)currentCardsPlayable;

@end

@implementation CardMatchingGame

-(NSMutableArray *)cards{
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

-(NSMutableArray *)flippedCards{
    if(!_flippedCards){
        _flippedCards = [[NSMutableArray alloc] init];
    }
    
    return _flippedCards;
}

-(NSMutableArray *)flipHistoryMutableArray{
    if(!_flipHistoryMutableArray){
        _flipHistoryMutableArray = [[NSMutableArray alloc] init];
    }
    
    return _flipHistoryMutableArray;
}

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    
    self = [super init];
    if(self){
        for(int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if(card)
                self.cards[i] = card;  //new in iOS6;
            else{
                self = nil;
                break;
            }
        }
    }
    
    self.gameMode = 1;
    
    return self;
}

//filter out all of the cards that are currenlty playable
-(NSArray *)currentCardsPlayable{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isunplayable == %i", 0];
    NSArray *filteredArray = [self.cards filteredArrayUsingPredicate:predicate];
    NSLog(@"Number of Card Playable: %i", [filteredArray count]);
    return filteredArray;
}

-(NSString *)flipHistoryWithScrollValue:(float)scrollValue{
    int value = (int)scrollValue - 1;
    if(value < 0){
        value = 0;
    }
    return [self.flipHistoryMutableArray objectAtIndex:value];
}


-(int)numberOfRecordedFlips{
    return [self.flipHistoryMutableArray count];
}

-(void)startNewGame{
    
    self.score = 0;
    self.flipContents = @"";
    self.gameMode = 1;
    self.gameOver = NO;
    [self.flippedCards removeAllObjects];
    [self.flipHistoryMutableArray removeAllObjects];
    for(Card *cards in self.cards){
        if(cards.isFaceUp)
            cards.faceUp = !cards.faceUp;
        if(cards.isUnplayable){
            cards.isunplayable = !cards.isunplayable;
        }
    }
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1


-(void)flipCardAtIndex:(NSUInteger)index{
    self.flipContents = @"";
    Card * card = [self cardAtIndex:index];
    if(card && !card.isUnplayable){
        if(!card.isFaceUp){
                if([self.flippedCards count] == self.gameMode){
                    int matchScore = [card match:self.flippedCards];
                    NSString *otherCardsContents = @"";
                    if(matchScore){
                        for(Card *otherCards in self.flippedCards){
                            otherCards.isunplayable = YES;
                            otherCardsContents = [[otherCardsContents stringByAppendingString:@"& "] stringByAppendingString:[otherCards contents]];
                        }
                        card.isunplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"Matched %@%@ for %i points.", [card contents], otherCardsContents, matchScore * MATCH_BONUS]];
                        [self.flippedCards removeAllObjects];
                        if(![card areMoreMatchesPossibleWithRemainingCards:[[self currentCardsPlayable] mutableCopy] withGameMode:self.gameMode]){
                            NSLog(@"No more matches left");
                            self.gameOver = YES;
                        }
                    }
                    else{
                        for(Card *otherCards in self.flippedCards){
                            otherCards.faceUp = NO;
                            otherCardsContents = [[otherCardsContents stringByAppendingString:@"& "] stringByAppendingString:[otherCards contents]];
                        }
                        [self.flippedCards removeAllObjects];
                        [self.flippedCards addObject:card];
                        self.score -= MISMATCH_PENALTY;
                        self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"%@%@ don't match! %i point penalty!", [card contents], otherCardsContents, MISMATCH_PENALTY]];
                    }
                }
                else{
                    [self.flippedCards addObject:card];
                }
            
            self.score -= FLIP_COST;
            //You could also check for extra whitespaces here and trim them as needed.
            if([self.flipContents length] == 0)
                self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"Flipped up %@,  Lost 1 point", [card contents]]];
            [self.flipHistoryMutableArray addObject:self.flipContents];
        }
        else{
            [self.flippedCards removeObject:card];
        }
        card.faceUp = !card.isFaceUp;
        
    }
    
}
/*-(void)flipCardAtIndex:(NSUInteger)index{
    
    self.flipContents = @"";
    Card *card = [self cardAtIndex:index];
    if(card && !card.isUnplayable){
        if(!card.isFaceUp){
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    int matchScore = [card match:@[otherCard]]; //array with 1 item. create an array "right now". New for iOS6
                    if(matchScore){
                        card.isunplayable = YES;
                        otherCard.isunplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"Matched %@ & %@ for %i points.", [card contents], [otherCard contents], matchScore * MATCH_BONUS]];
                    }
                    else{
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"%@ and %@ don't match! %i point penalty!", [card contents], [otherCard contents], MISMATCH_PENALTY]];
                    }
                    
                    break;
                }
            }
            self.score -= FLIP_COST;
            //You could also check for extra whitespaces here and trim them as needed. 
            if([self.flipContents length] == 0)
                self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"Flipped up %@,  Lost 1 point", [card contents]]];
        }
        card.faceUp = !card.faceUp;
    }
 
}*/

-(Card *)cardAtIndex:(NSUInteger)index{

    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}


@end
