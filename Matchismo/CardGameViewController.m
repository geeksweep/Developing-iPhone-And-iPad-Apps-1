//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Chad Saxon on 8/3/13.
//  Copyright (c) 2013 GeekSweep Studios LLC. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import <QuartzCore/QuartzCore.h>

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode;
@property (nonatomic) BOOL flippedFirstCard;
@property (weak, nonatomic) IBOutlet UISlider *cardFlipHistorySlider;
@property (nonatomic) int updatedSliderValue;
@property (strong, nonatomic) NSString *flipResults;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) UIImage *cardBackImage;
@property (strong, nonatomic) UIAlertView *gameOverAlertView;

@end

@implementation CardGameViewController

-(void)viewDidLoad{
    self.cardBackImage = [UIImage imageNamed:@"cardImage.jpg"];
    [self.matchMode addTarget:self action:@selector(changedCardGameMode:) forControlEvents:UIControlEventValueChanged];
    [self.cardFlipHistorySlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self updateUI];
}


-(CardMatchingGame *)game{
    if(!_game){
        NSLog(@"init game");
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
        NSLog(@"initialized game");
        _game.gameMode = 1;
        self.cardFlipHistorySlider.minimumValue = 0.0;
        self.cardFlipHistorySlider.maximumValue = 0.0;
    }
    return _game;
}

-(void)setCardButtons:(NSArray *)cardButtons{
    NSLog(@"setting card buttons");
    _cardButtons = cardButtons;
}

-(void)changedCardGameMode:(UISegmentedControl *)sender{
    if(sender.selectedSegmentIndex == 0){
        //2-card match
        [self.game setGameMode:1];
    }
    else if(sender.selectedSegmentIndex == 1){
        //3 card match
        [self.game setGameMode:2];
    }
}

-(void)sliderChanged:(UISlider *)sender{
    NSLog(@"slider action called with sender value of %f", sender.value);
    self.activityLabel.alpha = 0.3;
    self.activityLabel.text = [self.game flipHistoryWithScrollValue:sender.value];
    
}

-(void)updateUI{
    
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        if([cardButton isEnabled]){
            //reset the border of the cards here for a new game.
            cardButton.layer.borderWidth = 0.0;
        }
        UIImage *backgroundImage = (!cardButton.selected) ? self.cardBackImage : nil;
        [cardButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.activityLabel.alpha = 1.0;
    self.activityLabel.text = self.game.flipContents;
    self.cardFlipHistorySlider.maximumValue = [self.game numberOfRecordedFlips];
    if(!self.cardFlipHistorySlider.maximumValue){
        self.cardFlipHistorySlider.enabled = NO;
    }
    else{
        self.cardFlipHistorySlider.enabled = YES;
    }
    [self.cardFlipHistorySlider setValue:self.cardFlipHistorySlider.maximumValue animated:YES];
    if(!self.flippedFirstCard){
        self.matchMode.enabled = YES;
    }
    else{
        self.matchMode.enabled = NO;
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //we only have one button so need to check specific buttons here.
    //turn over remaining cards, make them unplayable and draw border around them to show what cards were remaining.
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if([cardButton isEnabled]){
            card.faceUp = YES;
            card.isunplayable = YES;
            cardButton.layer.borderWidth = 2.0;
            cardButton.layer.cornerRadius = 6.0;
            cardButton.layer.borderColor = [[UIColor redColor] CGColor];
        }
    }

    [self updateUI];
}

- (IBAction)dealNewGame:(UIButton *)sender {
    
    self.game = nil;
    self.matchMode.selectedSegmentIndex = 0;
    [self.game startNewGame];
    self.flippedFirstCard = NO;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    
    self.activityLabel.text = @"";
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flippedFirstCard = YES;
    [self updateUI];
    
    
    if(self.game.gameOver){
        //show alert button
        NSLog(@"game is over, show alert view");
        self.gameOverAlertView = [[UIAlertView alloc]initWithTitle:@"Game Alert!" message:@"There are no more matches possible! Game Over." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [self.gameOverAlertView show];
    }
}

@end
