//
//  Deck.h
//  Lecture1_Stanford_IOS_Winter2013
//
//  Created by Chad Saxon on 8/2/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(Card *)drawRandomCard;
@end
