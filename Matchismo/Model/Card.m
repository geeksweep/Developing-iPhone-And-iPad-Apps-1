//
//  Card.m
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card


-(int)match:(NSArray *)otherCards{
    
    int score = 0;
    
    for(Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }

    return score;
}

-(BOOL)areMoreMatchesPossibleWithRemainingCards:(NSMutableArray *)cards withGameMode:(int)gameMode{
    
    
    return NO;
}



@end
