//
//  TweetCell.m
//  twitter
//
//  Created by emilyabest on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "TimelineViewController.h"
#import "APIManager.h"

// [2] Define a custom table view cell and set it’s reuse identifier
@interface TweetCell ()

@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 User tapped the favorite button
 */
- (IBAction)didTapFavorite:(id)sender {
    
    // If tweet is currently favorited
    if(self.tweet.favorited) {
        // Update the favorite count and symbol to favorited
        self.tweet.favorited = NO;
        self.favoritedCount.text = [@(--self.tweet.favoriteCount) stringValue];
        
        [sender setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    // Else, tweet is currently unfavorited
    else {
        // Update the favorite count and symbol to favorited
        self.tweet.favorited = YES;
        self.favoritedCount.text = [@(++self.tweet.favoriteCount) stringValue];
        
        [sender setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];

    }
    
    
    // Update cell UI
//    [self refreshData];

    // Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"Successfully favorited the followint Tweet: %@", tweet.text);
        } else {
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
    }];
}

- (void)refreshData {
    self.favoritedCount.text = [@(self.tweet.favoriteCount) stringValue];
//    self.favoritedButton.currentImage
}

@end
