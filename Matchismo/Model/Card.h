//
//  Card.h
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL isunplayable;


-(int)match:(NSArray *)otherCards;
-(BOOL)areMoreMatchesPossibleWithRemainingCards:(NSMutableArray *)cards withGameMode:(int)gameMode;

@end
